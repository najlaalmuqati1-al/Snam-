//
//  Reward.swift
//  Snam
//
//  Created by Jojo on 04/06/2026.
//


import SwiftUI

struct PortfolioCongratsView: View {
    @ObservedObject var vm: PortfolioViewModel
    @State private var bouncing = false
    @State private var appeared = false
    @State private var showCoins = false

    var body: some View {
        ZStack(alignment: .bottom) {

            // ── خلفية معتمة ──
            Color(red: 0.082, green: 0.082, blue: 0.082).opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            // ── Glow عند الصورة ──
            Ellipse()
                .fill(Color(red: 0.671, green: 0.741, blue: 0.894))
                .frame(width: 184, height: 190)
                .blur(radius: 50)
                .shadow(color: Color(red: 0.690, green: 0.910, blue: 0.992), radius: 125)
                .offset(y: -80)
                .allowsHitTesting(false)

            // ── Bottom Sheet ──
            VStack(spacing: 0) {

                // تهانينا!!
                Text("تهانينا!!")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.white)
                    .padding(.top, 24)

                // لقد حصلت على
                Text("لقد حصلت على")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color(red: 0.412, green: 0.467, blue: 0.569))
                    .padding(.top, 4)

                // صورة العملة
                ZStack {
                    Circle()
                        .fill(Color(red: 0.67, green: 0.74, blue: 0.89).opacity(0.1))
                        .frame(width: 130, height: 130)
                        .blur(radius: 16)

                    Image("currency")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .scaleEffect(bouncing ? 1.04 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.9).repeatForever(autoreverses: true),
                            value: bouncing
                        )
                }
                .padding(.vertical, 10)

                // +١٠٠
                Text("+١٠٠")
                    .font(.system(size: 70, weight: .black))
                    .foregroundColor(.white)

                // نقاط مكافأة
                Text("نقاط مكافأة")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(red: 0.412, green: 0.467, blue: 0.569))
                    .padding(.top, 2)

                Spacer(minLength: 0)

                // زر اجمع
                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        showCoins = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        vm.collectReward()
                    }
                }) {
                    Text("اجمع")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 300, height: 44)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color(red: 0.137, green: 0.235, blue: 0.455))
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color(red: 0.902, green: 0.902, blue: 0.902))
                                    .blendMode(.plusDarker)
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 100))
                        .shadow(color: .black.opacity(0.1), radius: 1, x: 0, y: 0)
                        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
                        .overlay(
                            RoundedRectangle(cornerRadius: 100)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                }
                .padding(.bottom, 32)
            }
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.55)
            .background(
                ZStack {
                    UnevenRoundedRectangle(
                        topLeadingRadius: 34,
                        bottomLeadingRadius: 58,
                        bottomTrailingRadius: 58,
                        topTrailingRadius: 34
                    )
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.black.opacity(0.6),
                                Color.black.opacity(0.6)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: .black.opacity(0.12), radius: 40, x: 0, y: 8)

                    UnevenRoundedRectangle(
                        topLeadingRadius: 34,
                        bottomLeadingRadius: 58,
                        bottomTrailingRadius: 58,
                        topTrailingRadius: 34
                    )
                    .fill(Color.black.opacity(0.004))
                }
            )
            .offset(y: appeared ? 0 : UIScreen.main.bounds.height)
            .animation(.spring(response: 0.55, dampingFraction: 0.85), value: appeared)

            // ── Floating Coins ──
            ZStack {
                if showCoins {
                    ForEach(0..<12, id: \.self) { i in
                        CongratsFloatingCoin(index: i)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .allowsHitTesting(false)
        }
        .ignoresSafeArea()
        .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            bouncing = true
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85)) {
                appeared = true
            }
        }
    }

    func dismiss() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            appeared = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            vm.collectReward()
        }
    }
}

// MARK: - Floating Coin

struct CoinData {
    let width: CGFloat
    let height: CGFloat
    let xOffset: CGFloat
    let yOffset: CGFloat
    let rotation: Double
}

struct CongratsFloatingCoin: View {
    let index: Int
    @State private var fly = false

    // بيانات كل عملة من الـ Figma
    private let coins: [CoinData] = [
        // يمين — كبيرة مع rotation
        CoinData(width: 172, height: 178, xOffset: 0,    yOffset: -260, rotation: 7.39),
        // يمين فوق — صغيرة
        CoinData(width: 114, height: 93,  xOffset: 110,  yOffset: -320, rotation: -25),
        // يمين وسط
        CoinData(width: 113, height: 92,  xOffset: 130,  yOffset: -240, rotation: -15),
        // يمين تحت
        CoinData(width: 114, height: 80,  xOffset: 100,  yOffset: -180, rotation: 10),
        // يسار فوق — صغيرة
        CoinData(width: 86,  height: 93,  xOffset: -120, yOffset: -300, rotation: 30),
        // يسار وسط
        CoinData(width: 85,  height: 92,  xOffset: -140, yOffset: -220, rotation: 20),
        // يسار تحت
        CoinData(width: 86,  height: 80,  xOffset: -110, yOffset: -160, rotation: -10),
        // وسط فوق
        CoinData(width: 60,  height: 60,  xOffset: -30,  yOffset: -340, rotation: 5),
        // وسط يمين
        CoinData(width: 50,  height: 50,  xOffset: 60,   yOffset: -350, rotation: -20),
        // وسط يسار
        CoinData(width: 50,  height: 50,  xOffset: -60,  yOffset: -350, rotation: 15),
        // تحت يمين
        CoinData(width: 45,  height: 45,  xOffset: 150,  yOffset: -150, rotation: -5),
        // تحت يسار
        CoinData(width: 45,  height: 45,  xOffset: -150, yOffset: -150, rotation: 8),
    ]

    var body: some View {
        let coin = coins[index % coins.count]

        Image("currency")
            .resizable()
            .scaledToFit()
            .frame(width: coin.width * 1, height: coin.height * 1)
            .rotationEffect(.degrees(coin.rotation))
            .opacity(fly ? 0 : 0.85)
            .offset(
                x: fly ? coin.xOffset : 0,
                y: fly ? coin.yOffset : 0
            )
            .scaleEffect(fly ? 0.8 : 0.3)
            .animation(
                .spring(response: 0.8, dampingFraction: 0.6)
                .delay(Double(index) * 0.06),
                value: fly
            )
            .onAppear {
                withAnimation {
                    fly = true
                }
            }
    }
}
#Preview {
    PortfolioRootView()
}
