//
//
// TransportType.swift
// PlacePin
//
// Created by sturdytea on 17.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import MapKit

enum TransportType: String, CaseIterable, Identifiable {
    case driving, walking
    
    var id: String { rawValue }
    
    var mapKitType: MKDirectionsTransportType {
        switch self {
        case .driving: .automobile
        case .walking: .walking
        }
    }
    
    var title: String {
        switch self {
        case .driving: "Driving"
        case .walking: "Walking"
        }
    }
    
    var icon: String {
        switch self {
        case .driving: "car.fill"
        case .walking: "figure.walk"
        }

    }
}
