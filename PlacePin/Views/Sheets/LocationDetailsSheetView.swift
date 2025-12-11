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
    @Binding var isPresented: Bool
    @Binding var areGettingDirections: Bool
    @State private var lookAroundScene: MKLookAroundScene?
    
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
//                            router.clear()
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
                    }
                    if let scene = lookAroundScene {
                        LookAroundPreview(initialScene: scene)
                            .frame(height: 200)
                            .cornerRadius(12)
                            .padding()
                    } else {
                        EmptyView()
                    }
                    
                    
                }
            }
            .padding(.horizontal)
            // TODO: Implement these buttons 
            //            VStack {
            //                Spacer()
            //                HStack(spacing: 24) {
            //                    Button {
            //                        if let item {
            //                            item.openInMaps()
            //                        }
            //                    } label: {
            //                        Text("Open Maps")
            //                            .font(.headline)
            //                            .padding()
            //                            .background(.blue)
            //                            .cornerRadius(14)
            //                            .foregroundStyle(.white)
            //                            .frame(width: 170, height: 48)
            //                    }
            //                    Spacer()
            //                    Button {
            //                        areGettingDirections = true
            //                        isPresented = false
            //                    } label: {
            //                        Text("Get Direction")
            //                            .padding()
            //                            .font(.headline)
            //                            .background(.green)
            //                            .cornerRadius(14)
            //                            .foregroundStyle(.white)
            //                            .frame(width: 170, height: 48)
            //                    }
            //                }
            //            }
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
    
    func fetchLookAroundPreview() {
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
    LocationDetailsSheetView(item: .constant(nil), isPresented: .constant(false), areGettingDirections: .constant(false))
        .environmentObject(UserLocationViewModel())
        .environmentObject(MapViewModel())
        .environmentObject(Router())
}
