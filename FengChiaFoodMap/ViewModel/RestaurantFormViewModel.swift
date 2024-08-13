//
//  RestaurantFormViewModel.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import Foundation
import Firebase
import FirebaseFirestore

class RestaurantFormViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var address: String = ""
    @Published var latitude: Double = 0
    @Published var longitude: Double = 0
    @Published var categories: [RestaurantCategory] = []
    @Published var openingHours: [OpeningHours] = []
    @Published var menu: [MenuItem] = []
    @Published var googleMapsLink: URL?
    @Published var appleMapsLink: URL?
    @Published var rating: Double?
    @Published var numberOfRatings: Int?
    @Published var priceRange: String?
    @Published var websiteLinks: [String: [WebsiteInfo]] = [:]
    
    private var id: String?
    var isNewRestaurant: Bool { id == nil }
    
    init(mode: RestaurantFormView.Mode) {
        switch mode {
        case .add:
            break
        case .edit(let restaurant):
            id = restaurant.id
            name = restaurant.name
            phoneNumber = restaurant.phoneNumber
            address = restaurant.address
            latitude = restaurant.latitude
            longitude = restaurant.longitude
            categories = restaurant.categories
            openingHours = restaurant.openingHours
            menu = restaurant.menu
            googleMapsLink = restaurant.googleMapsLink
            appleMapsLink = restaurant.appleMapsLink
            rating = restaurant.rating
            numberOfRatings = restaurant.numberOfRatings
            priceRange = restaurant.priceRange
            websiteLinks = restaurant.websiteLinks
        }
    }
    
    func createRestaurant() -> Restaurant {
        return Restaurant(
            id: id,
            name: name,
            phoneNumber: phoneNumber,
            address: address,
            openingHours: openingHours,
            categories: categories,
            latitude: latitude,
            longitude: longitude,
            websiteLinks: websiteLinks,
            menu: menu,
            googleMapsLink: googleMapsLink,
            appleMapsLink: appleMapsLink,
            rating: rating,
            numberOfRatings: numberOfRatings,
            priceRange: priceRange
        )
    }
    
    func addWebsiteLink(for category: String, link: WebsiteInfo) {
        if websiteLinks[category] == nil {
            websiteLinks[category] = []
        }
        websiteLinks[category]?.append(link)
    }
    
    func removeWebsiteLink(for category: String, at index: Int) {
        websiteLinks[category]?.remove(at: index)
        if websiteLinks[category]?.isEmpty == true {
            websiteLinks.removeValue(forKey: category)
        }
    }
    
    func addOpeningHours() {
        openingHours.append(OpeningHours(day: "星期一", openTime: Date(), closeTime: Date()))
    }
    
    func removeOpeningHours(at offsets: IndexSet) {
        openingHours.remove(atOffsets: offsets)
    }
    
    func moveOpeningHours(from source: IndexSet, to destination: Int) {
        openingHours.move(fromOffsets: source, toOffset: destination)
    }
    
    func addMenuItem() {
        menu.append(MenuItem(name: "", price: 0, description: nil, isAvailable: true))
    }
    
    func removeMenuItem(at offsets: IndexSet) {
        menu.remove(atOffsets: offsets)
    }
}
