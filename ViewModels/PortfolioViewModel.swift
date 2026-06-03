//
//  PortfolioViewModel.swift
//  Snam
//
//  Created by Jojo on 03/06/2026.
//

import SwiftUI
import Combine

// MARK: - ViewModel

class PortfolioViewModel: ObservableObject {
    @Published var totalBalance: Int = 500
    @Published var sectors: [PortfolioSector] = [
        PortfolioSector(name: "التقنية",  icon: "cpu"),
        PortfolioSector(name: "الترفيه", icon: "theatermasks.fill"),
        PortfolioSector(name: "الطاقة",  icon: "bolt.fill"),
        PortfolioSector(name: "السياحة", icon: "airplane"),
    ]
    @Published var selectedTabIDs: [UUID] = []
    @Published var expandedID: UUID? = nil
    @Published var showCongrats: Bool = false
    @Published var showDiversifyTip: Bool = false

    var remaining: Int {
        totalBalance - sectors.reduce(0) { $0 + $1.allocation }
    }

    var allocatedCount: Int {
        sectors.filter { $0.allocation > 0 }.count
    }

    func selectTab(_ id: UUID) {
        if selectedTabIDs.contains(id) {
            selectedTabIDs.removeAll { $0 == id }
            if expandedID == id { expandedID = nil }
        } else {
            selectedTabIDs.append(id)
        }
    }

    func toggleExpand(_ id: UUID) {
        if expandedID == id {
            expandedID = nil
        } else {
            expandedID = id
        }
    }

    func updateAllocation(id: UUID, value: Int) {
        guard let i = sectors.firstIndex(where: { $0.id == id }) else { return }
        let maxAllowable = remaining + sectors[i].allocation
        sectors[i].allocation = max(0, min(value, maxAllowable))
        withAnimation { showDiversifyTip = selectedTabIDs.count >= 2 }
    }

    func increment(id: UUID) {
        guard let i = sectors.firstIndex(where: { $0.id == id }) else { return }
        updateAllocation(id: id, value: sectors[i].allocation + 1)
    }

    func decrement(id: UUID) {
        guard let i = sectors.firstIndex(where: { $0.id == id }) else { return }
        updateAllocation(id: id, value: sectors[i].allocation - 25)
    }

    func resetWallet() {
        for i in sectors.indices { sectors[i].allocation = 0 }
        selectedTabIDs = []
        expandedID = nil
        showDiversifyTip = false
    }

    func confirm() {
        withAnimation { showCongrats = true }
    }

    func collectReward() {
        withAnimation {
            showCongrats = false
            resetWallet()
        }
    }
}
