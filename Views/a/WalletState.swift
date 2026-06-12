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
    @Published var balance: Double = 0

    // Toast state to notify MainView after saving wallet appearance
    @Published var showWalletSavedToast: Bool = false

    // Request MainView to dismiss back to root (MainView) from nested screens
    @Published var requestDismissToMain: Bool = false

    var selectedTheme: CardTheme {
        CardTheme.allThemes.first(where: { $0.id == selectedThemeID }) ?? CardTheme.allThemes[0]
    }
}
#Preview {
    WalletCardView(
        theme: CardTheme.allThemes[0],
        holderName: "مزنة سنام"
    )
    .environmentObject(WalletState())
}
