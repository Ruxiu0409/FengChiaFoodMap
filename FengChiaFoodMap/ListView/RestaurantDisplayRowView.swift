//
//  RestaurantDisplayRowView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct RestaurantDisplayRowView: View {
    var restaurant: Restaurant
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 12) {
            RoundedRectangle(cornerRadius: 20)
                .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.6), Color.purple.opacity(0.6)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(height: 160)
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(restaurant.name)
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.primary)
                
                Text(categoryText())
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "clock")
                        .foregroundColor(.secondary)
                    
                    if let openingHoursToday = getTodayOpeningHours() {
                        Text("營業時間: \(formatTimeRange(openTime: openingHoursToday.openTime, closeTime: openingHoursToday.closeTime))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("今日休息")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
            .padding([.leading, .trailing, .bottom], 16)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .gray.opacity(0.2), radius: 10, x: 0, y: 5)
        
    }
    
    private func categoryText() -> String {
        return restaurant.categories.map { "#\($0.rawValue)" }.joined(separator: " ")
    }
    
    private func getTodayOpeningHours() -> OpeningHours? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "zh_Hant")
        let today = dateFormatter.string(from: Date())
        return restaurant.openingHours.first { $0.day == today }
    }
    
    private func formatTimeRange(openTime: Date, closeTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "zh_Hant")
        return "\(formatter.string(from: openTime)) - \(formatter.string(from: closeTime))"
    }
}

