//
//  Update.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import Foundation

struct UpdateInfo: Identifiable {
    let id = UUID()
    var version: String
    var content: String
    var date: String
}

let updates: [UpdateInfo] = [
    UpdateInfo(version: "1.0.0", content: "逢甲美食地圖正式上架App Store", date: "2024-08-01")
]

