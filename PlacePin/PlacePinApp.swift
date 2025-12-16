//
//
// PlacePinApp.swift
// PlacePin
//
// Created by sturdytea on 02.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

@main
struct PlacePinApp: App {
    
    // MARK: - States and Dependancies
    
    let userLocationViewModel = UserLocationViewModel()
    let mapViewModel = MapViewModel()
    let router = Router()
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(userLocationViewModel)
                .environmentObject(mapViewModel)
                .environmentObject(router)
        }
    }
}
