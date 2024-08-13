//
//  CategoryFilterView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct CategoryFilterView: View {
    let categories: [RestaurantCategory]
    @Binding var selectedCategory: RestaurantCategory?
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                CategoryButton(text: "全部", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                .padding(.vertical)
                
                ForEach(categories, id: \.self) { category in
                    CategoryButton(text: category.localizedName, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                    .padding(.vertical)
                }
            }
            .padding(.horizontal)
        }
    }
}

