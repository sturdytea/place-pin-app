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
    
    @FocusState private var isSearchFocused: Bool
    
    // MARK: - Body 
    
    var body: some View {
        VStack(spacing: 0) {
            TextField("Search here...", text: $searchQuery)
                .textFieldStyle(RoundedTextFieldStyle())
                .padding()
                .focused($isSearchFocused)
                .onSubmit {
                    Task { await searchPlaces() }
                }
                .onChange(of: isSearchFocused) { _, isFocused in
                    if isFocused {
                        mapViewModel.expandSearchSheet()
                    }
                }
            ScrollView {
                LazyVStack(spacing: 8) {
                    ForEach(mapViewModel.searchResults, id: \.self) { result in
                        PlaceCardView(
                            item: result,
                            distance: calculateDistance(to: result)
                        ) {
                            selectPlace(result)
                        }
                    }
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal)
            }
        }
        .onSubmit(of: .text) {
            Task {
                await searchPlaces()
            }
        }
    }
    
    // MARK: - Result card
    
    private func resultCard(_ result: MKMapItem) -> some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text(result.name ?? "Unknown")
                    .font(.headline) 
                Text(result.placemark.title ?? "No address")
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .lineLimit(2)
            }
            Spacer()
            if locationViewModel.coordinate != nil {
                Text(calculateDistance(to: result))
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            selectPlace(result)
        }
    }
    
    // MARK: - Helpers
    
    private func searchPlaces() async {
        guard let coordinate = locationViewModel.coordinate else { return }
        mapViewModel.searchPlaces(userRequest: searchQuery, userCoordinate: coordinate)
        print("searchPlaces finished successfully")
    }
    
    private func selectPlace(_ item: MKMapItem) {
        mapViewModel.selectedItem = item
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
