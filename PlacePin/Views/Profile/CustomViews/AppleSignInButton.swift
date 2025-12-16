//
//
// AppleSignInButton.swift
// PlacePin
//
// Created by sturdytea on 17.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI
import AuthenticationServices

struct AppleSignInButton: View {
    
    var onCompletion: (ASAuthorizationAppleIDCredential) -> Void
    
    var body: some View {
        SignInWithAppleButton(
            .signIn,
            onRequest: { request in
                request.requestedScopes = [.fullName, .email]
            },
            onCompletion: { result in
                if case .success(let auth) = result,
                   let credential = auth.credential as? ASAuthorizationAppleIDCredential {
                    onCompletion(credential)
                }
            }
        )
        .signInWithAppleButtonStyle(.black)
        .frame(height: 48)
        .cornerRadius(10)
    }
}

//#Preview {
//    AppleSignInButton()
//}
