//
//  CardTheme.swift
//  snam
//
//  Created by Faitmh ibrahim on 21/12/1447 AH.
//

import SwiftUI

// MARK: - Card Theme Model
struct CardTheme: Identifiable, Equatable {
    let id: Int
    let name: String
    let backgroundImage: String // Asset name
    let textColor: Color
    let accentColor: Color
}

// MARK: - Available Themes
extension CardTheme {
    static let allThemes: [CardTheme] = [
        CardTheme(
            id: 0,
            name: "الكلاسيكي الداكن",
            backgroundImage: "card_dark_classic",
            textColor: .primary,
            accentColor: .primary
        ),
        CardTheme(
            id: 1,
            name: "الوطني الأخضر",
            backgroundImage: "card_green_national",
            textColor: .primary,
            accentColor: .primary
        ),
        CardTheme(
            id: 2,
            name: "الوردي اللامع",
            backgroundImage: "card_pink_glitter",
            textColor: .primary,
            accentColor: .primary
        ),
        CardTheme(
            id: 3,
            name: "الربيعي الفاتح",
            backgroundImage: "card_spring_light",
            textColor: .primary,
            accentColor: .primary
        ),
    ]
}

// MARK: - Wallet Card View
struct WalletCardView: View {
    let theme: CardTheme
    let holderName: String
    var isPreview: Bool = false

    private func svArabic(_ weight: String, size: CGFloat) -> Font {
        .custom("SVArabic-\(weight)", size: size, relativeTo: .body)
    }

    var body: some View {
        ZStack {
            Image(theme.backgroundImage)
                .resizable()
                .scaledToFill()
                .clipped()

            VStack(spacing: isPreview ? 4 : 6) {
                Text("فلوسك الافتراضية")
                    .font(svArabic("Bold", size: isPreview ? 12 : 14))
                    .foregroundColor(.primary.opacity(0.95))
                    .frame(maxWidth: .infinity, alignment: .center)

                Text("00.00")
                    .font(svArabic("Black", size: isPreview ? 42 : 54))
                    .foregroundColor(.primary)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)

            VStack {
                Spacer()
                HStack(spacing: isPreview ? 2 : 3) {
                    Spacer()
                    Text(holderName)
                        .font(svArabic("Medium", size: isPreview ? 12 : 14))
                        .foregroundColor(.primary.opacity(0.9))
                        .padding(.trailing, isPreview ? -7 : -7)

                    Image("camel_icon")
                        .resizable()
                        .scaledToFit()
                        .frame(width: isPreview ? 24 : 32, height: isPreview ? 24 : 32)
                        .foregroundColor(.primary)
                }
                .padding(.trailing, isPreview ? 12 : 16)
                .padding(.bottom, isPreview ? 12 : 16)
            }
        }
        .frame(
            width: isPreview ? nil : UIScreen.main.bounds.width - 48,
            height: isPreview ? 172 : 180
        )
        .frame(maxWidth: isPreview ? .infinity : nil)
        .clipShape(RoundedRectangle(cornerRadius: isPreview ? 16 : 20, style: .continuous))
        .shadow(color: .black.opacity(0.25), radius: isPreview ? 8 : 14, x: 0, y: 6)
    }
}

// MARK: - Theme Option Row
struct ThemeOptionRow: View {
    let theme: CardTheme
    let holderName: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .topTrailing) {
                WalletCardView(
                    theme: theme,
                    holderName: holderName,
                    isPreview: true
                )
                .frame(height: 172)
                .shadow(color: .black.opacity(0.25), radius: 10, x: 0, y: 6)
                .frame(maxWidth: .infinity, alignment: .center)

                if isSelected {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 32, height: 32)
                            .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 1))
                            .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 2)

                        Image(systemName: "checkmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .offset(x: 16, y: -16)
                    .transition(.scale.combined(with: .opacity))
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.vertical, 6)
    }
}

// MARK: - Preview for card only
#Preview {
    WalletCardView(
        theme: CardTheme.allThemes[0],
        holderName: "مزنة سنام"
    )
}
