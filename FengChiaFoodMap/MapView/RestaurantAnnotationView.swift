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
    let zoomLevel: Double
    
    var categoryIcon: String {
        if restaurant.categories.contains(.drink) {
            return "cup.and.saucer.fill"
        } else {
            return "fork.knife"
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                Image(systemName: "circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundColor(categoryIcon == "cup.and.saucer.fill" ? .blue : .red)
                
                Image(systemName: categoryIcon)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            .background(Color.white.opacity(0.8))
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            
            if zoomLevel > 18 {
                Text(restaurant.name)
                    .font(.system(size: nameFontSize))
                    .fontWeight(.bold)
                    .padding(4)
            }
            
            if let rating = restaurant.rating {
                Text(String(format: "%.1f", rating))
                    .font(.caption2)
                    .foregroundColor(.yellow)
                    .padding(2)
                    .background(Color.black.opacity(0.7))
                    .clipShape(Capsule())
            }
        }
        .scaleEffect(isSelected ? 1.2 : 1.0)
        .shadow(radius: 5)
        .frame(maxWidth: .infinity, maxHeight: 70)
        //.frame(width: frameSize, height: frameSize)
        //.contentShape(Rectangle())
        //.accessibilityLabel(Text("\(restaurant.name), \(restaurant.categories.map { $0.localizedName }.joined(separator: ", "))"))
    }
    
    private var iconSize: CGFloat {
        max(20, min(30, 20 + (zoomLevel - 14) * 5))
    }
    
    private var nameFontSize: CGFloat {
        max(8, min(12, 8 + (zoomLevel - 15) * 2))
    }
    
    private var frameSize: CGFloat {
        iconSize * 1.5
    }
}

#Preview{
    RestaurantMapView()
}
