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


struct MapView: View {
    
    // MARK: - State and Dependencies
    
    @EnvironmentObject var locationViewModel: UserLocationViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var mapViewModel: MapViewModel
    
    // MARK: - Properties
    
    @State private var cameraPosition = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var searchQuery = ""
    @State private var isPresented = false
    @State private var areGettingDirections = false
    @State private var isRouteDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination:MKMapItem?
    
    // MARK: - Body
    var body: some View {
        ZStack {
            mapContent
        }
        .environmentObject(locationViewModel)
        .environmentObject(router)
        .onChange(of: mapViewModel.selectedItem) { oldValue, newValue in
            isPresented = newValue != nil
            if newValue != nil {
                router.selectedItem = newValue
                router.sheetView = .placeDetails
                router.isSheetPresented = true
                mapViewModel.clearRoute()
            }
        }
        .sheet(isPresented: $router.isSheetPresented) {
            sheetContent
                .environmentObject(locationViewModel)
                .environmentObject(mapViewModel)
                .environmentObject(router)
                .presentationDragIndicator(.visible)
                .presentationDetents(sheetDetents)
                .presentationBackgroundInteraction(sheetBackgroundInteraction)
                .presentationCornerRadius(25)
                .interactiveDismissDisabled()
        }
    }
    
    // MARK: - Map Content
    private var mapContent: some View {
        Map(initialPosition: cameraPosition, selection: $mapViewModel.selectedItem) {
            ForEach(mapViewModel.searchResults, id: \.self) { result in
                let placemark = result.placemark
                Marker(placemark.name ?? "", coordinate: placemark.coordinate)
            }
            
            if let route = mapViewModel.route {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
        }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapPitchToggle()
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
                item: $router.selectedItem,
                isPresented: router.isSheetPresented,
                areGettingDirections: $areGettingDirections
            )
        }
    }
    
    // MARK: - Sheet Helpers
    
    /// Stopping point or height for a modal sheet presentation
    private var sheetDetents: Set<PresentationDetent> {
        switch router.sheetView {
        case .home:
            [.fraction(0.25), .medium, .large]
        case .placeDetails:
            [.fraction(0.25), .medium, .fraction(0.95)]
        }
    }
    
    private var sheetBackgroundInteraction: PresentationBackgroundInteraction {
        switch router.sheetView {
        case .home:
                .enabled(upThrough: .fraction(0.25))
        case .placeDetails:
                .enabled(upThrough: .fraction(0.25))
        }
    }
    
    // MARK: - Helpers
}

#Preview {
    MapView()
        .environmentObject(UserLocationViewModel())
        .environmentObject(MapViewModel())
        .environmentObject(Router())
}
