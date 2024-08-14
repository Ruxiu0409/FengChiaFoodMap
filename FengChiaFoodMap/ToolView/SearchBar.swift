//
//  SearchBar.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("搜尋餐廳或類別", text: $text)
                .padding(10)
                .padding(.horizontal, 30)
                .background(Color(.systemGray6))
                .cornerRadius(100)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                            }
                            //.contentShape(Rectangle()) // 擴大點擊區域
                            //.padding(10) // 增加額外的點擊範圍
                        }
                    }
                )
        }
        //.padding(.horizontal, 10) // 擴大整個搜索框的點擊區域
    }
}


#Preview{
    ContentView()
}

