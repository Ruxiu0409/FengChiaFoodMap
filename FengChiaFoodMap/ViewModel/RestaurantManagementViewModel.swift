//
//  RestaurantManagementViewModel.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import Foundation
import Firebase
import FirebaseFirestore

class RestaurantManagementViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    private let service = RestaurantService()
    let authViewModel: AuthViewModel
    
    init(authViewModel: AuthViewModel = AuthViewModel()) {
        self.authViewModel = authViewModel
    }
    
    func fetchRestaurants() {
        isLoading = true
        service.fetchRestaurants { [weak self] fetchedRestaurants, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                if let error = error {
                    self?.errorMessage = "獲取餐廳列表失敗：\(error.localizedDescription)"
                    return
                }
                self?.restaurants = fetchedRestaurants ?? []
            }
        }
    }
    
    func addRestaurant(_ restaurant: Restaurant) {
        service.addRestaurant(restaurant) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "添加餐廳失敗：\(error.localizedDescription)"
                    return
                }
                self?.fetchRestaurants()
            }
        }
    }
    
    func updateRestaurant(_ restaurant: Restaurant) {
        service.updateRestaurant(restaurant) { [weak self] error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = "更新餐廳失敗：\(error.localizedDescription)"
                    return
                }
                self?.fetchRestaurants()
            }
        }
    }
    
    func deleteRestaurant(at offsets: IndexSet) {
        let restaurantsToDelete = offsets.map { restaurants[$0] }
        for restaurant in restaurantsToDelete {
            guard let id = restaurant.id else { continue }
            service.deleteRestaurant(id: id) { [weak self] error in
                DispatchQueue.main.async {
                    if let error = error {
                        self?.errorMessage = "刪除餐廳失敗：\(error.localizedDescription)"
                        return
                    }
                    self?.fetchRestaurants()
                }
            }
        }
    }
    
    func filteredRestaurants(searchText: String) -> [Restaurant] {
        if searchText.isEmpty {
            return restaurants
        } else {
            return restaurants.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                restaurant.address.localizedCaseInsensitiveContains(searchText) ||
                restaurant.categories.contains { $0.localizedName.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
    
}
