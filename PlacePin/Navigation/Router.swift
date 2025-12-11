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
    case home, placeDetails
}

@MainActor
public class Router: ObservableObject {
    
    // MARK: - Variables
    
    @Published public var path: [RouterDestination] = []
    @Published var sheetView: SheetView = .home
    @Published var isSheetPresented: Bool = true
    @Published var selectedItem: MKMapItem?
}
