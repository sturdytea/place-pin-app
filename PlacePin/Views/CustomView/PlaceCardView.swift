//
//
// PlaceCardView.swift
// PlacePin
//
// Created by sturdytea on 05.03.2026.
//
// GitHub: https://github.com/sturdytea
//
    

import MapKit
import SwiftUI

struct PlaceCardView: View {
    
    let item: MKMapItem
    let distance: String
    let onTap: () -> Void
    
    @State private var scene: MKLookAroundScene?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let scene {
                LookAroundPreview(initialScene: scene)
                    .frame(height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding([.horizontal, .top])
            }
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.name ?? "Unknown")
                        .font(.headline)
                    if let category = item.pointOfInterestCategory {
                        Text(category.displayName)
                            .font(.subheadline)
                    }
                    Text(item.placemark.title ?? "No address")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                        .lineLimit(2)
                }
                Spacer()
                Text(distance)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            .padding()
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.06), radius: 6, y: 2)
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
        .task {
            await loadLookAround()
        }
    }
    
    private func loadLookAround() async {
        let request = MKLookAroundSceneRequest(mapItem: item)
        do {
            scene = try await request.scene
        } catch { }
    }
}

