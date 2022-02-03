//
//  EtneteraTestApp.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 31.01.2022.
//

import SwiftUI
import Firebase

@main
struct EtneteraTestApp: App {
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                WorkoutsListView(user: User.shared)
            }
        }
    }
}
