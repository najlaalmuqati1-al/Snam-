//
//  SnamApp.swift
//  Snam
//
//  Created by Najla Almuqati on 28/11/1447 AH.
//

import SwiftUI

@main
struct YourAppName: App { // هنا اسم تطبيقك
    @StateObject private var walletState = WalletState()

    var body: some Scene {
        WindowGroup {
            AppContainerView {
                MainTabView()
            }
            .environmentObject(walletState)
            .preferredColorScheme(walletState.appAppearance.colorScheme)
        }
    }
}

#Preview{
    MainTabView()
}
