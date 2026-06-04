//
//  PortfolioView.swift
//  Snam
//
//  Created by Jojo on 03/06/2026.
/*
import SwiftUI
import Combine

// MARK: - Model

struct PortfolioSector: Identifiable, Equatable {
    let id = UUID()
    let name: String
    let icon: String
    var allocation: Int = 0
}

// MARK: - ViewModel

class PortfolioViewModel: ObservableObject {
    @Published var totalBalance: Int = 500
    @Published var sectors: [PortfolioSector] = [
        PortfolioSector(name: "التقنية",  icon: "cpu"),
        PortfolioSector(name: "الترفيه", icon: "theatermasks.fill"),
        PortfolioSector(name: "الطاقة",  icon: "bolt.fill"),
        PortfolioSector(name: "السياحة", icon: "airplane"),
    ]
    @Published var selectedTabIDs: [UUID] = []   // ordered list of selected tabs
    @Published var expandedID: UUID? = nil        // which card has slider open
    @Published var showCongrats: Bool = false
    @Published var showDiversifyTip: Bool = false

    var remaining: Int {
        totalBalance - sectors.reduce(0) { $0 + $1.allocation }
    }

    var allocatedCount: Int {
        sectors.filter { $0.allocation > 0 }.count
    }

    func selectTab(_ id: UUID) {
        if selectedTabIDs.contains(id) {
            selectedTabIDs.removeAll { $0 == id }
            if expandedID == id { expandedID = nil }
        } else {
            selectedTabIDs.append(id)
        }
    }

    func toggleExpand(_ id: UUID) {
        if expandedID == id {
            expandedID = nil
        } else {
            expandedID = id
        }
    }

    func updateAllocation(id: UUID, value: Int) {
        guard let i = sectors.firstIndex(where: { $0.id == id }) else { return }
        let maxAllowable = remaining + sectors[i].allocation
        sectors[i].allocation = max(0, min(value, maxAllowable))
        withAnimation { showDiversifyTip = selectedTabIDs.count >= 2 }
    }

    func increment(id: UUID) {
        guard let i = sectors.firstIndex(where: { $0.id == id }) else { return }
        updateAllocation(id: id, value: sectors[i].allocation + 1)
    }

    func decrement(id: UUID) {
        guard let i = sectors.firstIndex(where: { $0.id == id }) else { return }
        updateAllocation(id: id, value: sectors[i].allocation - 25)
    }

    func resetWallet() {
        for i in sectors.indices { sectors[i].allocation = 0 }
        selectedTabIDs = []
        expandedID = nil
        showDiversifyTip = false
    }

    func confirm() {
        withAnimation { showCongrats = true }
    }

    func collectReward() {
        withAnimation {
            showCongrats = false
            resetWallet()
        }
    }
}

// MARK: - Root

struct PortfolioRootView: View {
    @StateObject private var vm = PortfolioViewModel()

    var body: some View {
        ZStack {
            if vm.showCongrats {
                PortfolioCongratsView(vm: vm)
                    .transition(.opacity.combined(with: .scale))
            } else {
                PortfolioMainView(vm: vm)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.4), value: vm.showCongrats)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Main View

struct PortfolioMainView: View {
    @ObservedObject var vm: PortfolioViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background
            Color(red: 0.06, green: 0.08, blue: 0.13)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Nav bar
                    navBar
                        .padding(.top, 52)
                        .padding(.bottom, 8)

                    // Subtitle
                    Text("وزع المبلغ التالي كحد ادنى على قطاعين مختلفين")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.55))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)

                    // Balance card
                    balanceCard
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)

                    // Tabs
                    tabsRow
                        .padding(.bottom, 16)

                    // Sector cards — only selected ones, in order
                    VStack(spacing: 10) {
                        ForEach(vm.selectedTabIDs, id: \.self) { tabID in
                            if let idx = vm.sectors.firstIndex(where: { $0.id == tabID }) {
                                SectorRowCard(
                                    sector: $vm.sectors[idx],
                                    vm: vm,
                                    isExpanded: vm.expandedID == tabID
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.selectedTabIDs.count)

                    // Hint: only one sector selected
                    if vm.selectedTabIDs.count == 1 {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.45))
                            Text("اختر قطاع آخر لتوزيع أموالك")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.45))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    // Hint: diversify (2+ sectors)
                    if vm.selectedTabIDs.count >= 2 {
                        bottomHints
                            .padding(.top, 16)
                            .padding(.horizontal, 20)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer(minLength: 100)
                }
            }

            // Confirm button pinned at bottom
            confirmBtn
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.06, green: 0.08, blue: 0.13).opacity(0),
                            Color(red: 0.06, green: 0.08, blue: 0.13)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)
                    .allowsHitTesting(false)
                )
        }
    }

    // MARK: Nav bar
    var navBar: some View {
        HStack {
            Spacer()
            Text("تحدي التنويع")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: Balance Card
    var balanceCard: some View {
        // Exact Figma spec: 355x126, background rgba(0,0,0,0.2), radius 12
        // Layout LTR: [coins image] | [المبلغ الكلي] | [divider 1x66] | [الرصيد المتبقي]
        HStack(spacing: 0) {

            // ── Coins image — physical LEFT ──
            ZStack {
                // back coin
                Image("currency")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 75, height: 75)
                    .offset(x: 10, y: 0)
                // front coin
                Image("currency")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .offset(x: -12, y: 0)
            }
            .frame(width: 100, height: 126)

            // ── المبلغ الكلي ──
            VStack(alignment: .center, spacing: 6) {
                Text("الرصيد المتبقي")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color.white.opacity(0.55))
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text("\(vm.totalBalance)")                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(
                            vm.remaining == 0
                                ? Color(red: 1, green: 0.35, blue: 0.35)
                                : Color(red: 0.35, green: 0.6, blue: 1.0)
                        )
                    Text("سنام")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.35, green: 0.6, blue: 1.0).opacity(0.8))
                }
            }
            .frame(maxWidth: .infinity)

            // ── Divider: 1pt x 66pt ──
            Rectangle()
                .fill(Color.white)
                .frame(width: 1, height: 66)

            // ── الرصيد المتبقي (blue) ──
                       VStack(alignment: .center, spacing: 6) {

                            Text("المبلغ الكلي")

                                .font(.system(size: 12, weight: .medium))

                                .foregroundColor(Color.white.opacity(0.55))

                            HStack(alignment: .firstTextBaseline, spacing: 4) {

                                Text("\(vm.remaining)")                        .font(.system(size: 26, weight: .bold))

                                    .foregroundColor(.white)

                                Text("سنام")

                                    .font(.system(size: 12))

                                    .foregroundColor(Color.white.opacity(0.5))

                            }

                        }
            .frame(maxWidth: .infinity)

        }
        .frame(width: 355, height: 126)
        .background(
            ZStack {
                // blur layer
                RoundedRectangle(cornerRadius: 12)
                    .fill(.ultraThinMaterial)

                // dark tint
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black.opacity(0.25))

                // white border
                RoundedRectangle(cornerRadius: 12)
                    .stroke(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.45),
                                Color.white.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .environment(\.layoutDirection, .leftToRight)
    }

    // MARK: Tabs Row
    var tabsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(vm.sectors) { sector in
                    let isActive = vm.selectedTabIDs.contains(sector.id)
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            vm.selectTab(sector.id)
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: sector.icon)
                                .font(.system(size: 12))
                            Text(sector.name)
                                .font(.system(size: 13, weight: .semibold))
                            if sector.allocation > 0 {
                                Text("\(sector.allocation)")
                                    .font(.system(size: 11, weight: .bold))
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 2)
                                    .background(Capsule().fill(Color.white.opacity(0.2)))
                            }
                        }
                        .foregroundColor(isActive ? .white : Color.white.opacity(0.5))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(isActive
                                      ? Color(red: 0.22, green: 0.35, blue: 0.75)
                                      : Color.white.opacity(0.07))
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: Bottom Hints
    var bottomHints: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Text("تفريغ المحافظ")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Spacer()
            }
            .onTapGesture { withAnimation { vm.resetWallet() } }

            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Text("وزع باقي المبلغ على القطاعات المختاره")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Spacer()
            }
        }
    }

    // MARK: Confirm Button
    var confirmBtn: some View {
        let hasAny = vm.sectors.contains { $0.allocation > 0 }
        return Button(action: { if hasAny { vm.confirm() } }) {
            Text("تأكيد التوزيع")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(hasAny ? .white : Color.white.opacity(0.4))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: 50)
                        .fill(hasAny
                              ? Color(red: 0.22, green: 0.35, blue: 0.75)
                              : Color.white.opacity(0.08))
                )
        }
        .disabled(!hasAny)
        .animation(.easeInOut(duration: 0.2), value: hasAny)
    }
}

// MARK: - Sector Row Card

struct SectorRowCard: View {
    @Binding var sector: PortfolioSector
    @ObservedObject var vm: PortfolioViewModel
    let isExpanded: Bool

    var percentage: Int {
        guard vm.totalBalance > 0 else { return 0 }
        return Int(Double(sector.allocation) / Double(vm.totalBalance) * 100)
    }

    var sliderMax: Double {
        Double(vm.remaining + sector.allocation)
    }

    var body: some View {
        VStack(spacing: 0) {
            // Collapsed row — always visible
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                    vm.toggleExpand(sector.id)
                }
            })
            
            {
                HStack {
                    // Left: amount + percentage
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(sector.allocation) سنام")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.white.opacity(0.45))
                        Text("\(percentage)%")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.35))
                    }

                    Spacer()

                    // Name + icon
                    HStack(spacing: 8) {
                        Text(sector.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Image(systemName: sector.icon)
                            .font(.system(size: 18))
                            .foregroundColor(isExpanded
                                             ? Color(red: 0.4, green: 0.6, blue: 1.0)
                                             : Color.white.opacity(0.7))
                    }
                }
                .contentShape(Rectangle()) // ← هنا

                .padding(.horizontal, 18)
                .padding(.vertical, 18)
            }
            .buttonStyle(.plain)

            // Expanded slider
            if isExpanded {
                Divider()
                    .background(Color.white.opacity(0.08))
                    .padding(.horizontal, 18)

                VStack(spacing: 14) {
                    // Sector name centered + allocation label
                    VStack(spacing: 4) {
                        Image(systemName: sector.icon)
                            .font(.system(size: 22))
                            .foregroundColor(Color(red: 0.4, green: 0.6, blue: 1.0))
                        Text(sector.name)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        Text("(\(sector.allocation) سنام · \(percentage)%)")
                            .font(.system(size: 12))
                            .foregroundColor(Color.white.opacity(0.45))
                    }
                    .padding(.top, 8)

                    // Slider
                    Slider(
                        value: Binding(
                            get: { Double(sector.allocation) },
                            set: { v in
                                let s = Int(round(v / 25.0)) * 25
                                vm.updateAllocation(id: sector.id, value: s)
                            }
                        ),
                        in: 0...max(sliderMax, 25),
                        step: 25
                    )
                    .tint(Color(red: 0.4, green: 0.6, blue: 1.0))
                    .padding(.horizontal, 4)

                    // Min / Max labels + +/- buttons
                    HStack {
                        // Minus
                        Button(action: { vm.decrement(id: sector.id) }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.white.opacity(0.08))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "minus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }

                        Text("٠")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.35))

                        Spacer()

                        Text("\(Int(sliderMax))")
                            .font(.system(size: 13))
                            .foregroundColor(Color.white.opacity(0.35))

                        // Plus
                        Button(action: { vm.increment(id: sector.id) }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color(red: 0.22, green: 0.35, blue: 0.75))
                                    .frame(width: 32, height: 32)
                                Image(systemName: "plus")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.bottom, 12)
                }
                .padding(.horizontal, 18)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(isExpanded ? 0.09 : 0.05))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            isExpanded
                                ? Color(red: 0.4, green: 0.6, blue: 1.0).opacity(0.35)
                                : Color.clear,
                            lineWidth: 1
                        )
                )
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isExpanded)
    }
}

// MARK: - Congrats View

struct PortfolioCongratsView: View {
    @ObservedObject var vm: PortfolioViewModel
    @State private var bouncing = false
    @State private var appeared = false

    var body: some View {
        ZStack {
            Color(red: 0.06, green: 0.08, blue: 0.13).ignoresSafeArea()

            ForEach(0..<8, id: \.self) { i in
                PortfolioCoinFloat(index: i, appeared: appeared)
            }

            VStack(spacing: 28) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(RadialGradient(
                            colors: [Color(red: 0.3, green: 0.5, blue: 1.0).opacity(0.25), .clear],
                            center: .center, startRadius: 0, endRadius: 90
                        ))
                        .frame(width: 180, height: 180)

                    Image("currency")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .scaleEffect(bouncing ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true), value: bouncing)
                }

                VStack(spacing: 8) {
                    Text("تهانينا!!")
                        .font(.system(size: 38, weight: .black))
                        .foregroundColor(.white)
                    Text("لقد حصلت على")
                        .font(.system(size: 18))
                        .foregroundColor(Color.white.opacity(0.6))
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text("currency")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color(red: 0.4, green: 0.6, blue: 1.0))
                        Text("+١٠٠")
                            .font(.system(size: 52, weight: .black))
                            .foregroundColor(Color(red: 0.4, green: 0.6, blue: 1.0))
                    }
                }

                Spacer()

                Button(action: { vm.collectReward() }) {
                    Text("اجمع")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(Color(red: 0.22, green: 0.35, blue: 0.75))
                        )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 50)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .onAppear {
            bouncing = true
            withAnimation(.easeOut(duration: 0.5).delay(0.15)) { appeared = true }
        }
    }
}

// MARK: - Floating Coin

struct PortfolioCoinFloat: View {
    let index: Int
    let appeared: Bool
    private let xs: [CGFloat] = [-150, -90, -40, 10, 60, 110, 160, -120]
    private let ys: [CGFloat] = [-310, -200, -360, -260, -290, -330, -190, -240]

    var body: some View {
        Image("currency")
            .resizable()
            .scaledToFit()
            .frame(width: 36, height: 36)
            .opacity(appeared ? 0.65 : 0)
            .offset(x: xs[index % xs.count], y: appeared ? ys[index % ys.count] : 180)
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(Double(index) * 0.07), value: appeared)
    }
}
*/

import SwiftUI

// MARK: - Root

struct PortfolioRootView: View {
    @StateObject private var vm = PortfolioViewModel()

    var body: some View {
        ZStack {
            PortfolioMainView(vm: vm)

            if vm.showCongrats {
                PortfolioCongratsView(vm: vm)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: vm.showCongrats)
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Main View

struct PortfolioMainView: View {
    @ObservedObject var vm: PortfolioViewModel

    var body: some View {
        ZStack(alignment: .bottom) {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    navBar
                        .padding(.top, 90)
                        .padding(.bottom, 20)

                    Text("وزع المبلغ التالي كحد ادنى على قطاعين مختلفين")
                        .font(.system(size: 13, weight: .regular))
                        .foregroundColor(Color.white.opacity(0.55))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 20)

                    balanceCard
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)

                    tabsRow
                        .padding(.bottom, 16)

                    VStack(spacing: 10) {
                        ForEach(vm.selectedTabIDs, id: \.self) { tabID in
                            if let idx = vm.sectors.firstIndex(where: { $0.id == tabID }) {
                                SectorRowCard(
                                    sector: $vm.sectors[idx],
                                    vm: vm,
                                    isExpanded: vm.expandedID == tabID
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: vm.selectedTabIDs.count)

                    if vm.selectedTabIDs.count == 1 {
                        HStack(spacing: 6) {
                            Image(systemName: "info.circle")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.45))
                            Text("اختر قطاع آخر لتوزيع أموالك")
                                .font(.system(size: 13))
                                .foregroundColor(Color.white.opacity(0.45))
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    if vm.selectedTabIDs.count >= 2 {
                        bottomHints
                            .padding(.top, 16)
                            .padding(.horizontal, 20)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
                    }

                    Spacer(minLength: 100)
                }
            }

            confirmBtn
                .padding(.horizontal, 16)
                .padding(.bottom, 36)
                .background(
                    LinearGradient(
                        colors: [
                            Color(red: 0.06, green: 0.08, blue: 0.13).opacity(0),
                            Color(red: 0.06, green: 0.08, blue: 0.13)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 120)
                    .allowsHitTesting(false)
                )
        }
    }

    // MARK: Nav Bar
    var navBar: some View {
        HStack {
            Spacer()
            Text("تحدي التنويع")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Spacer()
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: Balance Card
    var balanceCard: some View {
        HStack(spacing: 0) {

            // الصورتين
            ZStack {
                // الكبيرة مع rotation
                Image("currency")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 78, height: 94)
                    .rotationEffect(.degrees(7.39))
                    .offset(x: -8, y: 0)

                // الصغيرة
                Image("currency")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 57, height: 69)
                    .offset(x: 18, y: 8)
            }
            .frame(width: 100, height: 110)

            // الرصيد المتبقي — صار أول
            VStack(alignment: .center, spacing: 15) {
                Text("الرصيد المتبقي")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(red: 0.514, green: 0.514, blue: 0.514))
                    .tracking(-0.4)

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("سنام")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.514, green: 0.514, blue: 0.514))
                    Text(arabicNumber(vm.remaining))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(
                            vm.remaining == 0
                                ? Color(red: 1, green: 0.35, blue: 0.35)
                                : Color(red: 0.427, green: 0.565, blue: 0.898)
                        )
                }
            }
            .frame(maxWidth: .infinity)

            // Divider
            Rectangle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 1, height: 66)

            // المبلغ الكلي — صار ثاني
            VStack(alignment: .center, spacing: 15) {
                Text("المبلغ الكلي")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(red: 0.514, green: 0.514, blue: 0.514))
                    .tracking(-0.4)

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("سنام")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.514, green: 0.514, blue: 0.514))
                    Text(arabicNumber(vm.totalBalance))                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.white)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(maxWidth: .infinity)
        }
        .frame(width: 355, height: 126)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.black.opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.45),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .environment(\.layoutDirection, .leftToRight)
     // ترتيب المحتويات
    }

    // MARK: Tabs Row
    var tabsRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(vm.sectors) { sector in
                    let isActive = vm.selectedTabIDs.contains(sector.id)
                    Button(action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                            vm.selectTab(sector.id)
                        }
                    }) {
                        HStack(spacing: 5) {
                            Image(systemName: sector.icon)
                                .font(.system(size: 12))
                            Text(sector.name)
                                .font(.system(size: 13, weight: .semibold))
                       
                        }
                        .foregroundColor(isActive ? .white : Color(red: 0.275, green: 0.275, blue: 0.286))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 14.26)
                                .fill(isActive
                                      ? Color(red: 0.345, green: 0.494, blue: 0.859).opacity(0.2)
                                      : Color(red: 0.125, green: 0.122, blue: 0.122).opacity(0.2))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14.26)
                                        .stroke(Color.white.opacity(isActive ? 0.2 : 0.08), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: Bottom Hints
    var bottomHints: some View {
        VStack(spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Text("تفريغ المحافظ")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Spacer()
            }
            .onTapGesture { withAnimation { vm.resetWallet() } }

            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Text("وزع باقي المبلغ على القطاعات المختاره")
                    .font(.system(size: 13))
                    .foregroundColor(Color.white.opacity(0.5))
                Spacer()
            }
        }
    }

    // MARK: Confirm Button
    var confirmBtn: some View {
        let hasAny = vm.selectedTabIDs.count >= 2
        return PrimaryButton(title: "تأكيد التوزيع") {
            if hasAny { vm.confirm() }
        }    .padding(.bottom, 32)
        .disabled(!hasAny)
        .opacity(hasAny ? 1.0 : 0.4)
        .animation(.easeInOut(duration: 0.2), value: hasAny)
    }
}

// MARK: - Sector Row Card


struct SectorRowCard: View {
    @Binding var sector: PortfolioSector
    @ObservedObject var vm: PortfolioViewModel
    let isExpanded: Bool

    var percentage: Int {
        guard vm.totalBalance > 0 else { return 0 }
        return Int(Double(sector.allocation) / Double(vm.totalBalance) * 100)
    }

    var sliderMax: Double {
        Double(vm.remaining + sector.allocation)
    }

    let accentBlue = Color(red: 0.427, green: 0.565, blue: 0.898)



    var body: some View {
        VStack(spacing: 0) {

            // ── Collapsed Row ──
            if !isExpanded {
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        vm.toggleExpand(sector.id)
                    }
                }) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(sector.name)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.white)
                        Image(systemName: sector.icon)
                            .font(.system(size: 21))
                            .foregroundColor(accentBlue)
                        Spacer()
                        HStack(spacing: 6) {
                            Text("\(arabicNumber(sector.allocation)) سنام . \(arabicNumber(percentage))%")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color(red: 0.514, green: 0.514, blue: 0.514))
                        }
                      
                    }
                    .contentShape(Rectangle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 26)
                }
                .buttonStyle(.plain)
            }

            // ── Expanded Section ──
            if isExpanded {
                VStack(spacing: 0) {

                    // minus | icon + name | plus
                    HStack {
                  
                        
                        Button(action: { vm.increment(id: sector.id) }) {
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.55))
                                    .frame(width: 21, height: 21)
                                Text("+")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                        Spacer()
                        VStack(spacing: 2) {
                            Image(systemName: sector.icon)
                                .font(.system(size: 21))
                                .foregroundColor(accentBlue)
                            Text(sector.name)
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button(action: { vm.decrement(id: sector.id) }) {
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.55))
                                    .frame(width: 21, height: 21)
                                Text("−")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                    // ── Tooltip + Slider في GeometryReader واحد ──
                    GeometryReader { geo in
                        let trackWidth = geo.size.width
                        let ratio = sliderMax > 0 ? CGFloat(sector.allocation) / CGFloat(sliderMax) : 0
                        let thumbX = (1 - ratio) * trackWidth // RTL

                        ZStack(alignment: .topLeading) {

                            // Slider track + fill + thumb
                            ZStack(alignment: .leading) {
                                // Track
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color(red: 0.043, green: 0.071, blue: 0.137))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(Color(red: 0.388, green: 0.388, blue: 0.388), lineWidth: 0.5)
                                    )
                                    .frame(height: 9)

                                // Fill — من اليمين
                                HStack(spacing: 0) {
                                    Spacer(minLength: thumbX)
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(accentBlue)
                                        .frame(height: 6.8)
                                }
                                .padding(.vertical, 1.1)

                                // Thumb
                                Circle()
                                    .fill(Color(red: 0.686, green: 0.706, blue: 0.757))
                                    .overlay(Circle().stroke(Color(red: 0.741, green: 0.741, blue: 0.741), lineWidth: 1))
                                    .frame(width: 22, height: 22)
                                    .offset(x: thumbX - 11, y: -6.5)
                            }
                            .frame(height: 9)
                            .offset(y: 38) // تحت الـ tooltip

                            // Tooltip مع سهم
                            // Tooltip مع سهم
                            VStack(spacing: 0) {
                                ZStack {
                                    // الطبقة الخارجية
                                    RoundedRectangle(cornerRadius: 8.45)
                                        .fill(Color.black.opacity(0.08))
                                        .background(
                                            RoundedRectangle(cornerRadius: 8.45)
                                                .fill(
                                                    LinearGradient(
                                                        colors: [
                                                            Color(red: 0.11, green: 0.11, blue: 0.12).opacity(0.84),
                                                            Color(red: 0.11, green: 0.11, blue: 0.12).opacity(0.84)
                                                        ],
                                                        startPoint: .top,
                                                        endPoint: .bottom
                                                    )
                                                )
                                                .blur(radius: 0.5)
                                        )
                                        .shadow(color: .black.opacity(0.3), radius: 65/10, x: 0, y: 6.5)
                                        .frame(width: 73, height: 19)

                                    Text("\(arabicNumber(sector.allocation)) سنام (\(arabicNumber(percentage))%)")
                                        .font(.system(size: 10, weight: .semibold))
                                        .foregroundColor(.white)
                                }

                                // السهم
                                Triangle()
                                    .fill(Color(red: 0.11, green: 0.11, blue: 0.12).opacity(0.84))
                                    .frame(width: 36.4, height: 8.45)
                            }
                            .offset(x: max(0, min(thumbX - 36, trackWidth - 73)), y: 0)
                        }
                        .frame(width: trackWidth, height: 60)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { drag in
                                    let ratio = max(0, min(1, drag.location.x / trackWidth));                                    let raw = Double(ratio) * sliderMax
                                    let snapped = Int(round(raw / 25.0)) * 25
                                    vm.updateAllocation(id: sector.id, value: snapped)
                                }
                        )
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)

                    // أرقام تحت السلايدر
                    HStack {
                       // Text(arabicNumber(0))          // ← صار يسار
                        Text(arabicNumber(Int(sliderMax)))  // يمين

                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Spacer()
                        Text(arabicNumber(Int(sliderMax) / 2))
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Spacer()
                       // Text(arabicNumber(Int(sliderMax)))  // ← صار يمين
                        Text(arabicNumber(0))        // يمين
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .padding(.bottom, 16)
                }
                .onTapGesture {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        vm.toggleExpand(sector.id)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(red: 0.078, green: 0.114, blue: 0.224).opacity(0.2))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            isExpanded ? accentBlue.opacity(0.3) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
        .animation(.spring(response: 0.35, dampingFraction: 0.8), value: isExpanded)
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}


// MARK: - Preview

#Preview {
    PortfolioRootView()
}
