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
    
    @State private var fromText: String = ""
    @State private var toText: String = ""
    
    @Namespace private var namespace
    
    // MARK: - Body
    
    var body: some View {
        VStack {
            // TODO: Add information about user route from-to
            HStack {
                if let route = mapViewModel.route {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("\(formattedETA(route))")
                            .font(.title)
                        Text("\(formattedDistance(route.distance))")
                    }
                } else {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("10 minutes")
                            .font(.title)
                        Text("1 km")
                    }
                }
                Spacer()
            }
            .padding(.top)
            HStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    if #available(iOS 26.0, *) {
                        GlassEffectContainer(spacing: 20.0) {
                            HStack {
                                ForEach(TransportType.allCases) { type in
                                    Button {
                                        changeTransportType(type)
                                    } label: {
                                        Image(systemName: type.icon)
                                            .font(.system(size: 20))
                                            .frame(width: 44, height: 44)
                                            .foregroundStyle(
                                                mapViewModel.selectedTransport == type ? .blue : .gray
                                            )
                                    }
                                    .glassEffect()
                                    .glassEffectUnion(id: "transport", namespace: namespace)
                                }
                            }
                        }
                    } else {
                        HStack {
                            ForEach(TransportType.allCases) { type in
                                RoundImageButton(
                                    imageName: type.icon,
                                    backgroundColor: .white,
                                    foregroundColor: mapViewModel.selectedTransport == type ? .blue : .gray,
                                    action: {
                                        changeTransportType(type)
                                    })
                            }
                        }
                    }
                } // ScrollView
                RoundImageButton(
                    imageName: "arrow.turn.up.right",
                    label: "Start the route",
                    backgroundColor: .green,
                    action: {
                        // Nothing yet
                    })
            }
        }
        .padding()
    }
    
    private func formattedETA(_ route: MKRoute?) -> String {
        guard let trueRoute = route else { return "-" }
        let minutes = Int(trueRoute.expectedTravelTime / 60)
        let hours = minutes / 60
        let mins = minutes % 60
        return hours > 0 ? "\(hours) hours \(mins) minutes" : "\(mins) minutes"
    }
    
    private func formattedDistance(_ distance: CLLocationDistance) -> String {
        let measurement = Measurement(value: distance, unit: UnitLength.meters)
        let formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .short
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter = numberFormatter
        return formatter.string(from: measurement.converted(to: .kilometers))
    }
    
    private func changeTransportType(_ type: TransportType) {
        mapViewModel.selectedTransport = type
        if let userCoordinate = locationViewModel.coordinate {
            mapViewModel.fetchRoute(
                to: mapViewModel.routeDestination!,
                userCoordinate: userCoordinate
            )
        }
    }
}

#Preview {
    DirectionsSheetView()
        .environmentObject(UserLocationViewModel())
        .environmentObject(MapViewModel())
}
