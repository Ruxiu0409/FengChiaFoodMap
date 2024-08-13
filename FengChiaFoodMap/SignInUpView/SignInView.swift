import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct SignInView: View {
    @ObservedObject var viewModel: AuthViewModel
    @State private var identifier: String = ""
    @State private var password: String = ""
    @State private var isSecure: Bool = true
    @State private var alertItem: AlertItem?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("登入")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            VStack(spacing: 15) {
                CustomTextField(icon: "person", placeholder: "信箱或使用者名稱", text: $identifier)
                CustomSecureField(icon: "lock", placeholder: "密碼", text: $password, isSecure: $isSecure)
            }
            .padding(.horizontal)
            
            Button(action: signIn) {
                Text("登入")
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Spacer()
            
            HStack {
                Text("還沒有帳號?")
                NavigationLink(destination: SignUpView(viewModel: viewModel)) {
                    Text("註冊")
                        .fontWeight(.bold)
                        .foregroundColor(Color.blue)
                }
            }
            .background(Color.white)
            HStack{
                NavigationLink(destination: WebView(url: URL(string: "https://fengchiafoodmap.webnode.tw/privacy-policies/")!)) {
                    Text("隱私權政策")
                        .font(.system(size: 12))
                        .foregroundStyle(.gray)
                }
            }
        }
        .alert(item: $alertItem) { alertItem in
            Alert(title: Text(alertItem.title),
                  message: Text(alertItem.message),
                  dismissButton: .default(Text("確定")))
        }
    }
    
    private func signIn() {
        guard !identifier.isEmpty else {
            alertItem = AlertItem(title: "錯誤", message: "信箱或使用者名稱不能為空白")
            return
        }
        guard !password.isEmpty else {
            alertItem = AlertItem(title: "錯誤", message: "密碼不能為空白")
            return
        }
        
        viewModel.signIn(identifier: identifier, password: password) { success, errorMessage in
            if success {
                presentationMode.wrappedValue.dismiss()
            } else {
                alertItem = AlertItem(title: "登入失敗", message: errorMessage ?? "未知錯誤")
            }
        }
    }
}





//struct SignInWithAppleButton: View {
//    var body: some View {
//        SignInWithAppleButton(
//            onRequest: { request in
//                request.requestedScopes = [.fullName, .email]
//            },
//            onCompletion: handleAppleSignInResult
//        )
//        .signInWithAppleButtonStyle(.black)
//    }
//
//    private func handleAppleSignInResult(_ result: Result<ASAuthorization, Error>) {
//        switch result {
//        case .success(let authResults):
//            print("Apple Sign In success")
//            // 這裡可以處理成功的邏輯，例如與 Firebase 整合
//        case .failure(let error):
//            print("Apple Sign In failed:", error.localizedDescription)
//        }
//    }
//}



#Preview {
    SignInView(viewModel: AuthViewModel())
}
