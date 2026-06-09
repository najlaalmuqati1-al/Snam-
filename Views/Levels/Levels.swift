//
//  Levels.swift
//  Snam
//
//  Created by Jojo on 07/06/2026.
// اللوجك بسيط بس بنتظر تكتمل اللفلز اسوي مره وحده

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
// MARK: - Main View

struct LevelsView: View {
    @State private var currentLevel: Int = 2

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .trailing, spacing: 0) {

                // Header
                VStack(alignment: .trailing, spacing: 21) {
                    Text("المراحل")
                        .font(.system(size: 34, weight: .heavy))
                        .foregroundColor(.primary) // يقلب تلقائي لايت ودارك

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
            ShieldWithDiamond(badge: level.badge);
            
            Spacer()

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
                    .offset(x: 0, y: -1)
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
            .offset(y: -12)
        }
        .frame(width: 63)
    }
}
// حطيتها كصورة جاهزة
// جيد بس الجوودة منخفضة pdf جودتها افضل
struct DiamondView: View {
    var body: some View {
        // الصورة الأساسية للبادج القادمة من الـ Assets
        Image("Badgepdf")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 45.83, height: 45.83) // نفس الحجم الدقيق للتصميم المعتمد
   
        // .rotationEffect(.degrees(45))
    }
}
/**
 


 struct DiamondView: View {
     var body: some View {
         ZStack {

             // MARK: - Rectangle 3 (17.37 x 17.37) - 5 fills
             ZStack {
                 // 1. Linear أزرق داكن
                 LinearGradient(
                     stops: [
                         .init(color: Color(hex: "#0E1D55"), location: 0.1398),
                         .init(color: Color(hex: "#202C46"), location: 0.3766),
                         .init(color: Color(hex: "#FCFBE7"), location: 0.5296),
                         .init(color: Color(hex: "#0C2646"), location: 0.7002),
                         .init(color: Color(hex: "#0B152B"), location: 0.8677),
                     ],
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing
                 )

                 // 2. Linear ذهبي/بنفسجي
                 LinearGradient(
                     stops: [
                         .init(color: Color(hex: "#9E8976"), location: 0.1543),
                         .init(color: Color(hex: "#1C2D57"), location: 0.3062),
                         .init(color: Color(hex: "#ABB2F6"), location: 0.4737),
                         .init(color: Color(hex: "#4E5A9D"), location: 0.6296),
                         .init(color: Color(hex: "#7670C9"), location: 0.8205),
                         .init(color: Color(hex: "#172B85"), location: 0.9335),
                     ],
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing
                 )

                 // 3. Linear فضي/أبيض
                 LinearGradient(
                     stops: [
                         .init(color: Color(hex: "#7A96AC"), location: 0.0228),
                         .init(color: Color(hex: "#EAEFF3"), location: 0.198),
                         .init(color: Color(hex: "#C2D4E1"), location: 0.3294),
                         .init(color: Color(hex: "#FFFFFF"), location: 0.5016),
                         .init(color: Color(hex: "#D4DEE5"), location: 0.6215),
                         .init(color: Color(hex: "#ABBDC8"), location: 0.7869),
                         .init(color: Color(hex: "#BCCAD7"), location: 0.9524),
                     ],
                     startPoint: .top,
                     endPoint: .bottom
                 )

                 // 4. Diamond - وردي شفاف
                 RadialGradient(
                     stops: [
                         .init(color: Color(hex: "#FF9FEA"), location: 0.0),
                         .init(color: Color.white.opacity(0), location: 1.0),
                     ],
                     center: .init(x: 0.3094, y: 0.2313),
                     startRadius: 0,
                     endRadius: 12
                 )

                 // 5. Diamond - بنفسجي
                 RadialGradient(
                     stops: [
                         .init(color: Color(hex: "#A349EF"), location: 0.4219),
                         .init(color: Color(hex: "#FF65E6"), location: 1.0),
                     ],
                     center: .init(x: -0.1625, y: 0.7333),
                     startRadius: 0,
                     endRadius: 20
                 )
             }
             .frame(width: 17.37, height: 17.37)
             .clipShape(RoundedRectangle(cornerRadius: 3.88))
             .overlay(
                 RoundedRectangle(cornerRadius: 3.88)
                     .strokeBorder(
                         LinearGradient(
                             colors: [Color.white.opacity(0.3), Color.white.opacity(0.05)],
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing
                         ),
                         lineWidth: 0.65
                     )
             )
             .rotationEffect(.degrees(-45))
             .shadow(color: Color(hex: "#CDB8AD").opacity(0.25), radius: 10)
             .shadow(color: Color(hex: "#806F67").opacity(0.34), radius: 9)

             // MARK: - Rectangle 5 (14.74 x 14.74) - dark overlay
             RoundedRectangle(cornerRadius: 2.58)
                 .fill(Color.black.opacity(0.2))
                 .frame(width: 14.74, height: 14.74)
                 .rotationEffect(.degrees(-45))

             // MARK: - Rectangle 4 (10.65 x 10.65) - 2 fills
             ZStack {
                 // 1. Linear بني/أزرق/ذهبي
                 LinearGradient(
                     stops: [
                         .init(color: Color(hex: "#8C421D"), location: 0.0675),
                         .init(color: Color(hex: "#122F72"), location: 0.3489),
                         .init(color: Color(hex: "#FCFBE7"), location: 0.5307),
                         .init(color: Color(hex: "#0E1741"), location: 0.7335),
                         .init(color: Color(hex: "#101858"), location: 0.9325),
                     ],
                     startPoint: .topLeading,
                     endPoint: .bottomTrailing
                 )

                 // 2. Diamond - بنفسجي
                 RadialGradient(
                     stops: [
                         .init(color: Color(hex: "#A349EF"), location: 0.4219),
                         .init(color: Color(hex: "#FF65E6"), location: 1.0),
                     ],
                     center: .init(x: -0.1625, y: 0.7333),
                     startRadius: 0,
                     endRadius: 12
                 )
             }
             .frame(width: 10.65, height: 10.65)
             .clipShape(RoundedRectangle(cornerRadius: 1.94))
             .overlay(
                 RoundedRectangle(cornerRadius: 1.94)
                     .strokeBorder(
                         LinearGradient(
                             colors: [Color.white.opacity(0.3), Color.white.opacity(0.05)],
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing
                         ),
                         lineWidth: 0.65
                     )
             )
             .rotationEffect(.degrees(-45))
             .shadow(color: .white.opacity(0.25), radius: 10)
             .shadow(color: Color(hex: "#806F67"), radius: 9)
         }
         // MARK: - Diamond الخارجي (30.29 x 30.29)
         .padding(6.46)
         .frame(width: 30.29, height: 30.29)
         .background(
             LinearGradient(
                 stops: [
                     .init(color: Color.white.opacity(0), location: 0.6958),
                     .init(color: Color.white.opacity(0.15), location: 1.0),
                 ],
                 startPoint: .top,
                 endPoint: .bottom
             )
             .clipShape(RoundedRectangle(cornerRadius: 7.11))
         )
         .overlay(
             RoundedRectangle(cornerRadius: 7.11)
                 .strokeBorder(
                     LinearGradient(
                         stops: [
                             .init(color: Color.white.opacity(0.28), location: 0.0),
                             .init(color: Color.white.opacity(0.05), location: 0.5),
                             .init(color: Color.white.opacity(0.28), location: 1.0),
                         ],
                         startPoint: .topLeading,
                         endPoint: .bottomTrailing
                     ),
                     lineWidth: 0.65
                 )
         )
         .shadow(color: Color.white.opacity(0.1), radius: 4, x: 0, y: 0)
         .rotationEffect(.degrees(45))
     }
 }

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

 #Preview {
     ZStack {
         Color.black
         DiamondView()
     }
 }
 
 */
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
