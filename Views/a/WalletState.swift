//
//  WalletState.swift
//  snam
//
//  Created by Faitmh ibrahim on 21/12/1447 AH.
//

import SwiftUI
import Combine

// MARK: - Shared Wallet State (Observable across all screens)
/// This object is injected at the root and shared between
/// MainView ↔ SettingsView ↔ WalletAppearanceView
final class WalletState: ObservableObject {
    @Published var holderName: String = "مزنة سنام"
    @Published var selectedThemeID: Int = 0
    @AppStorage("walletBalance") var balance: Double = 0
    @AppStorage("collectedLevelsData") private var collectedLevelsData: String = ""


    // Toast state to notify MainView after saving wallet appearance
    @Published var showWalletSavedToast: Bool = false

    // Request MainView to dismiss back to root (MainView) from nested screens
    @Published var requestDismissToMain: Bool = false

    var selectedTheme: CardTheme {
        CardTheme.allThemes.first(where: { $0.id == selectedThemeID }) ?? CardTheme.allThemes[0]
    }
    var collectedLevels: Set<Int> {
        Set(collectedLevelsData.split(separator: ",").compactMap { Int($0) })
    }

    func collectReward(forLevel level: Int) {
        var collected = collectedLevels
        guard !collected.contains(level) else { return }
        collected.insert(level)
        collectedLevelsData = collected.map { String($0) }.joined(separator: ",")
        balance += 100
    }
}
#Preview {
    WalletCardView(
        theme: CardTheme.allThemes[0],
        holderName: "مزنة سنام"
    )
    .environmentObject(WalletState())
}
