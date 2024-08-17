//
//  RestaurantDetailView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/10.
//

import SwiftUI

struct RestaurantDetailView: View {
    var restaurant: Restaurant
    @State private var restaurantOpeningHoursButton: Bool = false
    @State private var currentPage: Int = 0
    @State private var showingMapOptions = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                VStack(spacing: 10) {
                    HStack{
                        Group{
                            Image(systemName: "control")
                                .rotationEffect(Angle(degrees: 270))
                            Text("返回")
                        }
                        .onTapGesture{
                            dismiss()
                        }
                        Spacer()
                    }
                    .foregroundStyle(.blue)
                    .padding(.horizontal)
                    
                    HStack {
                        Text(restaurant.name)
                            .font(.system(size: 24, weight: .medium))
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Group {
                            Image(systemName: "clock")
                            if let openingHoursToday = getTodayOpeningHours() {
                                Text("營業中，直到 \(formatTime(closeTime: openingHoursToday.closeTime))")
                            } else {
                                Text("今日休息")
                            }
                        }
                        .font(.system(size: 16))
                        Spacer()
                        Button {
                            restaurantOpeningHoursButton.toggle()
                        } label: {
                            HStack {
                                Text(restaurantOpeningHoursButton ? "顯示較少" : "查看更多")
                                    .foregroundStyle(.black)
                                Image(systemName: "control")
                                    .foregroundStyle(.black)
                                    .rotationEffect(.degrees(restaurantOpeningHoursButton ? 0 : 180))
                            }
                            .font(.system(size: 12))
                        }
                    }
                    .padding(.horizontal)
                    
                    if restaurantOpeningHoursButton {
                        VStack(alignment: .leading, spacing: 4) {
                            HStack{
                                VStack(alignment: .leading){
                                    ForEach(restaurant.openingHours) { openingHour in
                                        Text(openingHour.day)
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14, weight: .bold))
                                    }
                                }
                                Spacer()
                                VStack(alignment: .leading){
                                    ForEach(restaurant.openingHours) { openingHour in
                                        Text(formatTimeRange(openTime: openingHour.openTime, closeTime: openingHour.closeTime))
                                            .foregroundColor(.gray)
                                            .font(.system(size: 14, weight: .regular))
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }

                    HStack {
                        Image(systemName: "phone")
                        if restaurant.phoneNumber != "" {
                            Text(restaurant.phoneNumber)
                        }
                        else{
                            Text("尚無資料")
                        }
                        Spacer()
                    }
                    .font(.system(size: 16))
                    .padding(.horizontal)
                    .onTapGesture {
                        if let url = URL(string: "tel://\(restaurant.phoneNumber)"),
                           UIApplication.shared.canOpenURL(url) {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                    if restaurant.address != "" {
                        HStack{
                            Button(action: {
                                showingMapOptions = true
                            }) {
                                HStack{
                                    Image(systemName: "map")
                                    Text(restaurant.address)
                                }
                                .font(.system(size: 16))
                                .padding(.horizontal)
                            }
                            Spacer()
                        }
                        .tint(.black)
                    }
                    else{
                        HStack{
                            Image(systemName: "map")
                            Text("尚無資料")
                        }
                        .font(.system(size: 16))
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                        .frame(height: 10)
                }
                
                HStack {
                    Button {
                        withAnimation {
                            currentPage = 0
                        }
                    } label: {
                        VStack {
                            Text("評價")
                                .foregroundStyle(currentPage == 0 ? .black : .gray)
                            Rectangle()
                                .frame(height: 4)
                                .foregroundStyle(currentPage == 0 ? .black : .clear)
                        }
                    }
                    
                    Button {
                        withAnimation {
                            currentPage = 1
                        }
                    } label: {
                        VStack {
                            Text("菜單")
                                .foregroundStyle(currentPage == 1 ? .black : .gray)
                            Rectangle()
                                .frame(height: 4)
                                .foregroundStyle(currentPage == 1 ? .black : .clear)
                        }
                    }
                }
                .padding(.horizontal)
                
                TabView(selection: $currentPage) {
                    RestaurantOpinionView(restaurant: restaurant)
                        .tag(0)
                    RestaurantMenuView(menu: restaurant.menu)
                        .tag(1)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentPage)
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationBarBackButtonHidden(true)
        }
        .confirmationDialog("選擇開啟的地圖", isPresented: $showingMapOptions, titleVisibility: .visible) {
            Button("在地圖中顯示"){
                UIApplication.shared.open(restaurant.appleMapsLink!)
            }
            Button("在Google地圖中顯示"){
                UIApplication.shared.open(restaurant.googleMapsLink!)
            }
        }
    }
    
    private func getTodayOpeningHours() -> OpeningHours? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "zh_Hant")
        let today = dateFormatter.string(from: Date())
        return restaurant.openingHours.first { $0.day == today }
    }
    
    private func formatTime(closeTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale(identifier: "zh_Hant")
        return formatter.string(from: closeTime)
    }
    
    private func formatTimeRange(openTime: Date, closeTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return "\(formatter.string(from: openTime)) - \(formatter.string(from: closeTime))"
    }
}




#Preview{
    RestaurantListView(searchText: .constant(""))
}
