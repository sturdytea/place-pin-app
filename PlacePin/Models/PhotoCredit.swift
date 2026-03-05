//
//
// PhotoCredit.swift
// PlacePin
//
// Created by sturdytea on 06.03.2026.
//
// GitHub: https://github.com/sturdytea
//
    

import Foundation

struct PhotoCredit: Identifiable {
    let id = UUID()
    let imageName: String
    let authorName: String
    let authorProfileURL: URL
    let photoURL: URL
}
