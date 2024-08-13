//
//  CardView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct RestaurantCardView: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(restaurant.name)
                .font(.title2)
                .fontWeight(.bold)
            Text(categoryText())
                .font(.subheadline)
                .foregroundColor(.secondary)
            Text(restaurant.address)
                .font(.subheadline)
            HStack {
                Text(openingHoursText()) // 這裡只顯示今天的營業時間
                Spacer()
                Text("電話: \(restaurant.phoneNumber)")
            }
            .font(.caption)
            
            NavigationLink(destination: RestaurantDetailView(restaurant: restaurant)) {
                Text("查看店家資料")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(15)
        .shadow(radius: 5)
        .padding()
    }
    
    // 返回今天的營業時間
    private func getTodayOpeningHours() -> OpeningHours? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "zh_Hant")
        let today = dateFormatter.string(from: Date())
        return restaurant.openingHours.first { $0.day == today }
    }
    
    private func categoryText() -> String {
        let categories = restaurant.categories.map { "#\($0.localizedName)" }
        return categories.joined(separator: " ")
    }
    
    private func openingHoursText() -> String {
        if let todayHours = getTodayOpeningHours() {
            return "今日營業時間: \(formatTime(todayHours.openTime)) - \(formatTime(todayHours.closeTime))"
        } else {
            return "今日休息"
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}


