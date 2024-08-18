//
//  FengChiaFoodMapApp.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/10.
//

import SwiftUI
import Firebase
import GoogleMobileAds


@main
struct FengChiaFoodMapApp: App {
    init(){
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.accent)
        }
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
