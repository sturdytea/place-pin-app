//
//
// Router.swift
// PlacePin
//
// Created by sturdytea on 11.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import MapKit
import SwiftUI

enum SheetView {
    case home, placeDetails, directions
}

@MainActor
public class Router: ObservableObject {
    
    // MARK: - Variables
    
    @Published public var path: [RouterDestination] = []
    @Published private(set) var sheetView: SheetView = .home
    @Published private(set) var isSheetPresented: Bool = true
    @Published private(set) var selectedItem: MKMapItem?
    
    func showPlaceDetails(for item: MKMapItem) {
        selectedItem = item
        sheetView = .placeDetails
    }
    
    func showDirections() {
        sheetView = .directions
    }
    
    func showHome() {
        selectedItem = nil
        sheetView = .home
    }    
}
