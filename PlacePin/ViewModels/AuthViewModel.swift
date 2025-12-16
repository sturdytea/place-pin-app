//
//
// AuthViewModel.swift
// PlacePin
//
// Created by sturdytea on 17.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import AuthenticationServices

private enum Keys {
    static let appleUserID = "apple_user_id"
}

final class AuthViewModel: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    @Published var isLoading: Bool = false
    @Published var userName: String?
    @Published var userEmail: String?

    func handleAppleCredential(_ credential: ASAuthorizationAppleIDCredential) {
        isLoading = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {

            let userID = credential.user
            KeychainService.save(userID, key: Keys.appleUserID)

            self.isLoggedIn = true

            if let fullName = credential.fullName {
                self.userName = [fullName.givenName, fullName.familyName]
                    .compactMap { $0 }
                    .joined(separator: " ")
                print(self.userName)
            }

            if let email = credential.email {
                self.userEmail = email
            }

            self.isLoading = false
        }
    }

    func logout() {
        KeychainService.delete(key: Keys.appleUserID)
        isLoggedIn = false
        userName = nil
        userEmail = nil
    }
    
    func restoreSession() {
        if let _ = KeychainService.load(key: Keys.appleUserID) {
            isLoggedIn = true
        }
    }
}
