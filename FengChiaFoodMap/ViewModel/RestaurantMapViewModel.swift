//
//  RestaurantMapViewModel.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import Foundation

class RestaurantMapViewModel: ObservableObject {
    @Published var restaurants: [Restaurant] = []
    private let service = RestaurantService()
    
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
