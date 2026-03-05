//
// MapView.swift
// PlacePin
//
// Created by sturdytea on 02.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import MapKit
import SwiftUI
import BottomSheet

struct MapView: View {
    
    // MARK: - State and Dependencies
    
    @EnvironmentObject var locationViewModel: UserLocationViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var mapViewModel: MapViewModel
    
    // MARK: - Properties
    
    @State private var cameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var searchQuery = ""
    @State private var bottomSheetPosition: BottomSheetPosition = .relative(0.25)
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            mapContent
        }
        .environmentObject(locationViewModel)
        .environmentObject(router)
        .onChange(of: mapViewModel.selectedItem) { _, newValue in
            if let newValue {
                focusOnPlace(newValue)
                mapViewModel.clearRoute()
                router.showPlaceDetails(for: newValue)
            }
        }
        .bottomSheet(bottomSheetPosition: $bottomSheetPosition, switchablePositions: sheetDetents)
        {
            sheetContent
                .environmentObject(locationViewModel)
                .environmentObject(mapViewModel)
                .environmentObject(router)
                .presentationDragIndicator(.visible)
                .presentationBackgroundInteraction(sheetBackgroundInteraction)
                .presentationCornerRadius(25)
                .interactiveDismissDisabled()
        }
    }
    
    // MARK: - Map Content
    
    private var mapContent: some View {
        Map(position: $cameraPosition, selection: $mapViewModel.selectedItem) {
            ForEach(mapViewModel.searchResults, id: \.name) { result in
                let placemark = result.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
                    .tag(result)
            }
            if let route = mapViewModel.route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            Group {
                MapUserLocationButton()
                MapPitchToggle()
            }
        }
    }
    
    // MARK: - Sheet Content
    
    @ViewBuilder
    private var sheetContent: some View {
        switch router.sheetView {
        case .home:
            SearchSheetView()
        case .placeDetails:
            LocationDetailsSheetView(
                item: $mapViewModel.selectedItem
            )
        case .directions:
            DirectionsSheetView()
        }
    }
    
    // MARK: - Sheet Helpers
    
    /// Stopping point or height for a modal sheet presentation
    private var sheetDetents: [BottomSheetPosition] {
        switch router.sheetView {
        case .home:
            [.relative(0.25), .relative(0.45), .relative(0.95)]
        case .placeDetails:
            [.relative(0.25), .relative(0.45), .relative(0.95)]
        case .directions:
            [.relative(0.15)]
        }
    }
    
    private var sheetBackgroundInteraction: PresentationBackgroundInteraction {
        switch router.sheetView {
        case .home:
                .enabled(upThrough: .fraction(0.25))
        case .placeDetails:
                .enabled(upThrough: .fraction(0.25))
        case .directions:
                .enabled(upThrough: .fraction(0.15))
        }
    }
    
    // MARK: - Helpers
    
    private func focusOnPlace(_ item: MKMapItem) {
        let coordinate = item.placemark.coordinate
        withAnimation(.easeInOut) {
            cameraPosition = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    latitudinalMeters: 800,
                    longitudinalMeters: 800
                )
            )
        }
    }
}

#Preview {
    MapView()
        .environmentObject(UserLocationViewModel())
        .environmentObject(MapViewModel())
        .environmentObject(Router())
}
