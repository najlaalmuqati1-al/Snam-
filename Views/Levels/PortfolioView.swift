
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
                    walletState.collectReward(forLevel: 3);                    selectedTab = 2
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
                ) // ← هنا تقفل

            ScrollView(showsIndicators: false) {
            
                VStack(spacing: 0) {
                    // هيدر موحّد مع رجوع لصفحة اللفلز
                 
                    
                    Text("وزع الدراهم اتاليه كحد ادنى على قطاعين مختلفين")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(Color.primary.opacity(0.55)) // ← primary
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
                            Text("اختر قطاع آخر توزع فيه دراهمك")
                                .font(.system(size: 13))
                                .foregroundColor(Color.primary.opacity(0.45)) // ← primary
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
            Text("مايسترو المحافظ")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.primary) // ← primary
            Spacer()
            Button(action: {}) {
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.1))
                        .frame(width: 36, height: 36)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary) // ← primary
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
                        .foregroundColor(.primary) // ← primary
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
                    .foregroundColor(Color.primary.opacity(0.5)) // ← primary
                Text("تفريغ المحافظ")
                    .font(.system(size: 13))
                    .foregroundColor(Color.primary.opacity(0.5)) // ← primary
                Spacer()
            }
            .onTapGesture { withAnimation { vm.resetWallet() } }

            HStack(spacing: 8) {
                Image(systemName: "info.circle")
                    .font(.system(size: 13))
                    .foregroundColor(Color.primary.opacity(0.5)) // ← primary
                Text("وزع باقي المبلغ على القطاعات اللي اخترته")
                    .font(.system(size: 13))
                    .foregroundColor(Color.primary.opacity(0.5)) // ← primary
                Spacer()
            }
        }
    }

    // MARK: Confirm Button
    var confirmBtn: some View {
        let hasAny = vm.selectedTabIDs.count >= 2 &&
                     vm.selectedTabIDs.allSatisfy { id in
                         vm.sectors.first(where: { $0.id == id })?.allocation ?? 0 > 0
                     } // تعديل الشرط ع الاقل اضافة سنام واحد لكل قطاع
        return PrimaryButton(title: "خلصت توزيع") {
            if hasAny { vm.confirm() }
        }
        .padding(.bottom, 2)
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

            if !isExpanded {
                Button(action: {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        vm.toggleExpand(sector.id)
                    }
                }) {
                    HStack(alignment: .center, spacing: 0) {
                        Text(sector.name)
                            .font(.system(size: 24, weight: .medium))
                            .foregroundColor(.primary) // ← primary
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

            if isExpanded {
                VStack(spacing: 0) {

                    HStack {
                        Button(action: { vm.decrement(id: sector.id) }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    .frame(width: 20, height: 20)
                                Text("+")
                                    .font(.system(size: 14, weight: .bold))
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
                                .foregroundColor(.primary) // ← primary
                        }
                        Spacer()
                        Button(action: { vm.decrement(id: sector.id) }) {
                            ZStack {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.25), lineWidth: 1)
                                    )
                                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                    .frame(width: 20, height: 20)
                                Text("−")
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)

                    GeometryReader { geo in
                        let trackWidth = geo.size.width
                        let ratio = sliderMax > 0 ? CGFloat(sector.allocation) / CGFloat(sliderMax) : 0
                        let thumbX = (1 - ratio) * trackWidth

                        ZStack(alignment: .topLeading) {

                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 22)
                                    .fill(Color(red: 0.043, green: 0.071, blue: 0.137))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(Color(red: 0.388, green: 0.388, blue: 0.388), lineWidth: 0.5)
                                    )
                                    .frame(height: 9)

                                HStack(spacing: 0) {
                                    Spacer(minLength: thumbX)
                                    RoundedRectangle(cornerRadius: 22)
                                        .fill(accentBlue)
                                        .frame(height: 6.8)
                                }
                                .padding(.vertical, 1.1)

                                Circle()
                                    .fill(Color(red: 0.686, green: 0.706, blue: 0.757))
                                    .overlay(Circle().stroke(Color(red: 0.741, green: 0.741, blue: 0.741), lineWidth: 1))
                                    .frame(width: 22, height: 22)
                                    .offset(x: thumbX - 11, y: -6.5)
                            }
                            .frame(height: 9)
                            .offset(y: 38)

                            VStack(spacing: 0) {
                                ZStack {
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
                                    let ratio = max(0, min(1, drag.location.x / trackWidth))
                                    let raw = Double(ratio) * sliderMax
                                    let snapped = Int(round(raw / 25.0)) * 25
                                    vm.updateAllocation(id: sector.id, value: snapped)
                                }
                        )
                    }
                    .frame(height: 60)
                    .padding(.horizontal, 16)
                    .padding(.top, 10)

                    HStack {
                        Text(arabicNumber(Int(sliderMax)))
                            .font(.system(size: 16))
                            .foregroundColor(.primary) // ← primary
                        Spacer()
                        Text(arabicNumber(Int(sliderMax) / 2))
                            .font(.system(size: 16))
                            .foregroundColor(.primary) // ← primary
                        Spacer()
                        Text(arabicNumber(0))
                            .font(.system(size: 16))
                            .foregroundColor(.primary) // ← primary
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
#Preview {
    PortfolioRootView()
        .environmentObject(WalletState())
}

