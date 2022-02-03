//
//  Storage.swift
//  EtneteraTest
//
//  Created by Matěj Ščerba on 31.01.2022.
//

import Foundation

enum Storage: String, CaseIterable, Identifiable {
    case all, local, remote
    var id: Self { self }
    
    static var savingCases: [Storage] {
        [.local, .remote]
    }
}
