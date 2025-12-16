//
//
// LocationDetailsSheetView.swift
// PlacePin
//
// Created by sturdytea on 02.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI
import MapKit

struct LocationDetailsSheetView: View {
    
    // MARK: - States and Dependancies
    
    @EnvironmentObject var locationViewModel: UserLocationViewModel
    @EnvironmentObject var router: Router
    @EnvironmentObject var mapViewModel: MapViewModel
    
    // MARK: - Variables
    
    @Binding var item: MKMapItem?
    @State var isPresented: Bool
    @Binding var areGettingDirections: Bool
    @State private var lookAroundScene: MKLookAroundScene?
//    @State private var eta: String?
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item?.placemark.name ?? "Should be name")
                                .font(.title2)
                                .fontWeight(.semibold)
                            Text(item?.placemark.title ?? "Title")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                                .lineLimit(2)
                                .padding(.trailing)
                        }
                        Spacer()
                        Button {
                            isPresented.toggle()
                            item = nil
                            router.selectedItem = item
                            router.sheetView = .home
                            router.isSheetPresented = true
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(.gray, Color(.systemGray6))
                        }
                    } // HStack
                    if let scene = lookAroundScene {
                        LookAroundPreview(initialScene: scene)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding()
                    } else {
                        EmptyView()
                    }
                } // VStack
            }
            VStack {
                Spacer()
                HStack(alignment: .bottom) {
                    RoundImageButton(
                        imageName: "arrow.turn.up.right",
                        backgroundColor: .green,
                        action: {
                            areGettingDirections = true
                            router.isSheetPresented = false
                            
                            guard
                                let destination = item,
                                let userCoordinate = locationViewModel.coordinate
                            else {
                                print("Missing destination or user location")
                                return
                            }
                            mapViewModel.fetchRoute(to: destination, userCoordinate: userCoordinate)
                            isPresented = false
                        })
                    Spacer()
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
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
    LocationDetailsSheetView(item: .constant(nil), isPresented: true, areGettingDirections: .constant(false))
        .environmentObject(UserLocationViewModel())
        .environmentObject(MapViewModel())
        .environmentObject(Router())
}
