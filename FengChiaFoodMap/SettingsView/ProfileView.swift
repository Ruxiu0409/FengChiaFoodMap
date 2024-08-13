//
//  ProfileView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var showManageView = false
    
    var body: some View {
        Form {
            Section(header: Text("使用者資訊")) {
                if let user = Auth.auth().currentUser {
                    Text("使用者名稱: \(viewModel.username ?? "未知")")
                    Text("電子郵件: \(user.email ?? "未知")")
                    Text("帳號類型: \(viewModel.isAdmin ? "管理員" : "使用者")")
                } else {
                    Text("未登入狀態")
                        .onAppear(perform: {
                            viewModel.checkAuthStatus()
                        })
                }
            }
            
            if viewModel.isAdmin{
                Section(header: Text("管理員操作介面")) {
                    Button{
                        showManageView = true
                    }label: {
                        Text("進入管理介面")
                    }
                }
            }
            
            
            
            Section {
                if viewModel.isSignedIn{
                    Button(action: viewModel.signOut) {
                        Text("登出")
                            .foregroundColor(.red)
                    }
                }
                else{
                    NavigationLink{
                        SignInView(viewModel: viewModel)
                    }label: {
                        Text("登入")
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
        .navigationTitle("個人資料")
        .fullScreenCover(isPresented: $showManageView, content: {
            RestaurantManagementView(showManageView: $showManageView)
        })
    }
}
