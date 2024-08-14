//
//  HideKeyboard.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/14.
//

import SwiftUI

struct HideKeyboard: View {
    var body: some View {
        Color.clear
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            .ignoresSafeArea()
    }
}

#Preview {
    HideKeyboard()
}
