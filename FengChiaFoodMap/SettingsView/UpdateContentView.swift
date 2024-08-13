//
//  UpdateContentView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct UpdateContentView: View {
    var body: some View {
        ScrollView{
            VStack(alignment: .leading) {
                ForEach(updates) { update in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("版本 \(update.version)")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Text(update.date)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        
                        Text(update.content)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.vertical, 5)
                        
                        Divider()
                    }
                    .padding(.horizontal)
                }
                Spacer()
            }
            .padding(.top, 20)
            .navigationTitle("更新內容")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    UpdateContentView()
}
