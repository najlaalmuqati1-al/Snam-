//
//  ContentView.swift
//  Snam
//
//  Created by Najla Almuqati on 28/11/1447 AH.
//
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

    var body: some View {
        ZStack(alignment: .bottom) {
            // الصفحات
            Group {
                switch selectedTab {
                case .simulator:
                    MarketListViewV2()
                case .journey:
                    LevelsView()
                case .portfolio:
                    // PortfolioView()
                    Color(hex: "#0A0401").ignoresSafeArea() // مؤقت لين تجهز المحفظة
                }
            }

            // التاب بار
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Custom Tab Bar

struct CustomTabBar: View {
    @Binding var selectedTab: TabItem

    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabItemView(
                    tab: tab,
                    isActive: selectedTab == tab,
                    action: { selectedTab = tab }
                )
            }
        }
        .frame(width: 286, height: 54)
        .background(
            ZStack {
                // Blur background
                Capsule()
                    .fill(Color.white.opacity(0.05))
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())

                // Fill layer
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.06),
                                Color.black.opacity(0.6),
                                Color(hex: "#CCCCCC").opacity(0.5)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(0.67)

                // Glass effect
                Capsule()
                    .fill(Color.black.opacity(0.2))
                    .blendMode(.screen)
            }
        )
        .overlay(
            Capsule()
                .strokeBorder(Color.white.opacity(0.1), lineWidth: 0.5)
        )
        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 4)
        .padding(.bottom, 32)
        .frame(maxWidth: .infinity)
        .background(Color(hex: "#0A0401").opacity(0.85))
    }
}

// MARK: - Tab Item View

struct TabItemView: View {
    let tab: TabItem
    let isActive: Bool
    let action: () -> Void

    var color: Color {
        isActive ? Color(hex: "#4F80E9") : Color(hex: "#575656")
    }

    var body: some View {
        Button(action: action) {
            VStack(spacing: 1) {
                Image(systemName: tab.icon)
                    .font(.system(size: 17, weight: isActive ? .semibold : .regular))
                    .frame(width: 86, height: 28)
                    .blendMode(isActive ? .normal : .plusLighter)

                Text(tab.title)
                    .font(.system(size: 10, weight: isActive ? .bold : .medium))
                    .frame(width: 86, height: 12)
                    .blendMode(isActive ? .normal : .plusLighter)
            }
            .foregroundColor(color)
            .frame(width: 102, height: 54)
            .background(
                isActive
                ? Capsule()
                    .fill(Color(hex: "#121212"))
                    .blendMode(.plusLighter)
                : nil
            )
        }
    }
}


// MARK: - Preview

#Preview {
    MainTabView()
}
//#Preview {
//    ContentView()
//}
