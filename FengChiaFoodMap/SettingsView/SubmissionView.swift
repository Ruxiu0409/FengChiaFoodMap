//
//  SubmissionView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI

struct SubmissionView: View {
    var body: some View {
        WebView(url: URL(string: "https://forms.gle/4rhKxaFcJuowZmY2A")!)
            .ignoresSafeArea()
    }
}

#Preview {
    SubmissionView()
}
