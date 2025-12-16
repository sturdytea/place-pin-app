//
//
// SearchSheetView.swift
// PlacePin
//
// Created by sturdytea on 11.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import MapKit
import SwiftUI

struct SearchSheetView: View {
    
    // MARK: - States and Dependancies
    
    @EnvironmentObject var locationViewModel: UserLocationViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var mapViewModel: MapViewModel
    
    // MARK: - Properties
    
    @State private var searchQuery = ""
    
    // MARK: - Body 
    
    var body: some View {
        VStack {
            TextField("Search here...", text: $searchQuery)
                .textFieldStyle(.roundedBorder)
                .padding()
            List {
                ForEach(mapViewModel.searchResults, id: \.self) { result in
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(result.name ?? "Unknown")
                                    .font(.headline)
                                Text(result.placemark.title ?? "No address")
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                                    .lineLimit(2)
                            }
                            Spacer()
                            if let _ = locationViewModel.coordinate {
                                Text(calculateDistance(to: result))
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            }
                        }
                    }
                    .onTapGesture {
                        selectPlace(result)
                    }
                }
            }
        }
        .onSubmit(of: .text) {
            Task {
                await searchPlaces()
            }
        }
    }
    
    // MARK: - Helpers
    
    private func searchPlaces() async {
        guard let coordinate = locationViewModel.coordinate else { return }
        mapViewModel.searchPlaces(userRequest: searchQuery, userCoordinate: coordinate)
        print("searchPlaces finished successfully")
    }
    
    private func selectPlace(_ item: MKMapItem) {
        router.selectedItem = item
        router.sheetView = .placeDetails
        router.isSheetPresented = true
    }
    
    private func calculateDistance(to item: MKMapItem) -> String {
        guard let userLocation = locationViewModel.coordinate else { return "" }
        let user = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let place = CLLocation(latitude: item.placemark.coordinate.latitude, longitude: item.placemark.coordinate.longitude)
        let meters = user.distance(from: place)
        if meters > 1000 {
            return String(format: "%.1f km", meters/1000)
        } else {
            return String(format: "%.0f m", meters)
        }
    }
}

//#Preview {
//    SearchSheetView()
//}
