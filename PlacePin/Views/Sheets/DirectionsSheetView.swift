//
//
// DirectionsSheetView.swift
// PlacePin
//
// Created by sturdytea on 17.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import MapKit
import SwiftUI

struct DirectionsSheetView: View {
    
    @EnvironmentObject var mapViewModel: MapViewModel
    @EnvironmentObject var locationViewModel: UserLocationViewModel
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // TODO: Add information about user route from-to
            HStack {
                if let route = mapViewModel.route {
                    Text("Estimated time: \(formattedETA(route))")
                        .font(.headline)
                } else {
                    Text("Should be time here")
                        .font(.headline)
                }
                Spacer()
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(TransportType.allCases) { type in
                        Button {
                            mapViewModel.selectedTransport = type
                            
                            if let userCoordinate = locationViewModel.coordinate {
                                mapViewModel.fetchRoute(
                                    to: mapViewModel.routeDestination!,
                                    userCoordinate: userCoordinate
                                )
                            }
                        } label: {
                            HStack(alignment: .center) {
                                Image(systemName: type.icon)
                                Text(type.title)
                            }
                            .padding()
                            .background(mapViewModel.selectedTransport == type ? Color(.systemGray6) : .clear)
                            .foregroundStyle(mapViewModel.selectedTransport == type ? .blue : .gray)
                            .cornerRadius(12)
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private func formattedETA(_ route: MKRoute?) -> String {
        
        guard let trueRoute = route else { return "-" }
        
        let minutes = Int(trueRoute.expectedTravelTime / 60)
        let hours = minutes / 60
        let mins = minutes % 60
        return hours > 0 ? "\(hours)h \(mins)mins" : "\(mins)mins"
    }
}

#Preview {
    DirectionsSheetView()
        .environmentObject(UserLocationViewModel())
        .environmentObject(MapViewModel())
}
