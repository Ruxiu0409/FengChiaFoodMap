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
            HStack(spacing: 12) {
                CategoryButton(text: "全部", isSelected: selectedCategory == nil) {
                    selectedCategory = nil
                }
                
                ForEach(categories, id: \.self) { category in
                    CategoryButton(text: category.localizedName, isSelected: selectedCategory == category) {
                        selectedCategory = category
                    }
                }
            }
            .padding()
        }
    }
}

struct CategoryButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("# \(text)")
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? .accent : .white)
                .foregroundColor(isSelected ? .white : .accent)
                .cornerRadius(20)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview{
    ContentView()
}
