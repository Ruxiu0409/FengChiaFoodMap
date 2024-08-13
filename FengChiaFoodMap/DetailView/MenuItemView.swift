//
//  MenuItemView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct MenuItemView: View {
    var item: MenuItem
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(item.name)
                    .font(.system(size: 18, weight: .medium))
                Spacer()
                Text("$\(String(format: "%.2f", item.price))")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
            }
            
            if let description = item.description {
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            
            if !item.isAvailable {
                Text("暫時缺貨")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.red)
            }
            
            Divider()
        }
    }
}

#Preview {
    MenuItemView(item: MenuItem(name: "", price: 0))
}
