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

enum ProfileSection : String, CaseIterable {
    case posts = "Posts"
    case about = "About"
}

struct ProfileView: View {
    
    // MARK: - State and Dependencies
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var currentIndex = 0
    @State var segmentationSelection : ProfileSection = .posts
    
    // MARK: - Variables
    
    private let photos = PhotoCreditService.shared.photos
    private let timer = Timer.publish(every: 7, on: .main, in: .common).autoconnect()
    
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
        VStack(alignment: .center, spacing: 24) {
            ZStack(alignment: .top) {
                Image("EmptyBackground")
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: 240)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                
                VStack {
                    HStack {
                        Image("EmptyAvatar")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.35, height: UIScreen.main.bounds.width * 0.35)
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                        Spacer()
                        HStack(spacing: 8) {
                            Image(systemName: "pencil.and.outline")
                            Text("Some label")
                        }
                        .padding()
                        .background(.white)
                        .foregroundStyle(.black)
                        .clipShape(Capsule())
                        .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                    }
                }
                .padding()
                .offset(x: 0, y: 160)
            }
            Group {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Name and surename")
                            .font(.title3)
                            .fontWeight(.medium)
                        Text("Kazakhstan")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Button {
                        
                    } label: {
                        if #available(iOS 26.0, *) {
                            Image(systemName: "pencil")
                                .padding()
                                .glassEffect()
                        } else {
                            Image(systemName: "pencil")
                                .padding()
                                .background(.white)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                        }
                    }
                }
                .padding()
                
                Picker("", selection: $segmentationSelection) {
                    ForEach(ProfileSection.allCases, id: \.self) { tab in
                        Text(tab.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                
                switch segmentationSelection {
                case .posts:
                    PostsSection()
                case .about:
                    AboutSection()
                }
                
                Spacer()
                
                Button(role: .destructive) {
                    authViewModel.logout()
                } label: {
                    if #available(iOS 26.0, *) {
                        Text("Log out")
                            .padding()
                            .glassEffect(.regular.tint(.white).interactive())
                    } else {
                        Text("Log out")
                    }
                }
                .padding(.top, 24)
                
                Spacer()
            }
            .offset(x: 0, y: 64)
        }
        .padding()
    }
    
    // MARK: - Logged Out View
    
    var loggedOutView: some View {
        VStack(alignment: .center, spacing: 24) {
            ZStack(alignment: .bottomLeading) {
                Image(photos[currentIndex].imageName)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                    .id(currentIndex)
                    .transition(.opacity)
                    .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.height * 0.6)
                    .shadow(color: .black.opacity(0.1), radius: 5, y: 2)
                
                LinearGradient(
                    colors: [.clear, .black.opacity(0.7)],
                    startPoint: .center,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 8) {
                    Group {
                        HStack(spacing: 4) {
                            Text("Photo by")
                            Link("\(photos[currentIndex].authorName)",
                                 destination: URL(string: "\(photos[currentIndex].authorProfileURL)")!)
                        }
                        HStack(spacing: 4) {
                            Text("on")
                            Link("Unsplash",
                                 destination: URL(string: "\(photos[currentIndex].photoURL)")!)
                        }
                    }
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    Spacer()
                    Text("Experience the\nwonders of the world")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    Text("And conquer with us")
                }
                .padding()
                .foregroundStyle(.white)
            }
            .frame(maxWidth: UIScreen.main.bounds.width * 0.95, maxHeight: UIScreen.main.bounds.height * 0.6)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .onReceive(timer) { _ in
                withAnimation(.easeInOut(duration: 3)) {
                    currentIndex = (currentIndex + 1) % photos.count
                }
            }
            
            if #available(iOS 26.0, *) {
                AppleSignInButton { credential in
                    authViewModel.handleAppleCredential(credential)
                }
                .clipShape(Capsule())
                .glassEffect()
            } else {
                AppleSignInButton { credential in
                    authViewModel.handleAppleCredential(credential)
                }
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    ProfileView()
        .environmentObject(AuthViewModel())
}
