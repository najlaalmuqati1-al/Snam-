//
//  StockTypeLevelView.swift
//  Snam
//
//  Created by Najla Almuqati on 25/12/1447 AH.
//
import SwiftUI

struct StockTypeLevelView: View {
    @State private var currentStep = 1
    @State private var selectedCard: Int? = nil
    @StateObject private var vm = MarketViewModelNew()
    @State private var company: Company?
    @EnvironmentObject var walletState: WalletState
    @State private var visitedSpeculative = false
    @State private var visitedSafe = false
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedTab") private var selectedTab: Int = 2
    // مكافأة
    @State private var showReward = false
    @StateObject private var rewardVM = PortfolioViewModel()

    // محاكاة السهم المضارب (10 ثواني، حركة سريعة)
    @State private var isSimulatingSpeculative = false
    @State private var pricesForChart: [Double] = []
    @State private var speculativeTimer: Timer?
    @State private var ticksRemaining: Int = 0 // 50 نبضة × 0.2 ثانية ≈ 10 ثوانٍ

    // محاكاة السهم الآمن (5 ثواني، حركة بطيئة جداً)
    @State private var isSimulatingSafe = false
    @State private var pricesForSafeChart: [Double] = []
    @State private var safeTimer: Timer?
    @State private var safeTicksRemaining: Int = 0 // 25 نبضة × 0.2 ثانية ≈ 5 ثوانٍ

    var body: some View {
        ZStack {
            // الخلفية الموحدة من ملف الباكقروند (Image("Frame") فوق systemBackground)
            Color(.systemBackground)
                .ignoresSafeArea()
                .overlay(
                    Image("Frame")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )

            // الواجهة الرئيسية
            VStack(spacing: 24) {
                VStack(spacing: 24) {
                    Text("اختار نوع السهم")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    // بطاقات الخلفية
                    VStack(spacing: 16) {
                        // السهم المضارب (زر يفتح Popup)
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                                selectedCard = 1
                                visitedSpeculative = true
                                stopSafeSimulation()
                                startSpeculativeSimulation()
                            }
                        } label: {
                            HStack {
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                    .font(.system(size: 80, weight: .medium))
                                    .foregroundColor(Color(red: 157/255, green: 181/255, blue: 239/255))

                                Spacer()

                                VStack(alignment: .trailing, spacing: 18) {
                                    Text("السهم المضارب")
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("تشتري وتراقب وش يتغير بالسهم.")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                            .padding(.horizontal, 28)
                            .frame(width: 361, height: 176)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.black.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)

                        // السهم الآمن (زر يفتح Popup)
                        Button {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                                selectedCard = 2
                                visitedSafe = true
                                stopSpeculativeSimulation()
                                startSafeSimulation()
                            }
                        } label: {
                            HStack {
                                ZStack {
                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                        .font(.system(size: 80, weight: .medium))
                                        .foregroundColor(Color(red: 157/255, green: 181/255, blue: 239/255))
                                    Image(systemName: "shield.fill")
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(Color(red: 157/255, green: 181/255, blue: 239/255))
                                        .offset(x: 29, y: -18)
                                }
                                .frame(width: 90, height: 90)

                                Spacer()

                                VStack(alignment: .trailing, spacing: 18) {
                                    Text("السهم الآمن")
                                        .font(.system(size: 28, weight: .semibold))
                                        .foregroundColor(.white)
                                    Text("تشتري بدون ما تراقب بشكل مستمر وش يتغير بالسهم.")
                                        .font(.system(size: 20))
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .multilineTextAlignment(.trailing)
                                }
                            }
                            .padding(.horizontal, 28)
                            .frame(width: 361, height: 176)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.black.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                    )
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    if visitedSpeculative && visitedSafe {
                        PrimaryButton(title: "خلصت") {
                            showReward = true
                        }
                        .padding(.top, 8)
                        .fullScreenCover(isPresented: $showReward) {
                            PortfolioCongratsView(
                                vm: rewardVM,
                                onFinished: {
                                    walletState.collectReward(forLevel: 4)
                                    selectedTab = 2
                                    dismiss()
                                }
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            .onAppear {
                company = vm.marketData?.companies.randomElement()
            }

            // Overlay: خلفية معتمة خفيفة + الـ Popup
            if let selected = selectedCard {
                Color.black.opacity(0.55)
                    .ignoresSafeArea()
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                            closePopup()
                        }
                    }

                popupContent(for: selected)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
            }
        }
        .navigationTitle("المستثمر الذكي")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Popup Content
    @ViewBuilder
    private func popupContent(for card: Int) -> some View {
        // Precompute small values to reduce type-checking complexity
        let isSpeculative = (card == 1)
        let timeText = isSpeculative ? "بعد ساعتين" : "بعد ٦ أشهر"
        let titleText = isSpeculative ? "السهم المضارب" : "السهم الامن"
        let showDescription: Bool = {
            if isSpeculative { return !isSimulatingSpeculative && ticksRemaining == 0 }
            return !isSimulatingSafe && safeTicksRemaining == 0
        }()
        let descriptionText: String = isSpeculative
        ? "هنا تشتري وتبيع في نفس اليوم أو الأسبوع عشان تطلع بربح سريع من حركة السعر. في المضاربة، أنت ما يهمك وش تسوي الشركة أو وش قيمتها، المهم عندك إذا السعر بيرتفع أو ينخفض."
        : "هذا السهم حق المدى الطويل.\n تشتري فيه وتخليه سنين عشان فلوسك تكبر بهدوء وأمان. الشركات هنا تكون عملاقة وراسخة بالسوق، وما تهزها الأزمات بسهولة."
        let livePrice = currentDisplayedPrice(for: card)
        let displayedPrices: [Double] = {
            guard let company else { return [] }
            let base = company.chartData.timeframes.oneDay.map { $0.price }
            if isSpeculative {
                return (isSimulatingSpeculative || !pricesForChart.isEmpty) ? pricesForChart : base
            } else {
                return (isSimulatingSafe || !pricesForSafeChart.isEmpty) ? pricesForSafeChart : base
            }
        }()

        VStack(spacing: 0) {
            HStack {
                Spacer()
                Button {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                        closePopup()
                    }
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white.opacity(0.9))
                        .padding(10)
                        .background(Color.white.opacity(0.12))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)

            VStack(spacing: 20) {
                PopupHeaderView(
                    timeText: timeText,
                    livePrice: livePrice,
                    company: company
                )

                if !displayedPrices.isEmpty {
                    MarketBigChartView(prices: displayedPrices)
                        .frame(height: 180)
                }

                Text(titleText)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .trailing)

                if showDescription {
                    PopupDescriptionView(text: descriptionText)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.black.opacity(0.35))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
            )
            .frame(width: 361)
            .padding(.bottom, 16)
        }
        .padding(.horizontal, 16)
    }

    private func currentDisplayedPrice(for card: Int) -> Double? {
        if card == 1 {
            if let last = pricesForChart.last { return last }
            if let company { return company.stock.currentPrice }
        } else {
            if let last = pricesForSafeChart.last { return last }
            if let company { return company.stock.currentPrice }
        }
        return nil
    }

    private func closePopup() {
        if selectedCard == 1 {
            stopSpeculativeSimulation()
        } else if selectedCard == 2 {
            stopSafeSimulation()
        }
        selectedCard = nil
    }

    // MARK: - Speculative Simulation
    private func startSpeculativeSimulation() {
        guard let company else { return }
        stopSpeculativeSimulation()

        let base = max(1.0, company.stock.currentPrice)
        var seed = base
        pricesForChart = [seed]

        isSimulatingSpeculative = true
        ticksRemaining = 50

        speculativeTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            let volatility: Double = max(0.5, base * 0.01)
            let jump = Double.random(in: -2.5...2.5) * volatility
            seed = max(0.1, seed + jump)

            if pricesForChart.count > 120 {
                pricesForChart.removeFirst()
            }
            pricesForChart.append(seed)

            ticksRemaining -= 1
            if ticksRemaining <= 0 {
                stopSpeculativeSimulation()
            }
        }
        RunLoop.main.add(speculativeTimer!, forMode: .common)
    }

    private func stopSpeculativeSimulation() {
        speculativeTimer?.invalidate()
        speculativeTimer = nil
        isSimulatingSpeculative = false
    }

    // MARK: - Safe Simulation
    private func startSafeSimulation() {
        guard let company else { return }
        stopSafeSimulation()

        let base = max(1.0, company.stock.currentPrice)
        var seed = base
        pricesForSafeChart = [seed]

        isSimulatingSafe = true
        safeTicksRemaining = 25

        safeTimer = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            let tinyVolatility = max(0.02, base * 0.0005)
            let jump = Double.random(in: -1.0...1.0) * tinyVolatility
            let drift = Double.random(in: -0.3...0.3) * tinyVolatility
            seed = max(0.1, seed + jump + drift)

            if pricesForSafeChart.count > 120 {
                pricesForSafeChart.removeFirst()
            }
            pricesForSafeChart.append(seed)

            safeTicksRemaining -= 1
            if safeTicksRemaining <= 0 {
                stopSafeSimulation()
            }
        }
        RunLoop.main.add(safeTimer!, forMode: .common)
    }

    private func stopSafeSimulation() {
        safeTimer?.invalidate()
        safeTimer = nil
        isSimulatingSafe = false
    }
}

// MARK: - Small extracted views to help the type-checker

private struct PopupHeaderView: View {
    let timeText: String
    let livePrice: Double?
    let company: Company?

    var body: some View {
        HStack(alignment: .top) {
            // Time
            VStack(spacing: 8) {
                Image(systemName: "clock")
                    .font(.system(size: 15))
                    .foregroundColor(Color(red: 157/255, green: 181/255, blue: 239/255))
                Text(timeText)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.8))
            }

            Spacer()

            // Company name + change
            VStack(alignment: .trailing, spacing: 6) {
                HStack(spacing: 12) {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("بيرن اكس")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text("قطاع الأعمال")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)

                        HStack(spacing: 8) {
                            if let livePrice {
                                let livePriceText = arabicNumerals(String(format: "%.2f", livePrice))
                                Text(livePriceText)
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.white)
                            }

                            if let company {
                                let change = company.stock.changePercent
                                let changeAbs = String(format: "%.2f", change)
                                let changePrefix = change >= 0 ? "+" : ""
                                let changeText = arabicNumerals("\(changePrefix)\(changeAbs)%")
                                let changeColor: Color = change >= 0 ? .green : .red

                                Text(changeText)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(changeColor)
                            }
                        }
                    }

                    Image("bx")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                }
            }
        }
    }
}

private struct PopupDescriptionView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.system(size: 18))
            .foregroundColor(.white.opacity(0.5))
            .multilineTextAlignment(.trailing)
    }
}

// MARK: - التعديل هنا لإصلاح الـ Preview المنهار
#Preview {
    AppContainerView {
        NavigationStack {
            StockTypeLevelView()
        }
    }
    // نقوم بحقن كائن بيئة افتراضي لـ WalletState ليعمل الـ Preview بشكل سليم
    .environmentObject(WalletState())
}
