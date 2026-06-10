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

// MARK: - Main Tab View

struct MainTabView: View {
    @State private var selectedTab: TabItem = .journey
    @StateObject private var walletState = WalletState()

    var body: some View {
        NavigationStack {

            TabView(selection: $selectedTab) {

                ZStack {
                    BackgroundFrameView()
                    MarketListViewV2()
                }
                .tabItem {
                    Image(systemName: TabItem.simulator.icon)
                    Text(TabItem.simulator.title)
                }
                .tag(TabItem.simulator)

                ZStack {
                    BackgroundFrameView()
                    LevelsView()
                }
                .tabItem {
                    Image(systemName: TabItem.journey.icon)
                    Text(TabItem.journey.title)
                }
                .tag(TabItem.journey)

                ZStack {
                    BackgroundFrameView()
                    MainView()
                        .environmentObject(walletState)
                }
                .tabItem {
                    Image(systemName: TabItem.portfolio.icon)
                    Text(TabItem.portfolio.title)
                }
                .tag(TabItem.portfolio)
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - Background

struct BackgroundFrameView: View {
    var body: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
            .overlay(
                Image("Frame")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            )
    }
}

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

