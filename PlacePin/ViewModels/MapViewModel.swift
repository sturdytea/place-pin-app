//
//
// MapViewModel.swift
// PlacePin
//
// Created by sturdytea on 06.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    
import MapKit
import Foundation
import CoreLocation


class MapViewModel: ObservableObject {
    
    @Published var searchResults: [MKMapItem] = []
    @Published var selectedItem: MKMapItem?
    
    func searchPlaces(userRequest: String, userCoordinate: CLLocationCoordinate2D) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = userRequest
        let regionRadius: CLLocationDistance = 10000 // 10km
        
        request.region = MKCoordinateRegion(
            center: userCoordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius
        )
        let search = MKLocalSearch(request: request)
        
        Task {
            do {
                let response = try await search.start()
                self.searchResults = response.mapItems
            } catch {
                print("Search error: \(error)")
            }
        }
    }
}
