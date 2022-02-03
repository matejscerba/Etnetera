//
//  BackgroundColor.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 01.02.2022.
//

import SwiftUI

struct BackgroundColor: View {
    var storage: Storage
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        switch (storage) {
        case .local:
            colorScheme == .dark
                ? Color(.sRGB, red: 0, green: 0, blue: 0.25, opacity: 1.0)
                : Color.blue
        case .remote:
            colorScheme == .dark
                ? Color(.sRGB, red: 0, green: 0.25, blue: 0, opacity: 1.0)
                : Color.green
        default:
            colorScheme == .dark
                ? Color.black
                : Color.white
        }
    }
}
