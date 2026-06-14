//Bottom Sheet
//  Reward.swift
//  Snam
//
//  Created by Jojo on 09/06/2026.
//


import SwiftUI
import AVFoundation



struct PortfolioCongratsView: View {
    @ObservedObject var vm: PortfolioViewModel
    var onFinished: () -> Void
    @AppStorage("currentLevel") private var currentLevel: Int = 1
    @State private var bouncing = false
    @State private var appeared = false
    @State private var showCoins = false

    var body: some View {
        ZStack(alignment: .bottom) {

            Color(red: 0.082, green: 0.082, blue: 0.082).opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture { dismiss() }

            Ellipse()
                .fill(Color(red: 0.671, green: 0.741, blue: 0.894))
                .frame(width: 184, height: 190)
                .blur(radius: 50)
                .shadow(color: Color(red: 0.690, green: 0.910, blue: 0.992), radius: 125)
                .offset(y: -80)
                .allowsHitTesting(false)

            VStack(spacing: 0) {

                Text("مبروك!")
                    .font(.system(size: 48, weight: .black))
                    .foregroundColor(.white)
                    .padding(.top, 24)

                Text("لإنك كفو تستاهل")
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color(red: 0.412, green: 0.467, blue: 0.569))
                    .padding(.top, 4)

                ZStack {
                    Circle()
                        .fill(Color(red: 0.67, green: 0.74, blue: 0.89).opacity(0.1))
                        .frame(width: 130, height: 130)
                        .blur(radius: 16)

                    Image("currency")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170, height: 170)
                        .scaleEffect(bouncing ? 1.04 : 1.0)
                        .animation(
                            .easeInOut(duration: 0.9).repeatForever(autoreverses: true),
                            value: bouncing
                        )
                }
                .padding(.vertical, 10)

                Text("+١٠٠")
                    .font(.system(size: 70, weight: .black))
                    .foregroundColor(.white)

                Text("سنام مكافأة لك")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Color(red: 0.412, green: 0.467, blue: 0.569))
                    .padding(.top, 2)

                Spacer(minLength: 0)

                Button(action: {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                        showCoins = true
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                        if currentLevel < 5 { currentLevel += 1 }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        onFinished()
                    }
                }) {
                    Text("جمع")
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
            .frame(height: UIScreen.main.bounds.height * 0.65)
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
            if currentLevel < 5 { currentLevel += 1 }
        }
    }
}

// MARK: - Floating Coin

struct CoinData {
    let imageName: String
    let width: CGFloat
    let height: CGFloat
    let xOffset: CGFloat
    let yOffset: CGFloat
    let rotation: Double
    let delay: Double
}

struct CongratsFloatingCoin: View {
    let index: Int
    @State private var fly = false
    @State private var player: AVAudioPlayer?

    private let coins: [CoinData] = [
        CoinData(imageName: "1", width: 75, height: 75, xOffset:  60,  yOffset: -80,  rotation: -5,  delay: 0.0),
        CoinData(imageName: "2", width: 70, height: 70, xOffset:  120, yOffset: -150, rotation: 15,  delay: 0.25),
        CoinData(imageName: "3", width: 72, height: 72, xOffset:  90,  yOffset: -20,  rotation: -20, delay: 0.5),
        CoinData(imageName: "4", width: 68, height: 68, xOffset:  150, yOffset: -100, rotation: 10,  delay: 0.75),
        CoinData(imageName: "5", width: 38, height: 65, xOffset:  40,  yOffset: 50,   rotation: -35, delay: 1.0),

        CoinData(imageName: "1", width: 75, height: 75, xOffset: -60,  yOffset: -80,  rotation: 5,   delay: 0.0),
        CoinData(imageName: "2", width: 70, height: 70, xOffset: -120, yOffset: -150, rotation: -15, delay: 0.25),
        CoinData(imageName: "3", width: 72, height: 72, xOffset: -90,  yOffset: -20,  rotation: 20,  delay: 0.5),
        CoinData(imageName: "4", width: 68, height: 68, xOffset: -150, yOffset: -100, rotation: -10, delay: 0.75),
        CoinData(imageName: "5", width: 38, height: 65, xOffset: -40,  yOffset: 50,   rotation: 35,  delay: 1.0),
    ]

    @State private var players: [AVAudioPlayer] = []

    private func playSound() {
        guard let url = Bundle.main.url(forResource: "Sound", withExtension: "mp3") else {
            print("❌ ما لقى الملف Sound.mp3")
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            let newPlayer = try AVAudioPlayer(contentsOf: url)
            newPlayer.volume = 0.6
            newPlayer.play()
            players.append(newPlayer)
        } catch {
            print("❌ Sound error: \(error)")
        }
    }

    var body: some View {
        let coin = coins[index % coins.count]

        Image(coin.imageName)
            .resizable()
            .scaledToFit()
            .frame(width: coin.width, height: coin.height)
            .rotationEffect(.degrees(coin.rotation))
            .opacity(fly ? 1 : 0)
            .offset(
                x: fly ? coin.xOffset : 0,
                y: fly ? coin.yOffset : -UIScreen.main.bounds.height * 0.6
            )
            .animation(
                .spring(response: 2.5, dampingFraction: 0.85)
                .delay(coin.delay),
                value: fly
            )
            .onAppear {
                let delay = coin.delay
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    playSound()
                }
                withAnimation {
                    fly = true
                }
            }
    }
}

#Preview {
    PortfolioCongratsView(vm: {
        let vm = PortfolioViewModel()
        return vm
    }(), onFinished: {})
    .environmentObject(WalletState())
}
