//
//
// ProfileView.swift
// PlacePin
//
// Created by sturdytea on 17.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

struct ProfileView: View {
    
    // MARK: - State and Dependencies
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Group {
                if authViewModel.isLoading {
                    loadingView
                } else if authViewModel.isLoggedIn {
                    loggedInView
                } else {
                    loggedOutView
                }
            }
            .navigationTitle("Profile")
        }
    }
}

private extension ProfileView {
    
    // MARK: - Loading View
    
    var loadingView: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.3)

            Text("Signing in…")
                .font(.headline)
                .foregroundStyle(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Logged In View
    
    var loggedInView: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(.blue)
            
            Text(authViewModel.userName ?? "User")
                .font(.title)
                .fontWeight(.semibold)
            
            if let email = authViewModel.userEmail {
                Text(email)
                    .foregroundStyle(.gray)
            }
            
            Button(role: .destructive) {
                authViewModel.logout()
            } label: {
                Text("Log out")
            }
            .padding(.top, 24)
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: - Logged Out View
    
    var loggedOutView: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundStyle(.gray)
            
            Text("Sign in to save places")
                .font(.title3)
                .fontWeight(.semibold)
            
            AppleSignInButton { credential in
                authViewModel.handleAppleCredential(credential)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
