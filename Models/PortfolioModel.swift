
//
//  PortfolioSector.swift
//  Snam
//
//  Created by Jojo on 03/06/2026.
//

import Foundation

// MARK: - Model

struct PortfolioSector: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let icon: String
    var allocation: Int = 0
}
