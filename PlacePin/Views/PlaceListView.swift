//
//
// PlaceListView.swift
// PlacePin
//
// Created by sturdytea on 02.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

struct PlaceListView: View {
    
    @EnvironmentObject var viewModel: PlaceListViewModel
    @State private var showingAddPlace = false
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading places…")
                } else if let error = viewModel.errorMessage {
                    VStack(spacing: 8) {
                        Text(error)
                            .foregroundColor(.red)
                        Button("Retry") {
                            Task { await viewModel.loadPlaces() }
                        }
                    }
                } else if viewModel.places.isEmpty {
                    Text("No places yet.\nTap + to add one.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                } else {
                    List(viewModel.places) { place in
                        VStack(alignment: .leading) {
                            Text(place.name)
                                .font(.headline)
                            Text("Lat: \(place.coordinates.latitude), Lon: \(place.coordinates.longitude)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("PlacePin")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddPlace = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .task {
                await viewModel.loadPlaces()
            }
            .sheet(isPresented: $showingAddPlace) {
                AddPlaceView()
                    .environmentObject(viewModel)
            }
        }
    }
}

struct AddPlaceView: View {
    @EnvironmentObject var viewModel: PlaceListViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var latitudeText: String = ""
    @State private var longitudeText: String = ""
    @State private var isSaving = false
    @State private var localError: String?
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Info") {
                    TextField("Name", text: $name)
                }
                
                Section("Coordinates") {
                    TextField("Latitude", text: $latitudeText)
                        .keyboardType(.decimalPad)
                    TextField("Longitude", text: $longitudeText)
                        .keyboardType(.decimalPad)
                }
                
                if let error = localError {
                    Section {
                        Text(error)
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Add Place")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(isSaving ? "Saving…" : "Save") {
                        Task { await save() }
                    }
                    .disabled(isSaving)
                }
            }
        }
    }
    
    private func save() async {
        localError = nil
        guard let lat = Double(latitudeText),
              let lon = Double(longitudeText) else {
            localError = "Please enter valid numbers for latitude and longitude."
            return
        }
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty else {
            localError = "Name cannot be empty."
            return
        }
        isSaving = true
        await viewModel.addPlace(name: name, latitude: lat, longitude: lon)
        isSaving = false
        if viewModel.errorMessage == nil {
            dismiss()
        } else {
            localError = viewModel.errorMessage
        }
    }    
}
