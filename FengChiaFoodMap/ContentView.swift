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
                Group {
                    if isMapView {
                        RestaurantMapView()
                    } else {
                        RestaurantListView(searchText: $searchText)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                NavigationStack {
                    SettingView()
                }
            }
            .toolbarBackground(.white)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(alignment: .center,spacing: 10) {
                        HStack {
                            Button {
                                showSettings = true
                            } label: {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(.primary)
                                    .frame(width: 20, height: 20)
                            }
                            Spacer()

                            Text("逢甲美食地圖")
                                .font(.headline)
                                .foregroundColor(.primary)

                            Spacer()

                            Button {
                                isMapView.toggle()
                            } label: {
                                Image(systemName: isMapView ? "list.bullet.rectangle.portrait" : "map")
                                    .foregroundColor(.primary)
                                    .frame(width: 20, height: 20)
                            }
                        }
                        .padding(.top,40)

                        SearchBar(text: $searchText)
                            .padding()
                        //    .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
