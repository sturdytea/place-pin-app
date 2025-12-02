//
//
// PlaceService.swift
// PlacePin
//
// Created by sturdytea on 02.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    
import Foundation


actor PlaceService {
    // TODO: Paste real URL for remote server
    private let baseURL = URL(string: "http://127.0.0.1:8080")!
    
    func fetchPlaces() async throws -> [Place] {
        let url = baseURL.appendingPathComponent("places")
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode([Place].self, from: data)
    }
    
    func createPlace(_ place: Place) async throws -> Place {
        let url = baseURL.appendingPathComponent("places")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        request.httpBody = try encoder.encode(place)
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, http.statusCode == 200 || http.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        return try JSONDecoder().decode(Place.self, from: data)
    }
}
