//
//  RestaurantListViewModel.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import Foundation
import Firebase
import FirebaseFirestore

class RestaurantListViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    let authViewModel: AuthViewModel
    private let service = RestaurantService()
    
    init(authViewModel: AuthViewModel = AuthViewModel()) {
        self.authViewModel = authViewModel
    }
    
    func fetchRestaurants() {
        service.fetchRestaurants { [weak self] fetchedRestaurants, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error fetching restaurants: \(error.localizedDescription)")
                    return
                }
                self?.restaurants = fetchedRestaurants ?? []
            }
        }
    }
    
    func filteredRestaurants(searchText: String) -> [Restaurant] {
        if searchText.isEmpty {
            return restaurants
        } else {
            return restaurants.filter { restaurant in
                restaurant.name.localizedCaseInsensitiveContains(searchText) ||
                restaurant.categories.contains { $0.rawValue.localizedCaseInsensitiveContains(searchText) }
            }
        }
    }
}
