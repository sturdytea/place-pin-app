//
//
// RootTabView.swift
// PlacePin
//
// Created by sturdytea on 17.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

struct RootTabView: View {
    
    // MARK: - State and Dependencies
    
    @EnvironmentObject var locationViewModel: UserLocationViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var mapViewModel: MapViewModel
    @EnvironmentObject var authViewModel: AuthViewModel
    
    // MARK: - Body
    
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
        }
    }
}

#Preview {
    RootTabView()
        .environmentObject(UserLocationViewModel())
        .environmentObject(MapViewModel())
        .environmentObject(Router())
        .environmentObject(AuthViewModel())
}
