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
    @Published var route: MKRoute?
    @Published var routeDestination: MKMapItem?
    @Published var isRouteDisplaying: Bool = false
    
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
    
    func fetchRoute(to destination: MKMapItem, userCoordinate: CLLocationCoordinate2D) {
        let request = MKDirections.Request()

        let sourcePlacemark = MKPlacemark(coordinate: userCoordinate)
        request.source = MKMapItem(placemark: sourcePlacemark)
        request.destination = destination

        Task {
            do {
                let result = try await MKDirections(request: request).calculate()
                DispatchQueue.main.async {
                    self.route = result.routes.first
                    self.routeDestination = destination
                    self.isRouteDisplaying = true
                }
            } catch {
                print("Failed to fetch route: \(error)")
            }
        }
    }
    
    func clearRoute() {
        route = nil
        routeDestination = nil
        isRouteDisplaying = false
    }
    
    func deselectItem() {
        selectedItem = nil
        routeDestination = nil 
    }
}
