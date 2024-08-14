//
//  RestaurantDisplayRowView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/10.
//

import SwiftUI

struct RestaurantListView: View {
    @StateObject private var viewModel = RestaurantListViewModel()
    @Binding var searchText:String
    
    
    var body: some View {
        NavigationStack {
            VStack {
                List(viewModel.filteredRestaurants(searchText: searchText)) { restaurant in
                    NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                        RestaurantDisplayRowView(restaurant: restaurant)
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
            }
//            .navigationTitle("逢甲美食地圖")
//            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.fetchRestaurants()
        }
    }
}




#Preview {
    RestaurantListView(searchText: .constant(""))
}
