import SwiftUI

struct RestaurantManagementView: View {
    @StateObject private var viewModel = RestaurantManagementViewModel()
    @State private var showingAddForm = false
    @State private var selectedRestaurant: Restaurant?
    @State private var searchText = ""
    @State private var showingErrorAlert = false
    @State private var showSetting = false
    @Binding var showManageView: Bool
    @Environment(\.colorScheme) var scheme
    
    var body: some View {
        NavigationView {
            List {
                Button{
                    showManageView = false
                }label:{
                    Text("退出管理介面")
                }
                SearchBar(text: $searchText)
                
                ForEach(viewModel.filteredRestaurants(searchText: searchText)) { restaurant in
                    RestaurantRow(restaurant: restaurant)
                        .onTapGesture {
                            selectedRestaurant = restaurant
                        }
                }
                .onDelete(perform: deleteRestaurant)
            }
            .navigationTitle("餐廳管理")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        showSetting = true
                    }label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddForm = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showSetting) {
                NavigationStack {
                    SettingView(viewModel: viewModel.authViewModel)
                }
            }
            .sheet(isPresented: $showingAddForm) {
                RestaurantFormView(mode: .add, onSave: addRestaurant)
            }
            .sheet(item: $selectedRestaurant) { restaurant in
                RestaurantFormView(mode: .edit(restaurant), onSave: updateRestaurant)
            }
            .alert(isPresented: $showingErrorAlert) {
                Alert(
                    title: Text("錯誤"),
                    message: Text(viewModel.errorMessage ?? "未知錯誤"),
                    dismissButton: .default(Text("確定"))
                )
            }
        }
        .onAppear {
            if viewModel.restaurants.isEmpty {
                viewModel.fetchRestaurants()
            }
        }
        .onChange(of: viewModel.errorMessage) {
            showingErrorAlert = viewModel.errorMessage != nil
        }
    }
    
    private func addRestaurant(_ restaurant: Restaurant) {
        viewModel.addRestaurant(restaurant)
        showingAddForm = false
    }
    
    private func updateRestaurant(_ restaurant: Restaurant) {
        viewModel.updateRestaurant(restaurant)
        selectedRestaurant = nil
    }
    
    private func deleteRestaurant(at offsets: IndexSet) {
        viewModel.deleteRestaurant(at: offsets)
    }
}

struct RestaurantRow: View {
    let restaurant: Restaurant
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(restaurant.name)
                .font(.headline)
            Text(restaurant.address)
                .font(.subheadline)
            Text(restaurant.categories.map { $0.localizedName }.joined(separator: ", "))
                .font(.caption)
            if let rating = restaurant.rating {
                HStack {
                    ForEach(0..<Int(rating), id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    Text(String(format: "%.1f", rating))
                }
            }
        }
    }
}



struct AddWebsiteLinkView: View {
    @State private var category: String = ""
    @State private var url: String = ""
    @State private var title: String = ""
    @State private var publishDate: Date = Date()
    
    let onSave: (String, WebsiteInfo) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                TextField("類別", text: $category)
                TextField("網址", text: $url)
                TextField("標題", text: $title)
                DatePicker("發布日期", selection: $publishDate, displayedComponents: .date)
            }
            .navigationTitle("新增網站連結")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("儲存") {
                        if let url = URL(string: url) {
                            let link = WebsiteInfo(url: url, title: title, publishDate: publishDate)
                            onSave(category, link)
                        }
                    }
                }
            }
        }
    }
}
