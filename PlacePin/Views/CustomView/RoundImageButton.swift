//
//
// RoundImageButton.swift
// PlacePin
//
// Created by sturdytea on 11.12.2025.
//
// GitHub: https://github.com/sturdytea
//
    

import SwiftUI

struct RoundImageButton: View {
    
    var imageName: String
    @State var label: String?
    var backgroundColor: Color
    var foregroundColor: Color = .white
    var action: () -> ()
    
    var body: some View {
        Button {
            action()
        } label: {
                Image(systemName: imageName)
                    .resizable()
                    .frame(width: 18, height: 18, alignment: .center)
                    .padding(.vertical)
                    .padding(label != nil ? .leading: .horizontal)
            if label != nil {
                Text(label!)
                    .font(.callout)
                    .fontWeight(.bold)
                    .padding(.trailing)
            }
        }
        .foregroundStyle(foregroundColor)
        .background(backgroundColor)
        .clipShape(Capsule())
    }
}

#Preview {
    RoundImageButton(imageName: "arrow.turn.up.right", label: "Hi", backgroundColor: .green, action: {})
}
