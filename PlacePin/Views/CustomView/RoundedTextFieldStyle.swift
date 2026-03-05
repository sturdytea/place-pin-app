//
//
// RoundedTextFieldStyle.swift
// PlacePin
//
// Created by sturdytea on 05.03.2026.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

struct RoundedTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.vertical)
            .padding(.horizontal, 24)
            .background(
                Color(UIColor.white)
            )
            .clipShape(Capsule(style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 5, y: 2)
    }
}
