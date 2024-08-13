//
//  RestaurantMenuView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct RestaurantMenuView: View {
    var menu: [MenuItem]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(menu) { item in
                    MenuItemView(item: item)
                }
            }
            .padding()
        }
    }
}

