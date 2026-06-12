//
//  MainTabView.swift
//  Snam
//
//  Created by Najla Almuqati on 28/11/1447 AH.

import SwiftUI

// MARK: - Tab Items

enum TabItem: Int, CaseIterable {
    case simulator = 0
    case journey
    case portfolio

    var title: String {
        switch self {
        case .simulator: return "المحاكي"
        case .journey:   return "رحلتك"
        case .portfolio: return "المحفظة"
        }
    }

    var icon: String {
        switch self {
        case .simulator: return "chart.line.uptrend.xyaxis"
        case .journey:   return "flag.checkered"
        case .portfolio: return "creditcard"
        }
    }
}


// MARK: - Custom Tab Bar

struct MainTabView: View {
    @AppStorage("selectedTab") private var selectedTab: Int = 2
    @StateObject private var walletState = WalletState()  // ← هنا

    var body: some View {
        // ...
      //  MainView()
        //    .environmentObject(walletState)  // ← نفس النسخة
        NavigationStack {
            ZStack {
                
                // الخلفيه
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .overlay(
                        Image("Frame")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    )

                TabView(selection: Binding(
                    get: { TabItem(rawValue: selectedTab) ?? .portfolio },
                    set: { selectedTab = $0.rawValue }
                )) {

                    MarketListViewV2()
                        .environmentObject(walletState)  // ← أضيف هذا

                        .tabItem {
                            Image(systemName: TabItem.simulator.icon)
                            Text(TabItem.simulator.title)
                        }
                        .tag(TabItem.simulator)

                    LevelsView()
                        .environmentObject(walletState)  // ← أضيف هذا

                        .tabItem {
                            Image(systemName: TabItem.journey.icon)
                            Text(TabItem.journey.title)
                        }
                        .tag(TabItem.journey)

                    MainView()
                        .environmentObject(walletState)
                        .tabItem {
                            Image(systemName: TabItem.portfolio.icon)
                            Text(TabItem.portfolio.title)
                        }
                        .tag(TabItem.portfolio)
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarHidden(true)
        }
    }
}
// MARK: - Preview

#Preview {
    MainTabView()
}

// Preview إضافي لتهنئة المحفظة مع نفس الاعتماديات المستخدمة في Reward.swift
/* حل شات الزق
#Preview("PortfolioCongratsView Preview") {
    PortfolioCongratsView(vm: PortfolioViewModel(), onFinished: {})
        .environmentObject(WalletState())
}
*/
/**
 NavigationStack { //
     ZStack(alignment: .bottom) {
         
         // الخلفية
         Color(.systemBackground)
             .ignoresSafeArea()
             .overlay(
                 Image("Frame")
                     .resizable()
                     .scaledToFill()
                     .ignoresSafeArea()
             )
 
 
 */
