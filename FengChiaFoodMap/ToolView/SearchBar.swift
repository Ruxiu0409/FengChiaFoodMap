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
            TextField("搜尋餐廳或類別...", text: $text)
                .padding(8)
                .padding(.horizontal, 30)
                .background(Color(.systemGray6))
                .cornerRadius(100)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                        
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 10)
                            }
                        }
                    }
                )
        }
        .padding(.horizontal, 10)
    }
}


#Preview{
    ContentView()
}

