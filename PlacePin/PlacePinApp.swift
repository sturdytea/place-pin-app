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
    @StateObject private var placeListViewModel = PlaceListViewModel()
    
    var body: some Scene {
        WindowGroup {
            PlaceListView()
                .environmentObject(placeListViewModel)
        }
    }
}
