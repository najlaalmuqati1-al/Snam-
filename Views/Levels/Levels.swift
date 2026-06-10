//
//  Levels.swift
//  Snam
//
//  Created by Jojo on 07/06/2026.
// اللوجك بسيط بس بنتظر تكتمل اللفلز اسوي مره وحده

import SwiftUI

// MARK: - Models
/*
enum LevelState {
    case completed
    case active
    case locked
}

struct Level {
    let id: Int
    let label: String
    let title: String
    let description: String
    let badge: String
}

// MARK: - Data

let levels: [Level] = [
    Level(id: 1, label: "المستوى الأول",  title: "المستثمر المبتدئ", description: "ابدأ رحلتك وتعلم أساسيات الاستثمار",        badge: "مبتدئ"),
    Level(id: 2, label: "المستوى الثاني", title: "متداول السوق",      description: "تعلم تحليل السوق واتخاذ قراراتك الأولى",    badge: "متمكن"),
    Level(id: 3, label: "المستوى الثالث", title: "صائد الفرص",        description: "استثمر بذكاء واغتنم الفرص",                 badge: "محترف"),
    Level(id: 4, label: "المستوى الرابع", title: "المستثمر الذكي",    description: "تعلم استراتيجيات متقدمة للمحترفين",         badge: "خبير"),
    Level(id: 5, label: "المستوى الخامس", title: "المحافظ",           description: "وزع أموالك وتعلم فن إدارة المحافظ",         badge: "محافظ"),
]

// MARK: - Constants

let cardHeight: CGFloat = 118
let cardGap: CGFloat = 12
let dotSize: CGFloat = 26

func dotY(for index: Int) -> CGFloat {
    CGFloat(index) * (cardHeight + cardGap) + cardHeight / 2
}

// MARK: - Main View

struct LevelsView: View {
    @State private var currentLevel: Int = 2

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .trailing, spacing: 0) {

                VStack(alignment: .trailing, spacing: 21) {
                    Text("المراحل")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("تقدم في رحلتك وتعلم لتنتهي من جميع المراحل")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(hex: "#9B978D"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 24)
                .padding(.horizontal, 24)
                .padding(.top, 90)
                .padding(.bottom, 20)

                LevelsListView(levels: levels, currentLevel: currentLevel)
                    .padding(.horizontal, 24)

                Spacer().frame(height: 40)
            }
        }
        .background(Color.clear)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Levels List

struct LevelsListView: View {
    let levels: [Level]
    let currentLevel: Int

    var totalHeight: CGFloat {
        CGFloat(levels.count) * cardHeight + CGFloat(levels.count - 1) * cardGap
    }

    var fillHeight: CGFloat {
        guard currentLevel > 1 else { return 0 }
        let completedIndex = currentLevel - 2
        let idx = min(completedIndex, levels.count - 1)
        return dotY(for: idx)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {

            VStack(spacing: cardGap) {
                ForEach(levels, id: \.id) { level in
                    NavigationLink(destination: destinationView(for: level.id)) {
                        LevelCardView(level: level, state: levelState(for: level.id))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.top, 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, dotSize + 12)

            ZStack(alignment: .top) {

                Rectangle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(hex: "#0E2357"), location: 0.19),
                                .init(color: Color(hex: "#999999"), location: 0.29),
                                .init(color: Color(hex: "#2C2A28"), location: 1.0),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 2, height: dotY(for: levels.count - 1) - dotY(for: 0) - dotSize / 2)
                    .offset(x: dotSize / 2 - 12, y: 0)

                Rectangle()
                    .fill(Color(hex: "#0E2357"))
                    .frame(width: 2, height: fillHeight)
                    .offset(x: dotSize / 2 - 12, y: 0)

                ForEach(Array(levels.enumerated()), id: \.element.id) { index, level in
                    ProgressDotView(state: levelState(for: level.id))
                        .offset(y: dotY(for: index) - dotSize / 2 - dotY(for: 0))
                }
            }
            .offset(y: 130)
            .frame(width: dotSize - 20, height: totalHeight, alignment: .top)
        }
    }

    @ViewBuilder
    func destinationView(for id: Int) -> some View {
        switch id {
        case 1: ContentView()        case 2: InvestmentLevelView()
        case 3: LevelThreeView()
        case 4: LevelFourView()
        case 5: PortfolioRootView()
        default: EmptyView()
        }
    }

    func levelState(for id: Int) -> LevelState {
        if id < currentLevel  { return .completed }
        if id == currentLevel { return .active }
        return .locked
    }
}

// MARK: - Placeholder Views

struct LevelThreeView: View {
    var body: some View {
        Color.clear.ignoresSafeArea()
    }
}

struct LevelFourView: View {
    var body: some View {
        Color.clear.ignoresSafeArea()
    }
}

// MARK: - Progress Dot

struct ProgressDotView: View {
    let state: LevelState

    var body: some View {
        ZStack {
            switch state {

            case .locked:
                Circle()
                    .fill(Color(hex: "#181717"))
                    .frame(width: 26, height: 26)
                    .overlay(Circle().stroke(Color(hex: "#292624"), lineWidth: 1))
                Image(systemName: "lock.fill")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color(hex: "#464649"))

            case .active:
                Circle()
                    .fill(Color(hex: "#181717"))
                    .frame(width: 26, height: 26)
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "#0E2357"), lineWidth: 2)
                    )

            case .completed:
                Circle()
                    .stroke(Color(hex: "#0E2357"), lineWidth: 1)
                    .frame(width: 26, height: 26)
                Circle()
                    .fill(Color(hex: "#0E2357"))
                    .frame(width: 21.27, height: 21.27)
                Image(systemName: "checkmark")
                    .font(.system(size: 10.76, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 26, height: 26)
    }
}

// MARK: - Level Card

struct LevelCardView: View {
    let level: Level
    let state: LevelState

    var body: some View {
        HStack(spacing: 8) {

            ShieldWithDiamond(badge: level.badge)

            Spacer()

            VStack(alignment: .leading, spacing: 6) {

                Text(level.label)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(hex: "#9B978D"))

                Text(level.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(state == .locked ? Color(hex: "#BFBFBF").opacity(0.53) : .white)

                Text(level.description)
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(Color(hex: "#9B978D"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(width: 316, height: 118)
        .background(cardBackground)
        .cornerRadius(12)
    }

    @ViewBuilder
    var cardBackground: some View {
        switch state {
        case .active, .completed:
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.78))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "#55585E"), Color(hex: "#202C46")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 0)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)

        case .locked:
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#1A1A1A"))
        }
    }
}

// MARK: - Shield + Diamond

struct ShieldWithDiamond: View {
    let badge: String

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 62))
                    .foregroundStyle(LinearGradient(
                        colors: [Color(hex: "#0D2357"), Color(hex: "#0D2357")],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .scaleEffect(1.04)

                Image(systemName: "shield.fill")
                    .font(.system(size: 62))
                    .foregroundColor(Color(hex: "#100F0C").opacity(0.78))

                DiamondView()
                    .offset(x: 0, y: -1)
            }
            .frame(width: 63, height: 74)

            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "#0D2357"))
                    .frame(width: 35, height: 10)

                Text(badge)
                    .font(.custom("BalooBhai2-Regular", size: 12))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 12)
            }
            .frame(width: 42, height: 12)
            .offset(y: -12)
        }
        .frame(width: 63)
    }
}

struct DiamondView: View {
    var body: some View {
        Image("Badgepdf")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 45.83, height: 45.83)
    }
}

// MARK: - Badge

struct BadgeView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.horizontal, 6)
            .padding(.vertical, 1)
        RoundedRectangle(cornerRadius: 2)
            .fill(Color.black)
            .cornerRadius(2)
    }
}

// MARK: - Color Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview

#Preview {
    AppContainerView {
        LevelsView()
    }
}
*/

import SwiftUI

// MARK: - Models

enum LevelState {
    case completed
    case active
    case locked
}

struct Level {
    let id: Int
    let label: String
    let title: String
    let description: String
    let badge: String
}

// MARK: - Data

let levels: [Level] = [
    Level(id: 1, label: "المستوى الأول",  title: "المستثمر المبتدئ", description: "ابدأ رحلتك وتعلم أساسيات الاستثمار",        badge: "مبتدئ"),
    Level(id: 2, label: "المستوى الثاني", title: "متداول السوق",      description: "تعلم تحليل السوق واتخاذ قراراتك الأولى",    badge: "متمكن"),
    Level(id: 3, label: "المستوى الثالث", title: "صائد الفرص",        description: "استثمر بذكاء واغتنم الفرص",                 badge: "محترف"),
    Level(id: 4, label: "المستوى الرابع", title: "المستثمر الذكي",    description: "تعلم استراتيجيات متقدمة للمحترفين",         badge: "خبير"),
    Level(id: 5, label: "المستوى الخامس", title: "المحافظ",           description: "وزع أموالك وتعلم فن إدارة المحافظ",         badge: "محافظ"),
]

// MARK: - Constants

let cardHeight: CGFloat = 118
let cardGap: CGFloat = 12
let dotSize: CGFloat = 26

func dotY(for index: Int) -> CGFloat {
    CGFloat(index) * (cardHeight + cardGap) + cardHeight / 2
}

// MARK: - Main View

struct LevelsView: View {
    @AppStorage("currentLevel") private var currentLevel: Int = 1

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .trailing, spacing: 0) {

                VStack(alignment: .trailing, spacing: 21) {
                    Text("المراحل")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text("تقدم في رحلتك وتعلم لتنتهي من جميع المراحل")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color(hex: "#9B978D"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 24)
                .padding(.horizontal, 24)
                .padding(.top, 90)
                .padding(.bottom, 20)

                LevelsListView(levels: levels, currentLevel: currentLevel)
                    .padding(.horizontal, 24)

                Spacer().frame(height: 40)
            }
        }
        .background(Color.clear)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Levels List

struct LevelsListView: View {
    let levels: [Level]
    let currentLevel: Int

    var totalHeight: CGFloat {
        CGFloat(levels.count) * cardHeight + CGFloat(levels.count - 1) * cardGap
    }

    var fillHeight: CGFloat {
        guard currentLevel > 1 else { return 0 }
        let completedIndex = currentLevel - 2
        let idx = min(completedIndex, levels.count - 1)
        return dotY(for: idx)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {

            VStack(spacing: cardGap) {
                ForEach(levels, id: \.id) { level in
                    let state = levelState(for: level.id)
                    if state == .locked {
                        LevelCardView(level: level, state: state)
                    } else {
                        NavigationLink(destination: destinationView(for: level.id)) {
                            LevelCardView(level: level, state: state)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.top, 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, dotSize + 12)

            ZStack(alignment: .top) {

                Rectangle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(hex: "#0E2357"), location: 0.0),
                                .init(color: Color(hex: "#999999"), location: 0.4),
                                .init(color: Color(hex: "#2C2A28"), location: 1.0),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 2, height: dotY(for: levels.count - 1) - dotY(for: 0) - dotSize / 2)
                    .offset(x: dotSize / 2 - 12, y: 0)

                ForEach(Array(levels.enumerated()), id: \.element.id) { index, level in
                    ProgressDotView(state: levelState(for: level.id))
                        .offset(y: dotY(for: index) - dotSize / 2 - dotY(for: 0))
                }
            }
            .offset(y: 130)
            .frame(width: dotSize - 20, height: totalHeight, alignment: .top)
        }
    }

    @ViewBuilder
    func destinationView(for id: Int) -> some View {
        switch id {
        case 1: ContentView()
        case 2: InvestmentLevelView()
        case 3: LevelThreeView()
        case 4: LevelFourView()
        case 5: PortfolioRootView()
        default: EmptyView()
        }
    }

    func levelState(for id: Int) -> LevelState {
        if id < currentLevel  { return .completed }
        if id == currentLevel { return .active }
        return .locked
    }
}

// MARK: - Placeholder Views

struct LevelThreeView: View {
    var body: some View {
        Color.clear.ignoresSafeArea()
    }
}

struct LevelFourView: View {
    var body: some View {
        Color.clear.ignoresSafeArea()
    }
}

// MARK: - Progress Dot

struct ProgressDotView: View {
    let state: LevelState

    var body: some View {
        ZStack {
            switch state {

            case .locked:
                Circle()
                    .fill(Color(hex: "#181717"))
                    .frame(width: 26, height: 26)
                    .overlay(Circle().stroke(Color(hex: "#292624"), lineWidth: 1))
                Image(systemName: "lock.fill")
                    .font(.system(size: 11, weight: .regular))
                    .foregroundColor(Color(hex: "#464649"))

            case .active:
                Circle()
                    .fill(Color(hex: "#181717"))
                    .frame(width: 26, height: 26)
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "#0E2357"), lineWidth: 2)
                    )

            case .completed:
                Circle()
                    .stroke(Color(hex: "#0E2357"), lineWidth: 1)
                    .frame(width: 26, height: 26)
                Circle()
                    .fill(Color(hex: "#0E2357"))
                    .frame(width: 21.27, height: 21.27)
                Image(systemName: "checkmark")
                    .font(.system(size: 10.76, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .frame(width: 26, height: 26)
    }
}

// MARK: - Level Card

struct LevelCardView: View {
    let level: Level
    let state: LevelState

    var body: some View {
        HStack(spacing: 8) {

            ShieldWithDiamond(badge: level.badge)

            Spacer()

            VStack(alignment: .leading, spacing: 6) {

                Text(level.label)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(Color(hex: "#9B978D"))

                Text(level.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(state == .locked ? Color(hex: "#BFBFBF").opacity(0.53) : .white)

                Text(level.description)
                    .font(.system(size: 11, weight: .light))
                    .foregroundColor(Color(hex: "#9B978D"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(width: 316, height: 118)
        .background(cardBackground)
        .cornerRadius(12)
        .opacity(state == .locked ? 0.5 : 1.0)
    }

    @ViewBuilder
    var cardBackground: some View {
        switch state {
        case .active, .completed:
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.78))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [Color(hex: "#55585E"), Color(hex: "#202C46")],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 0)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)

        case .locked:
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(hex: "#1A1A1A"))
        }
    }
}

// MARK: - Shield + Diamond

struct ShieldWithDiamond: View {
    let badge: String

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                Image(systemName: "shield.fill")
                    .font(.system(size: 62))
                    .foregroundStyle(LinearGradient(
                        colors: [Color(hex: "#0D2357"), Color(hex: "#0D2357")],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .scaleEffect(1.04)

                Image(systemName: "shield.fill")
                    .font(.system(size: 62))
                    .foregroundColor(Color(hex: "#100F0C").opacity(0.78))

                DiamondView()
                    .offset(x: 0, y: -1)
            }
            .frame(width: 63, height: 74)

            ZStack {
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "#0D2357"))
                    .frame(width: 35, height: 10)

                Text(badge)
                    .font(.custom("BalooBhai2-Regular", size: 12))
                    .foregroundColor(.white)
                    .frame(width: 42, height: 12)
            }
            .frame(width: 42, height: 12)
            .offset(y: -12)
        }
        .frame(width: 63)
    }
}

struct DiamondView: View {
    var body: some View {
        Image("Badgepdf")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 45.83, height: 45.83)
    }
}

// MARK: - Color Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview

#Preview {
    AppContainerView {
        LevelsView()
    }
}
