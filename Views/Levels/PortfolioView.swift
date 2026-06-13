//
//  PortfolioView.swift
//  Snam
//
//  Created by Jojo on 03/06/2026.

import SwiftUI

// MARK: - Root
struct PortfolioRootView: View {
    @StateObject private var vm = PortfolioViewModel()
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedTab") private var selectedTab: Int = 2
    @EnvironmentObject var walletState: WalletState
    @State private var isLeaving = false  // ← أضيف هذا

    var body: some View {
        ZStack {
            PortfolioMainView(vm: vm)

            if vm.showCongrats {
                PortfolioCongratsView(vm: vm, onFinished: {
                    walletState.collectReward(forLevel: 3)
                    selectedTab = 2
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        vm.collectReward()  // ← بعد الـ dismiss
                    }
                })
                .transition(.opacity.combined(with: .scale))
            }
        }
        .opacity(isLeaving ? 0 : 1)  // ← أضيف هذا
        .animation(.easeInOut(duration: 0.2), value: isLeaving)
        .animation(.easeInOut(duration: 0.4), value: vm.showCongrats)
        .environment(\.layoutDirection, .rightToLeft)
        .navigationTitle("المحافظ") // ← العنوان في شريط التنقل النظامي
    }
}

// MARK: - Main View

struct PortfolioMainView: View {
    @ObservedObject var vm: PortfolioViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(.systemBackground)
                .ignoresSafeArea()
                .overlay(
                    Image("Frame")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // --- تمت إزالة الهيدر المخصص هنا ---

                    Text("وزع المبلغ التالي كحد ادنى على قطاعين مختلفين")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.primary.opacity(0.55))
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
                                .foregroundColor(Color.primary.opacity(0.45))
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
        }
    }

    // MARK: Nav Bar
    var navBar: some View {
        HStack {
            Spacer()
            Text("تحدي التنويع")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary)
            Spacer()
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
        }
        .padding(.horizontal, 20)
    }

    // MARK: Balance Card
    var balanceCard: some View {
        HStack(spacing: 0) {

            ZStack {
                Image("currency")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 78, height: 94)
                    .rotationEffect(.degrees(7.39))
                    .offset(x: -8, y: 0)

                Image("currency")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 57, height: 69)
                    .offset(x: 18, y: 8)
            }
            .frame(width: 100, height: 110)

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

            VStack(alignment: .center, spacing: 15) {
                Text("المبلغ الكلي")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundColor(Color(red: 0.514, green: 0.514, blue: 0.514))
                    .tracking(-0.4)

                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("سنام")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.514, green: 0.514, blue: 0.514))
                    Text(arabicNumber(vm.totalBalance))
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(.primary)
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
                    .foregroundColor(Color.primary.opacity(0.5))
                Text("تفريغ المحافظ")
                    .font(.system(size: 13))
                    .foregroundColor(Color.primary.opacity(0.5))
                Spacer()
            }
            .onTapGesture { withAnimation { vm.resetWallet() } }

            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 13))
                    .foregroundColor(Color.primary.opacity(0.5))
                Text("وزع باقي المبلغ على القطاعات المختاره")
                    .font(.system(size: 13))
                    .foregroundColor(Color.primary.opacity(0.5))
                Spacer()
            }
        }
    }

    // MARK: Confirm Button
    var confirmBtn: some View {
        let hasAny = vm.selectedTabIDs.count >= 2 &&
                     vm.selectedTabIDs.allSatisfy { id in
                         vm.sectors.first(where: { $0.id == id })?.allocation ?? 0 > 0
                     }
        return PrimaryButton(title: "تأكيد التوزيع") {
            if hasAny { vm.confirm() }
        }
        .padding(.bottom, 2)
        .disabled(!hasAny)
        .opacity(hasAny ? 1.0 : 0.4)
        .animation(.easeInOut(duration: 0.2), value: hasAny)
    }
}

// ... الباقي كما هو (SectorRowCard وغيره) ...
// (لم يتم التغيير في بقية الكود)

#Preview {
    PortfolioRootView()
        .environmentObject(WalletState())
}

