//
//  RestaurantMapView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/10.
//

import SwiftUI
import MapKit

struct RestaurantMapView: View {
    @StateObject private var viewModel = RestaurantManagementViewModel()
    @State private var cameraPosition: MapCameraPosition
    @State private var selectedRestaurant: Restaurant?
    @State private var isCardVisible = false
    @State private var selectedCategory: RestaurantCategory?
    @State private var selectedRestaurantId: String?
    @State private var searchText = ""
    
    init() {
        let initialRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 24.179860, longitude: 120.646325),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        )
        _cameraPosition = State(initialValue: .region(initialRegion))
    }
    
    var categories: [RestaurantCategory] {
        Array(Set(viewModel.restaurants.flatMap { $0.categories })).sorted { $0.rawValue < $1.rawValue }
    }
    
    var filteredRestaurants: [Restaurant] {
        viewModel.filteredRestaurants(searchText: searchText).filter { restaurant in
            guard let selectedCategory = selectedCategory else { return true }
            return restaurant.categories.contains(selectedCategory)
        }
    }
    
    var body: some View {
        ZStack {
            Map(position: $cameraPosition, selection: $selectedRestaurantId) {
                ForEach(filteredRestaurants) { restaurant in
                    Annotation("", coordinate: restaurant.coordinate, anchor: .top) {
                        RestaurantAnnotationView(restaurant: restaurant, isSelected: selectedRestaurantId == restaurant.id)
                            .onTapGesture {
                                selectRestaurant(restaurant)
                            }
                    }
                    .tag(restaurant.id)
                }
            }
            .mapStyle(.standard(elevation: .flat, emphasis: .automatic, pointsOfInterest: .excludingAll, showsTraffic: false))
            .ignoresSafeArea()
            .onTapGesture { _ in
                withAnimation {
                    selectedRestaurant = nil
                    isCardVisible = false
                    selectedRestaurantId = nil
                }
            }
            .onChange(of: selectedRestaurantId) { _, newValue in
                if let id = newValue,
                   let restaurant = filteredRestaurants.first(where: { $0.id == id }) {
                    selectRestaurant(restaurant)
                }
            }
            
            VStack {
                CategoryFilterView(categories: categories, selectedCategory: $selectedCategory)
                Spacer()
                if isCardVisible, let restaurant = selectedRestaurant {
                    RestaurantCardView(restaurant: restaurant)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: selectedCategory) {
            resetSelection()
        }
        .onAppear {
            viewModel.fetchRestaurants()
            resetSelection()
        }
    }
    
    private func resetSelection() {
        selectedRestaurant = nil
        isCardVisible = false
        selectedRestaurantId = nil
        resetCameraPosition()
    }
    
    private func resetCameraPosition() {
        cameraPosition = .region(MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 24.179860, longitude: 120.646325),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    private func selectRestaurant(_ restaurant: Restaurant) {
        withAnimation {
            selectedRestaurant = restaurant
            isCardVisible = true
            selectedRestaurantId = restaurant.id
            zoomToRestaurant(restaurant)
        }
    }
    
    private func zoomToRestaurant(_ restaurant: Restaurant) {
        withAnimation {
            cameraPosition = .region(MKCoordinateRegion(
                center: restaurant.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            ))
        }
    }
}


struct CategoryButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("#\(text)")
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.blue : Color.white)
                .foregroundColor(isSelected ? .white : .blue)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}


#Preview{
    RestaurantMapView()
}
