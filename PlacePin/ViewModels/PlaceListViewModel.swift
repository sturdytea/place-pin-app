//
//
// PlaceListViewModel.swift
// PlacePin
//
// Created by sturdytea on 02.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    
import Foundation


@MainActor
class PlaceListViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = PlaceService()
    
    func loadPlaces() async {
        isLoading = true
        errorMessage = nil
        do {
            let result = try await service.fetchPlaces()
            self.places = result
        } catch {
            self.errorMessage = "Failed to load places: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func addPlace(name: String, latitude: Double, longitude: Double) async {
        errorMessage = nil
        let coords = Coordinates(latitude: latitude, longitude: longitude)
        let newPlace = Place(id: nil, name: name, coordinates: coords)
        do {
            let created = try await service.createPlace(newPlace)
            places.append(created)
        } catch {
            errorMessage = "Failed to add place: \(error.localizedDescription)"
        }
    }
}
