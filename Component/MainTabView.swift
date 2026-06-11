//
//  ContentView.swift
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
    @State private var selectedTab: TabItem = .portfolio

    var body: some View {
        NavigationStack {
            ZStack {
                
                // الخلفية كما هي
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .overlay(
                        Image("Frame")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    )

                TabView(selection: $selectedTab) {

                    MarketListViewV2()
                        .tabItem {
                            Image(systemName: TabItem.simulator.icon)
                            Text(TabItem.simulator.title)
                        }
                        .tag(TabItem.simulator)

                    LevelsView()
                        .tabItem {
                            Image(systemName: TabItem.journey.icon)
                            Text(TabItem.journey.title)
                        }
                        .tag(TabItem.journey)

                    MainView()
                        .environmentObject(WalletState())
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

