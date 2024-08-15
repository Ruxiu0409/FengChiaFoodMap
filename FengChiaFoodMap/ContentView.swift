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

    var body: some View {
        NavigationStack {
            ZStack {
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        hideKeyboard()
                    }
                    .ignoresSafeArea()
                
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
            }
            .sheet(isPresented: $showSettings) {
                NavigationStack {
                    SettingView()
                }
            }
            .toolbarBackground(.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primary)
                            .frame(width: 20, height: 20)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isMapView.toggle()
                    } label: {
                        Image(systemName: isMapView ? "list.bullet.rectangle.portrait" : "map")
                            .foregroundColor(.primary)
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
