//
//
// UserLocationViewModel.swift
// PlacePin
//
// Created by sturdytea on 02.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import Combine
import CoreLocation

final class UserLocationViewModel: ObservableObject {
    private var locationService = LocationService()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var coordinate: CLLocationCoordinate2D?
    
    init() {
        bindLocationUpdates()
    }
    
    private func bindLocationUpdates() {
        locationService.$lastLocation
            .compactMap { $0 }
            .sink { [weak  self] coordinate in
                print("User location updated: lon: \(coordinate.longitude), lat: \(coordinate.latitude)")
                self?.coordinate = coordinate
            }
            .store(in: &subscriptions)
    }
}
