//
//
// MKPointOfInterestCategory.swift
// PlacePin
//
// Created by sturdytea on 05.03.2026.
//
// GitHub: https://github.com/sturdytea
//
    

import MapKit
import Foundation

extension MKPointOfInterestCategory {
    var displayName: String {
        switch self {
        case .restaurant: return "Restaurant"
        case .cafe: return "Cafe"
        case .hotel: return "Hotel"
        case .park: return "Park"
        default: return rawValue.capitalized
        }
    }
}
