//
//  Restaurant.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/10.
//

import Foundation
import FirebaseFirestore
import CoreLocation

struct OpeningHours: Codable, Identifiable {
    var id = UUID()
    var day: String
    var openTime: Date
    var closeTime: Date
}

enum RestaurantCategory: String, Codable, CaseIterable {
    case sandwich = "三明治"
    case chinese = "中式"
    case donburi = "丼飯"
    case bento = "便當"
    case wholeFood = "健康餐"
    case taiwanese = "台式"
    case japanese = "日式"
    case cafe = "咖啡"
    case curry = "咖哩"
    case sushi = "壽司"
    case snack = "小吃"
    case pizza = "披薩"
    case ramen = "拉麵"
    case breakfast = "早餐"
    case southeastAsian = "東南亞"
    case western = "歐美"
    case thai = "泰式"
    case hongKong = "港式"
    case soup = "湯品"
    case braised = "滷味"
    case burger = "漢堡"
    case hotPot = "火鍋"
    case friedRice = "炒飯"
    case friedChicken = "炸雞"
    case barbecue = "燒烤"
    case steak = "牛排"
    case donut = "甜甜圈"
    case dessert = "甜點"
    case exotic = "異國"
    case porridge = "粥"
    case vegetarian = "素食"
    case pasta = "義大利麵"
    case cake = "蛋糕"
    case tofuPudding = "豆花"
    case vietnamese = "越式"
    case teppanyaki = "鐵板燒"
    case korean = "韓式"
    case drink = "飲料"
    case dumpling = "餃子"
    case saltyCrispyChicken = "鹹酥雞/雞排"
    case noodle = "麵食"
    
    var localizedName: String {
        return NSLocalizedString(self.rawValue, comment: "")
    }
}

struct WebsiteInfo: Identifiable, Codable, Equatable {
    var id = UUID()
    var url: URL
    var title: String
    var publishDate: Date
}

struct MenuItem: Codable, Identifiable {
    var id = UUID()
    var name: String
    var price: Double
    var description: String?
    var isAvailable: Bool = true
}

struct Restaurant: Codable, Identifiable {
    @DocumentID var id: String?
    var name: String
    var phoneNumber: String
    var address: String
    var openingHours: [OpeningHours]
    var categories: [RestaurantCategory]
    var latitude: Double
    var longitude: Double
    var websiteLinks: [String: [WebsiteInfo]]
    var menu: [MenuItem]
    var googleMapsLink: URL?
    var appleMapsLink: URL?
    var rating: Double?
    var numberOfRatings: Int?
    var priceRange: String?
    var createdAt: Date
    var updatedAt: Date
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, phoneNumber, address, openingHours, categories, latitude, longitude, websiteLinks, menu, googleMapsLink, appleMapsLink, rating, numberOfRatings, priceRange, createdAt, updatedAt
    }
    
    init(id: String? = nil, name: String, phoneNumber: String, address: String, openingHours: [OpeningHours], categories: [RestaurantCategory], latitude: Double, longitude: Double, websiteLinks: [String: [WebsiteInfo]], menu: [MenuItem], googleMapsLink: URL? = nil, appleMapsLink: URL? = nil, rating: Double? = nil, numberOfRatings: Int? = nil, priceRange: String? = nil) {
        self.id = id
        self.name = name
        self.phoneNumber = phoneNumber
        self.address = address
        self.openingHours = openingHours
        self.categories = categories
        self.latitude = latitude
        self.longitude = longitude
        self.websiteLinks = websiteLinks
        self.menu = menu
        self.googleMapsLink = googleMapsLink
        self.appleMapsLink = appleMapsLink
        self.rating = rating
        self.numberOfRatings = numberOfRatings
        self.priceRange = priceRange
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

class RestaurantService {
    private let db = Firestore.firestore()
    
    func fetchRestaurants(completion: @escaping ([Restaurant]?, Error?) -> Void) {
        db.collection("restaurants").getDocuments { (querySnapshot, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            let restaurants = querySnapshot?.documents.compactMap { document -> Restaurant? in
                try? document.data(as: Restaurant.self)
            }
            
            completion(restaurants, nil)
        }
    }
    
    func addRestaurant(_ restaurant: Restaurant, completion: @escaping (Error?) -> Void) {
        do {
            _ = try db.collection("restaurants").addDocument(from: restaurant)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func updateRestaurant(_ restaurant: Restaurant, completion: @escaping (Error?) -> Void) {
        guard let id = restaurant.id else {
            completion(NSError(domain: "RestaurantService", code: 404, userInfo: [NSLocalizedDescriptionKey: "Restaurant ID is missing"]))
            return
        }
        
        do {
            var updatedRestaurant = restaurant
            updatedRestaurant.updatedAt = Date()
            try db.collection("restaurants").document(id).setData(from: updatedRestaurant)
            completion(nil)
        } catch {
            completion(error)
        }
    }
    
    func deleteRestaurant(id: String, completion: @escaping (Error?) -> Void) {
        db.collection("restaurants").document(id).delete { error in
            completion(error)
        }
    }
}
