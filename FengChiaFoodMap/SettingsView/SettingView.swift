import SwiftUI
import FirebaseAuth

struct SettingView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        List {
            Section{
                NavigationLink(destination: ProfileView(viewModel: viewModel)) {
                    Label("個人資料", systemImage: "person.circle")
                }
            }header: {
                Text("使用者資料")
            }
            Section{
                NavigationLink(destination: UpdateContentView()) {
                    Label("更新內容", systemImage: "arrow.triangle.2.circlepath")
                }
            } header: {
                Text("應用程式資訊")
            }
            Section {
                NavigationLink(destination: SubmissionView()) {
                    Label("與我們聯繫", systemImage: "square.and.pencil")
                }
                NavigationLink(destination: DeveloperInfoView()) {
                    Label("開發人員介紹", systemImage: "person.3")
                }
            } header: {
                Text("開發團隊資訊")
            }

        }
        .listStyle(SidebarListStyle())
        .navigationTitle("設置")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("完成") {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}




struct DeveloperInfoView: View {
    var body: some View {
        Text("開發人員介紹功能尚未實現")
            .navigationTitle("開發人員介紹")
    }
}
