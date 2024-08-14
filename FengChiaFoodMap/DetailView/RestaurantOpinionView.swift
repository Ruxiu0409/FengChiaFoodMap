//
//  RestaurantOpinionView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct RestaurantOpinionView: View {
    var restaurant: Restaurant
    
    var body: some View {
        NavigationStack{
            ScrollView {
                HStack{
                    VStack(alignment: .leading, spacing: 24) {
                        opinionSection(title: "Dcard網友推薦", color: .blue, restaurant: restaurant, iconName: "DcardIcon", key: "Dcard")
                        opinionSection(title: "Instagram網友推薦", color: .pink, restaurant: restaurant, iconName: "InstagramIcon", key: "Instagram")
                        opinionSection(title: "部落格網友推薦", color: .green, restaurant: restaurant, iconName: "pencil.and.outline", key: "Blog")
                        BannerAD(unitID: "ca-app-pub-7821111038136141/4884083714")
                            .frame(height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                    .padding()
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    func opinionSection(title: String, color: Color, restaurant: Restaurant, iconName: String, key: String) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.headline)
                .foregroundColor(color)
                .padding(.leading)
            
            if let links = restaurant.websiteLinks[key] {
                ForEach(links) { link in
                    opinionCard(websiteInfo: link, color: color, iconName: iconName, isNewest: link == links.first)
                }
            } else {
                Text("暫無評價")
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
        }
    }
    
    func opinionCard(websiteInfo: WebsiteInfo, color: Color, iconName: String, isNewest: Bool) -> some View {
        NavigationStack{
            NavigationLink{
                WebView(url: websiteInfo.url)
            } label: {
                HStack(spacing: 16) {
                    if iconName == "pencil.and.outline" {
                        Image(systemName: iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 32, height: 32)
                            .foregroundColor(color)
                    } else {
                        Image(iconName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(radius: 3)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(websiteInfo.title)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)
                        Text("發布時間: \(formatDate(websiteInfo.publishDate))")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    if isNewest {
                        Text("最新")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .padding(6)
                            .background(Color.yellow)
                            .clipShape(Capsule())
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 3)
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

