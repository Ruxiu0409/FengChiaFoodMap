//
//  AuthenticationViewModel.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/10.
//

import Foundation
import Firebase
//import GoogleSignIn
import FirebaseAuth
import FacebookLogin

class AuthenticationViewModel: ObservableObject {
    
    // 定義 Firebase Sign-In 的登入和登出狀態
    enum SignInState {
        case signedIn
        case signedOut
    }
    
    // 定義 登入的方法
    enum LoginMethod: String {
        case email
        case facebook
        case google
    }
    
    // 管理身份驗證狀態
    @Published var state: SignInState = .signedOut
    // Email 帳號
    @Published var email: String?
    // 帳號照片
    @Published var userPhoto: String?
    // 保存登入的方法
    @Published var loginMethod: LoginMethod?
    
    
    
    
    func googleSignIn() {
            // 檢查是否有先前的 Sign-In
            if GIDSignIn.sharedInstance.hasPreviousSignIn() {
                GIDSignIn.sharedInstance.restorePreviousSignIn { [unowned self] user, error in
                    authenticateUser(for: user, with: error)
                }
            } else {
                // 從 Firebase 應用程式取得clientID。clientID它從先前新增到專案中的GoogleService-Info.plist中取得。
                guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
                // 使用以下命令建立 Google 登入設定對象clientID.
                let configuration = GIDConfiguration(clientID: clientID)
                
                // 由於沒有使用視圖控制器 presentingViewController,來透過註解的共用實例擷取存取權限 UIApplication.，因此現在不建議直接使用UIWindow，而您應該使用場景。
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                guard let rootViewController = windowScene.windows.first?.rootViewController else { return }
                
                // 然後，signIn()從類別的共用實例呼叫GIDSignIn以啟動登入程序。您傳遞配置物件和呈現控制器。
                GIDSignIn.sharedInstance.signIn(with: configuration, presenting: rootViewController) { [unowned self] user, error in
                    authenticateUser(for: user, with: error)
                }
            }
        }

        private func authenticateUser(for user: GIDGoogleUser?, with error: Error?) {
            // 處理錯誤並儘早從方法中返回它
            if let error = error {
                print(error.localizedDescription)
                return
            }
            // 從實例中取得 idToken和。accessTokenuser
            guard let authentication = user?.authentication, let idToken = authentication.idToken else { return }
          
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
          
            // 使用它們登入 Firebase。如果沒有錯誤，將狀態變更為 signedIn。
            Auth.auth().signIn(with: credential) { [unowned self] (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                
                } else {
                    state = .signedIn
                    loginMethod = .google
                    guard let email = authResult?.user.email else { return }
                    guard let userPhoto = authResult?.user.photoURL?.absoluteString else { return }
                    self.email = email
                    self.userPhoto = userPhoto
                    // 發布通知
                    NotificationCenter.default.post(name: AllNotification.toViewController, object: nil)
                }
            }
        }
        
        func googleSignOut() {
            GIDSignIn.sharedInstance.signOut()
            do {
                try Auth.auth().signOut()
                state = .signedOut
            } catch {
                print(error.localizedDescription)
            }
        }
    
    
    
}
