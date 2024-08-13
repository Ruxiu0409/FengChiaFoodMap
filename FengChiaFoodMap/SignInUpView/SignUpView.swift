//
//  SignUpView.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var isSecurePassword: Bool = true
    @State private var alertItem: AlertItem?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("註冊")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            VStack(spacing: 15) {
                CustomTextField(icon: "person", placeholder: "使用者名稱", text: $username)
                CustomTextField(icon: "envelope", placeholder: "使用者信箱", text: $email)
                CustomSecureField(icon: "lock", placeholder: "密碼", text: $password, isSecure: $isSecurePassword)
                CustomSecureField(icon: "lock", placeholder: "確認密碼", text: $confirmPassword, isSecure: $isSecurePassword)
            }
            .padding(.horizontal)
            
            Button(action: signUp) {
                Text("註冊")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                NavigationLink(destination: WebView(url: URL(string: "https://fengchiafoodmap.webnode.tw/privacy-policies/")!)) {
                    Text("隱私權政策")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
            }
            .background(Color.white)
        }
        .alert(item: $alertItem) { alertItem in
            Alert(title: Text(alertItem.title),
                  message: Text(alertItem.message),
                  dismissButton: .default(Text("確定")))
        }
    }
    
    private func signUp() {
        guard !username.isEmpty else {
            alertItem = AlertItem(title: "錯誤", message: "使用者名稱不能為空白")
            return
        }
        guard !email.isEmpty else {
            alertItem = AlertItem(title: "錯誤", message: "信箱不能為空白")
            return
        }
        guard !password.isEmpty else {
            alertItem = AlertItem(title: "錯誤", message: "密碼不能為空白")
            return
        }
        guard password == confirmPassword else {
            alertItem = AlertItem(title: "錯誤", message: "密碼和確認密碼不一致")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                alertItem = AlertItem(title: "註冊失敗", message: error.localizedDescription)
            } else if let user = authResult?.user {
                let db = Firestore.firestore()
                db.collection("users").document(user.uid).setData([
                    "username": username,
                    "email": email
                ]) { error in
                    if let error = error {
                        alertItem = AlertItem(title: "註冊失敗", message: error.localizedDescription)
                    } else {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}


#Preview {
    SignUpView(viewModel: AuthViewModel())
}
