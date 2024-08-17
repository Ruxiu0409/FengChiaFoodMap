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
    @State private var showingMapOptions = false
    @State private var currentPage = 0
    @State private var showDetailView = false
    @State private var selectedDetent = PresentationDetent.height(200)
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
                    HStack{
                        Image(systemName: "fork.knife.circle.fill")
                            .font(.system(size: 30))
                        Image(systemName: "control")
                            .rotationEffect(Angle(degrees: 90))
                    }
                    .foregroundColor(.blue)
                    .onTapGesture {
                        showDetailView = true
                    }
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
                        .onTapGesture {
                            showingMapOptions = true
                        }
                    infoRow(icon: "clock.fill", text: openingHoursText())
                    infoRow(icon: "phone.fill", text: "電話: \(restaurant.phoneNumber)")
                        .onTapGesture {
                            if let url = URL(string: "tel://\(restaurant.phoneNumber)"),
                               UIApplication.shared.canOpenURL(url) {
                                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                            }
                        }
                    
                }
                .padding()
                .background(Color(.systemBackground))
                .confirmationDialog("選擇開啟的地圖", isPresented: $showingMapOptions, titleVisibility: .visible) {
                    Button("在地圖中顯示"){
                        UIApplication.shared.open(restaurant.appleMapsLink!)
                    }
                    Button("在Google地圖中顯示"){
                        UIApplication.shared.open(restaurant.googleMapsLink!)
                    }
                }
            }
            .cornerRadius(15)
            .padding()
            .recordHeight(of: \.all)
        }
        .onPreferenceChange(HeightRecord.self) {
            heights = $0
        }
        .presentationDetents([
            .height(200),
            .height(heights.header ?? 10)
        ],selection: $selectedDetent
        )
        .interactiveDismissDisabled(true)
        .fullScreenCover(isPresented: $showDetailView){
            RestaurantDetailView(restaurant: restaurant)
        }
        
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
    
    private func formatTimeRange(openTime: Date, closeTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: openTime)) - \(formatter.string(from: closeTime))"
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
