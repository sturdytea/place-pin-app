//
//
// LocationDetailsSheetView.swift
// PlacePin
//
// Created by sturdytea on 02.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import MapKit
import SwiftUI

struct LocationDetailsSheetView: View {
    
    // MARK: - States and Dependancies
    
    @EnvironmentObject var locationViewModel: UserLocationViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var mapViewModel: MapViewModel
    
    // MARK: - Variables
    
    @Binding var item: MKMapItem?
    
    @State private var lookAroundScene: MKLookAroundScene?
    
    // MARK: - Body
    
    var body: some View {
        VStack {
//            ScrollView(.vertical) {
                VStack {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            Text(item?.placemark.name ?? "Should be name")
                                .font(.title2)
                                .fontWeight(.semibold)
                            if let category = item?.pointOfInterestCategory {
                                Text(category.displayName)
                                    .font(.subheadline)
                                    .padding(.bottom)
                            }
                            Text(item?.placemark.title ?? "Title")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .lineLimit(2)
                                .padding(.trailing)
                        }
                        Spacer()
                        RoundImageButton(
                            imageName: "xmark",
                            backgroundColor: .clear,
                            foregroundColor: .gray,
                            action: {
                                mapViewModel.deselectItem()
                                router.showHome()
                            })
                    } // HStack
                    HStack(alignment: .bottom) {
                        RoundImageButton(
                            imageName: "arrow.turn.up.right",
                            label: "Get Direction",
                            backgroundColor: .green,
                            action: {
                                guard
                                    let destination = item,
                                    let userCoordinate = locationViewModel.coordinate
                                else {
                                    print("Missing destination or user location")
                                    return
                                }
                                mapViewModel.fetchRoute(to: destination, userCoordinate: userCoordinate)
                                router.showDirections()
                            })
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    if let scene = lookAroundScene {
                        LookAroundPreview(initialScene: scene)
                            .frame(height: 200)
                            .cornerRadius(12)
                    } else {
                        EmptyView()
                    }
                    HStack {
                        VStack(alignment: .leading, spacing: 16) {
                            if let phone = item?.phoneNumber {
                                HStack {
                                    Image(systemName: "phone")
                                        .foregroundStyle(.green)
                                    Text(phone)
                                        .font(.subheadline)
                                }
                            }
                            if let url = item?.url {
                                HStack {
                                    Image(systemName: "globe")
                                        .foregroundStyle(.orange)
                                    Link(url.absoluteString, destination: url)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(.top, 12)
                } // VStack
                .padding()
            
        }
        .onAppear {
            fetchLookAroundPreview()
        }
        .onChange(of: item, { oldValue, newValue in
            fetchLookAroundPreview()
        })    
    }
    
    // MARK: - Helpers
    
    private func fetchLookAroundPreview() {
        if let item {
            lookAroundScene = nil
            Task {
                let request = MKLookAroundSceneRequest(mapItem: item)
                lookAroundScene = try await request.scene
            }
        }
    }
}

#Preview {
    LocationDetailsSheetView(item: .constant(nil))
        .environmentObject(UserLocationViewModel())
        .environmentObject(MapViewModel())
        .environmentObject(Router())
}
