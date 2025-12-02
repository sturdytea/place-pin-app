//
//
// Place.swift
// PlacePin
//
// Created by sturdytea on 02.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    
import Foundation


struct Place: Identifiable, Codable, Hashable {
    var id: UUID?
    var name: String
    var coordinates: Coordinates
}

struct Coordinates: Codable, Hashable {
    var latitude: Double
    var longitude: Double
}
