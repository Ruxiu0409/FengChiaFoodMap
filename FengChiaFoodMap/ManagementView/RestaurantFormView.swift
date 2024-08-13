//
//  RestaurantFormView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct RestaurantFormView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: RestaurantFormViewModel
    let onSave: (Restaurant) -> Void
    @State var showAddWebsiteLinkSheet = false
    
    enum Mode {
        case add
        case edit(Restaurant)
    }
    
    init(mode: Mode, onSave: @escaping (Restaurant) -> Void) {
        self._viewModel = StateObject(wrappedValue: RestaurantFormViewModel(mode: mode))
        self.onSave = onSave
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("基本資訊")) {
                    TextField("餐廳名稱", text: $viewModel.name)
                    TextField("電話號碼", text: $viewModel.phoneNumber)
                    TextField("地址", text: $viewModel.address)
                }
                
                Section(header: Text("位置")) {
                    TextField("緯度", value: $viewModel.latitude, format: .number)
                    TextField("經度", value: $viewModel.longitude, format: .number)
                }
                
                Section(header: Text("類別")) {
                    ForEach(RestaurantCategory.allCases, id: \.self) { category in
                        Toggle(category.localizedName, isOn: Binding(
                            get: { viewModel.categories.contains(category) },
                            set: { isOn in
                                if isOn {
                                    viewModel.categories.append(category)
                                } else {
                                    viewModel.categories.removeAll { $0 == category }
                                }
                            }
                        ))
                    }
                }
                
                Section(header: Text("營業時間")) {
                    ForEach($viewModel.openingHours) { $hours in
                        VStack {
                            Picker("星期", selection: $hours.day) {
                                ForEach(["星期一", "星期二", "星期三", "星期四", "星期五", "星期六", "星期日"], id: \.self) { day in
                                    Text(day).tag(day)
                                }
                            }
                            DatePicker("開始時間", selection: $hours.openTime, displayedComponents: .hourAndMinute)
                            DatePicker("結束時間", selection: $hours.closeTime, displayedComponents: .hourAndMinute)
                        }
                    }
                    .onDelete(perform: viewModel.removeOpeningHours)
                    .onMove(perform: viewModel.moveOpeningHours)
                    
                    Button("新增營業時間") {
                        viewModel.addOpeningHours()
                    }
                }
                
                Section(header: Text("菜單")) {
                    ForEach($viewModel.menu) { $item in
                        VStack {
                            TextField("品項名稱", text: $item.name)
                            TextField("價格", value: $item.price, format: .currency(code: "TWD"))
                            TextField("描述", text: Binding(
                                get: { item.description ?? "" },
                                set: { item.description = $0.isEmpty ? nil : $0 }
                            ))
                            Toggle("是否供應", isOn: $item.isAvailable)
                        }
                    }
                    .onDelete(perform: viewModel.removeMenuItem)
                    
                    Button("新增菜單項目") {
                        viewModel.addMenuItem()
                    }
                }
                
                Section(header: Text("網站連結")) {
                    ForEach(Array(viewModel.websiteLinks.keys), id: \.self) { category in
                        DisclosureGroup(category) {
                            ForEach(viewModel.websiteLinks[category] ?? [], id: \.id) { link in
                                VStack(alignment: .leading) {
                                    Text(link.title)
                                    Text(link.url.absoluteString)
                                        .font(.caption)
                                    Text(link.publishDate, style: .date)
                                        .font(.caption)
                                }
                            }
                            .onDelete { indexSet in
                                for index in indexSet {
                                    viewModel.removeWebsiteLink(for: category, at: index)
                                }
                            }
                        }
                    }
                    
                    Button("新增網站連結") {
                        showAddWebsiteLinkSheet = true
                    }
                }
                
                
                Section(header: Text("其他資訊")) {
                    TextField("Google Maps 連結", text: Binding(
                        get: { viewModel.googleMapsLink?.absoluteString ?? "" },
                        set: { viewModel.googleMapsLink = URL(string: $0) }
                    ))
                    TextField("Apple Maps 連結", text: Binding(
                        get: { viewModel.appleMapsLink?.absoluteString ?? "" },
                        set: { viewModel.appleMapsLink = URL(string: $0) }
                    ))
                    TextField("價格範圍", text: Binding(
                        get: { viewModel.priceRange ?? "" },
                        set: { viewModel.priceRange = $0.isEmpty ? nil : $0 }
                    ))
                }
            }
            .navigationTitle(viewModel.isNewRestaurant ? "新增餐廳" : "編輯餐廳")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("儲存") {
                        let restaurant = viewModel.createRestaurant()
                        onSave(restaurant)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .sheet(isPresented: $showAddWebsiteLinkSheet) {
                AddWebsiteLinkView(onSave: { category, link in
                    viewModel.addWebsiteLink(for: category, link: link)
                    showAddWebsiteLinkSheet = false
                })
            }
        }
    }
}

