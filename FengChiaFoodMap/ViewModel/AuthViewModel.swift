//
//  AuthViewModel.swift
//  FengChiaFoodMap
//
//  Created by 蔡承曄 on 2024/8/13.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


class AuthViewModel: ObservableObject {
    @Published var isSignedIn = false
    @Published var isAdmin = false
    @Published var username: String?

    private let db = Firestore.firestore()
    
    init() {
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            isSignedIn = true
            isAdmin = user.email == "admin@gmail.com"
            fetchUsername(for: user.uid)
        } else {
            isSignedIn = false
            isAdmin = false
            username = nil
        }
    }
    
    func fetchUsername(for uid: String) {
        db.collection("users").document(uid).getDocument { document, error in
            if let document = document, document.exists {
                self.username = document.data()?["username"] as? String
            } else {
                print("Username not found: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
    
    func signIn(identifier: String, password: String, completion: @escaping (Bool, String?) -> Void) {
        if identifier.contains("@") {
            // 如果識別符是信箱地址
            Auth.auth().signIn(withEmail: identifier, password: password) { [weak self] authResult, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else if let user = authResult?.user {
                    self?.isSignedIn = true
                    // 檢查信箱是否為管理員
                    self?.isAdmin = user.email == "admin@gmail.com"
                    completion(true, nil)
                }
            }
        } else {
            let db = Firestore.firestore()
            let usersRef = db.collection("users")
            
            usersRef.whereField("username", isEqualTo: identifier).getDocuments { [weak self] snapshot, error in
                if let error = error {
                    completion(false, error.localizedDescription)
                } else if let document = snapshot?.documents.first, let email = document.data()["email"] as? String {
                    // 登入並檢查是否為管理員
                    self?.signIn(identifier: email, password: password) { success, errorMessage in
                        if success {
                            self?.isAdmin = identifier == "admin"
                            completion(true, nil)
                        } else {
                            completion(false, errorMessage)
                        }
                    }
                } else {
                    completion(false, "找不到該使用者名稱")
                }
            }
        }
    }

    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isSignedIn = false
            isAdmin = false
            username = nil
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}


