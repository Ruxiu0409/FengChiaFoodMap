//
//  ContentView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/10.
//


import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @State private var isMapView: Bool = true
    @State private var searchText = ""
    @State private var showSettings = false
    @State private var tabBarSelected = 0
    @AppStorage("userTheme") var userTheme:Theme = .systemDefault
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .ignoresSafeArea()
                
                TabView(selection: $tabBarSelected){
                    
                    VStack{
                        SearchBar(text: $searchText)
                            .frame(maxWidth: .infinity)
                        Group {
                            if isMapView {
                                RestaurantMapView()
                            } else {
                                RestaurantListView(searchText: $searchText)
                            }
                        }
                    }
                    .tag(0)
                    .tabItem {
                        Image(systemName: "map")
                        Text("地圖")
                    }
                    
                    
                    SettingView()
                        .tag(1)
                        .tabItem {
                            Image(systemName: "gearshape")
                            Text("設定")
                        }
                }
            }
            .toolbarBackground(.automatic)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("逢甲美食地圖")
                        .font(.custom("HiraginoSans-W7", size: 24))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack{
                        Button {
                            isMapView.toggle()
                        } label: {
                            Image(systemName: isMapView ? "list.bullet.rectangle.portrait" : "map")
                                .frame(width: 20, height: 20)
                        }
                    }
                }
            }
            .preferredColorScheme(userTheme.colorScheme)
        }
        .tint(.accent)
    }
}

enum Theme: String, CaseIterable {
    case systemDefault = "Default"
    case light = "Light"
    case dark = "Dark"
    
    var colorScheme: ColorScheme? {
        switch self {
        case .systemDefault:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }
}

#Preview {
    ContentView()
}
