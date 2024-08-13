//
//  RestaurantDisplayRowView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/10.
//

import SwiftUI

struct RestaurantListView: View {
    @StateObject private var viewModel = RestaurantListViewModel()
    @State private var searchText = ""
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            
            VStack {
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                
                List(viewModel.filteredRestaurants(searchText: searchText)) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                        RestaurantDisplayRowView(restaurant: restaurant)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("逢甲美食地圖")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        RestaurantMapView()
                    } label: {
                        Image(systemName: "map")
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        showSettings = true
                    }label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showSettings) {
            NavigationStack {
                SettingView(viewModel: viewModel.authViewModel)
            }
        }
        .onAppear {
            viewModel.fetchRestaurants()
        }
    }
}




#Preview {
    RestaurantListView()
}
