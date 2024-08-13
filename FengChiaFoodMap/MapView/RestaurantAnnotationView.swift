//
//  RestaurantAnnotationView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct RestaurantAnnotationView: View {
    let restaurant: Restaurant
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: "fork.knife.circle.fill")
                .resizable()
                .frame(width: 30, height: 30)
                .foregroundColor(.red)
                .background(Color.white.opacity(0.8))
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            Text(restaurant.name)
                .font(.caption)
                .fontWeight(.bold)
                .padding(4)
        }
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .shadow(radius: 5)
        .frame(width: .infinity, height: 70)
        .contentShape(Rectangle())  // 擴大點擊區域
    }
}
