//
//  CardView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct RestaurantCardView: View {
    let restaurant: Restaurant
    @State private var heights = HeightRecord()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        GeometryReader { _ in
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(restaurant.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(categoryText())
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "fork.knife.circle.fill")
                        .foregroundColor(.blue)
                        .font(.system(size: 30))
                }
                .padding()
                .background(Color(.systemBackground))
                .recordHeight(of: \.header)
                
                // Divider
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                
                // Body
                VStack(alignment: .leading, spacing: 12) {
                    infoRow(icon: "mappin.circle.fill", text: restaurant.address)
                    infoRow(icon: "clock.fill", text: openingHoursText())
                    infoRow(icon: "phone.fill", text: "電話: \(restaurant.phoneNumber)")
                }
                .padding()
                .background(Color(.systemBackground))
            }
            .cornerRadius(15)
            .padding()
            .recordHeight(of: \.all)
        }
        .onPreferenceChange(HeightRecord.self) {
            heights = $0
        }
        .presentationDetents([
            .height(heights.header ?? 10),
            .height(heights.all ?? 10)
        ])
        .interactiveDismissDisabled(true)
    }
    
    private func infoRow(icon: String, text: String) -> some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
            Text(text)
                .font(.subheadline)
        }
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

struct HeightRecord: Equatable {
    var header: CGFloat? = nil
    var all: CGFloat? = nil
}

extension HeightRecord: PreferenceKey {
    static var defaultValue = Self()
    static func reduce(value: inout Self, nextValue: () -> Self) {
        value.header = nextValue().header ?? value.header
        value.all = nextValue().all ?? value.all
    }
}

extension View {
    func recordHeight(of keyPath: WritableKeyPath<HeightRecord, CGFloat?>) -> some View {
        return self.background {
            GeometryReader { g in
                var record = HeightRecord()
                let _ = record[keyPath: keyPath] = g.size.height
                Color.clear
                    .preference(
                        key: HeightRecord.self,
                        value: record)
            }
        }
    }
}



#Preview {
    RestaurantMapView()
}
