//
//  WalletState.swift
//  snam
//
//  Created by Faitmh ibrahim on 21/12/1447 AH.
//

import SwiftUI
import Combine

// MARK: - App-wide Appearance
enum AppAppearance: String, CaseIterable, Identifiable {
    case system
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .system: return "يتبع النظام"
        case .light:  return "فاتح"
        case .dark:   return "داكن"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light:  return .light
        case .dark:   return .dark
        }
    }
}

// MARK: - Shared Wallet State (Observable across all screens)
/// This object is injected at the root and shared between
/// MainView ↔ SettingsView ↔ WalletAppearanceView
final class WalletState: ObservableObject {
    @Published var holderName: String = "مزنة سنام"
    @Published var selectedThemeID: Int = 0
    @AppStorage("walletBalance") var balance: Double = 0
    @AppStorage("collectedLevelsData") private var collectedLevelsData: String = ""

    // App Appearance persistence
    @AppStorage("appAppearance") private var appAppearanceRaw: String = AppAppearance.system.rawValue

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

    // Expose typed appearance with bridging to AppStorage
    var appAppearance: AppAppearance {
        get { AppAppearance(rawValue: appAppearanceRaw) ?? .system }
        set {
            appAppearanceRaw = newValue.rawValue
            objectWillChange.send()
        }
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
