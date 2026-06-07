//
//  Levels.swift
//  Snam
//
//  Created by Jojo on 07/06/2026.


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
]

// MARK: - Constants
let cardHeight: CGFloat = 118
let cardGap: CGFloat = 12
let dotSize: CGFloat = 26

// مركز كل كارد = (index * (cardHeight + cardGap)) + cardHeight/2
func dotY(for index: Int) -> CGFloat {
    CGFloat(index) * (cardHeight + cardGap) + cardHeight / 2
}

// MARK: - Main View

struct LevelsView: View {
    @State private var currentLevel: Int = 2

    var body: some View {
        Color(hex: "#0A0401").ignoresSafeArea()
            .overlay(
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .trailing, spacing: 0) {

                        // Header
                        VStack(alignment: .trailing, spacing: 6) {
                            Text("المراحل")
                                .font(.system(size: 34, weight: .heavy))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Text("تقدم في رحلتك وتعلم لتنتهي من جميع المراحل")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color(hex: "#9B978D"))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.trailing, 0)
                        .padding(.horizontal, 24)
                        .padding(.top, 42)
                        .padding(.bottom, 20)

                        LevelsListView(levels: levels, currentLevel: currentLevel)
                            .padding(.horizontal, 24)

                        Spacer().frame(height: 40)
                    }
                }
            )
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

    // 🔥 التعديل هنا: الخط الأزرق يمتد فقط لمركز آخر دائرة مكتملة
    var fillHeight: CGFloat {
        guard currentLevel > 1 else { return 0 } // إذا كان في المستوى الأول، الخط الأزرق طوله صفر
        let completedIndex = currentLevel - 2 // س آخر مستوى مكتمل
        let idx = min(completedIndex, levels.count - 1)
        return dotY(for: idx)
    }

    var body: some View {
        ZStack(alignment: .topLeading) {

            // الكاردات على اليمين
            VStack(spacing: cardGap) {
                ForEach(levels, id: \.id) { level in
                    LevelCardView(level: level, state: levelState(for: level.id))
                }
            }
            .padding(.top, 60)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, dotSize + 12)

            // الخط والدوائر على اليسار
            ZStack(alignment: .top) {

                // خط رمادي كامل خلفي
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
                    .frame(width: 2, height: dotY(for: levels.count - 1) - dotY(for: 0) - dotSize / 2)                    .offset(x: dotSize / 2 - 12 , y: 0)
                Rectangle() //ما منه فايدة ترا
                    .fill(Color(hex: "#0E2357"))
                    .frame(width: 2, height: fillHeight)
                    .offset(x: dotSize / 2 - 12, y: 0)
                // الدوائر
                ForEach(Array(levels.enumerated()), id: \.element.id) { index, level in
                    ProgressDotView(state: levelState(for: level.id))
                        .offset(y: dotY(for: index) - dotSize / 2 - dotY(for: 0)) //الellepsis
                }
            }
            .offset(y: 130) // المسافة
            .frame(width: dotSize - 20, height: totalHeight, alignment: .top)        } // تاكدي من المسافات دوختني
        // اللاين المسافة
    }

    func levelState(for id: Int) -> LevelState {
        if id < currentLevel  { return .completed }
        if id == currentLevel { return .active }
        return .locked
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
                // 🔥 تحسين مظهر الدائرة النشطة لتصبح واضحة كحلقة زرقاء بخلفية داكنة
                Circle()
                    .fill(Color(hex: "#181717"))
                    .frame(width: 26, height: 26)
                    .overlay(
                        Circle()
                            .stroke(Color(hex: "#0E2357"), lineWidth: 2) // زيادة السماكة للبروز
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

            // Shield على اليسار
            ShieldWithDiamond(badge: level.badge);            Spacer()

            // Text على اليمين
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

             //   BadgeView(text: level.badge) غلط مكرر بس بالبادج
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20) // المسافات
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
                // ستروك أزرق
                Image(systemName: "shield.fill")
                    .font(.system(size: 62))
                    .foregroundStyle(LinearGradient(
                        colors: [Color(hex: "#0D2357"), Color(hex: "#0D2357")],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                    .scaleEffect(1.04)

                // الشيلد الداكن
                Image(systemName: "shield.fill")
                    .font(.system(size: 62))
                    .foregroundColor(Color(hex: "#100F0C").opacity(0.78))

                // الداياموند
                DiamondView()
                    .offset(x: 0, y: -8)
            }
            .frame(width: 63, height: 74)

            // البادج
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
            .offset(y: -4)
        }
        .frame(width: 63)
    }
}
    

// MARK: - Diamond

struct DiamondView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 3.88)
                .fill(LinearGradient(colors: [Color(hex: "#0E1D55"), Color(hex: "#202C46"), Color(hex: "#FCFBE7"), Color(hex: "#0C2646"), Color(hex: "#0B152B")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 17.37, height: 17.37)

            RoundedRectangle(cornerRadius: 2.58)
                .fill(Color.black.opacity(0.2))
                .frame(width: 14.74, height: 14.74)

            RoundedRectangle(cornerRadius: 1.94)
                .fill(LinearGradient(colors: [Color(hex: "#8C421D"), Color(hex: "#122F72"), Color(hex: "#FCFBE7"), Color(hex: "#0E1741"), Color(hex: "#101858")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 10.65, height: 10.65)
        }
        .frame(width: 30.29, height: 30.29)
        .rotationEffect(.degrees(-45))
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
            .background(Color(hex: "#0D2357"))
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
    LevelsView()
}
