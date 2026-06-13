//
//  InvestmentLevelView.swift
//  Snam
//
//  Created by Faitmh ibrahim on 19/12/1447 AH.

import SwiftUI
import Charts

struct InvestmentLevelView: View {

    @StateObject private var vm = InvestmentViewModel()
    @Environment(\.colorScheme) private var colorScheme

    // لعرض شيت المكافأة
    @State private var showReward = false
    @StateObject private var rewardVM = PortfolioViewModel()
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedTab") private var selectedTab: Int = 2
    @EnvironmentObject var walletState: WalletState

    var body: some View {
        ZStack {
            if colorScheme == .dark {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .overlay(
                        Image("Frame")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    )
            } else {
                Color(.systemBackground)
                    .overlay(Color.blue.opacity(0.06))
                    .ignoresSafeArea()
            }
            
            VStack(spacing: 0) {
                // الهيدر الموحد
                NavigationHeader(title: "متداول السوق", onBack: { dismiss() })
                    .environment(\.layoutDirection, .rightToLeft)
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 8)

                chartCard
                    .frame(width: 358, height: 320)
                
                Spacer().frame(height: 20)
                
                hintRow
                    .frame(maxWidth: .infinity, alignment: .center)
                
                Spacer().frame(height: 14)
                
                CustomGradientSlider(value: $vm.marketForce, range: -100...100)
                    .frame(width: 316)
                
                Spacer().frame(height: 6)
                
                HStack {
                    Text("بيع").foregroundStyle(.secondary)
                    Spacer()
                    Text("شراء").foregroundStyle(.secondary)
                }
                .font(.callout)
                .frame(width: 316)
                
                Spacer().frame(height: 16)
                
                buyersSellersCard
                    .frame(width: 316, height: 72)
                
                Spacer().frame(height: 32)
                
                PrimaryButton(title: "اكمل") {
                    showReward = true
                }
                .frame(width: 358)
                
                Spacer().frame(height: 12)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            
            if showReward {
                PortfolioCongratsView(vm: rewardVM, onFinished: {
                    walletState.collectReward(forLevel: 2);                    selectedTab = 2
                    dismiss()
                })
                .transition(.opacity.combined(with: .scale))
            }
        }
        .animation(.easeInOut(duration: 0.4), value: showReward)
    }
    // MARK: - Chart Card

    private var chartCard: some View {
        glassCard(cornerRadius: 24) {
            VStack(alignment: .trailing, spacing: 8) {
                companyHeader
                priceHeader
                stockChart
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
    }

    private var companyHeader: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text("بيرن اكس")
                    .font(.headline).foregroundStyle(.primary)
                Text("قطاع الأعمال")
                    .font(.caption).foregroundStyle(.secondary)
            }
            Image("bx")
                .resizable().scaledToFill()
                .frame(width: 44, height: 44)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.primary.opacity(0.15), lineWidth: 1))
        }
    }

    private var priceHeader: some View {
        HStack {
            Spacer()
            VStack(alignment: .trailing, spacing: 2) {
                Text(String(format: "%.2f", vm.displayedPrice))
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                Text(String(format: "%+.1f%%", vm.percentage))
                    .font(.subheadline)
                    .foregroundStyle(vm.isPositive ? .green : .red)
            }
        }
    }

    private var stockChart: some View {
        Chart {
            ForEach(vm.dynamicChartPoints) { item in
                AreaMark(x: .value("Day", item.day), y: .value("Value", item.value))
                    .foregroundStyle(LinearGradient(
                        colors: [vm.areaTopColor, vm.areaBottomColor],
                        startPoint: .top, endPoint: .bottom))
                    .interpolationMethod(.catmullRom)

                LineMark(x: .value("Day", item.day), y: .value("Value", item.value))
                    .foregroundStyle(vm.chartColor)
                    .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
                    .interpolationMethod(.linear)
            }

            if let sel = vm.selectedDay,
               let point = vm.dynamicChartPoints.first(where: { $0.day == sel }) {
                RuleMark(x: .value("Selected", point.day))
                    .foregroundStyle(Color.primary.opacity(0.35))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 4]))

                PointMark(x: .value("Day", point.day), y: .value("Value", point.value))
                    .symbolSize(80)
                    .foregroundStyle(.primary)
                    .annotation(position: .top, alignment: .center) {
                        Text(String(format: "%.2f", point.value))
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(.primary)
                            .padding(.horizontal, 8).padding(.vertical, 6)
                            .background(Color.secondary.opacity(0.2))
                            .clipShape(Capsule())
                    }
            }
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: 1)) { value in
                if let day = value.as(Int.self), day % 7 == 1 || day == 1 {
                    AxisValueLabel {
                        Text("\(day)").font(.system(size: 9))
                            .foregroundStyle(Color.primary.opacity(0.4))
                    }
                }
            }
        }
        .chartYAxis(.hidden)
        .chartXScale(domain: 1...vm.daysCount)
        .frame(height: 180)
        .drawingGroup()
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(Color.clear).contentShape(Rectangle())
                    .gesture(DragGesture(minimumDistance: 0)
                        .onChanged { val in
                            let x = val.location.x - geo[proxy.plotAreaFrame].origin.x
                            if let d: Double = proxy.value(atX: x) {
                                vm.onDragChanged(day: max(1, min(vm.daysCount, Int(round(d)))))
                            }
                        }
                        .onEnded { _ in vm.onDragEnded() }
                    )
            }
        }
    }

    // MARK: - Hint

    private var hintRow: some View {
        HStack(spacing: 6) {
            Image(systemName: "hand.point.up.left.fill")
                .foregroundStyle(.primary.opacity(0.85))
            Text(vm.isDragging
                 ? "اسحب على الرسم لعرض السعر حسب اليوم"
                 : "حرك المؤشر وشوف وش بيصير بالسعر")
                .font(.subheadline).foregroundStyle(.primary)
        }
    }

    // MARK: - Buyers / Sellers Card

    private var buyersSellersCard: some View {
        glassCard(cornerRadius: 16) {
            HStack {
                sideInfo(count: vm.sellers, label: "عدد البائعين", sublabel: "عرض اعلى", color: .red)
                Rectangle().fill(Color.primary.opacity(0.18)).frame(width: 1).padding(.vertical, 6)
                sideInfo(count: vm.buyers, label: "عدد المشترين", sublabel: "طلب اعلى", color: .green)
            }
        }
    }

    private func sideInfo(count: Int, label: String, sublabel: String, color: Color) -> some View {
        VStack(spacing: 2) {
            HStack(spacing: 4) {
                Image(systemName: "person.2.fill").font(.system(size: 13)).foregroundStyle(color)
                Text("\(count)").font(.system(size: 15, weight: .semibold)).foregroundStyle(.primary)
            }
            Text(label).font(.system(size: 11)).foregroundStyle(.secondary)
            Text(sublabel).font(.system(size: 10, weight: .medium)).foregroundStyle(color)
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - Glass Card Helper

    @ViewBuilder
    private func glassCard<Content: View>(cornerRadius: CGFloat, @ViewBuilder content: () -> Content) -> some View {
        content()
            .padding(16)
            .background(Color.clear)
            .overlay(
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(LinearGradient(
                            colors: [Color.primary.opacity(0.30), Color.primary.opacity(0.12)],
                            startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1.3)
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(Color.black.opacity(0.15), lineWidth: 0.7)
                        .blur(radius: 0.7).offset(x: 0.6, y: 0.8)
                        .mask(RoundedRectangle(cornerRadius: cornerRadius))
                }
            )
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

// MARK: - Custom Gradient Slider
struct CustomGradientSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>

    private let height: CGFloat    = 16
    private let thumbSize: CGFloat = 20
    private let padding: CGFloat   = 12

    var body: some View {
        GeometryReader { geo in
            let width    = geo.size.width - padding * 2
            let progress = CGFloat((value - range.lowerBound) / (range.upperBound - range.lowerBound))
            let xPos     = padding + progress * width

            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(LinearGradient(stops: [
                        .init(color: Color(red: 1.0,  green: 0.30, blue: 0.31).opacity(0.95), location: 0.0),
                        .init(color: Color(red: 1.0,  green: 0.66, blue: 0.25).opacity(0.95), location: 0.33),
                        .init(color: Color(red: 1.0,  green: 0.84, blue: 0.40).opacity(0.95), location: 0.50),
                        .init(color: Color(red: 0.32, green: 0.77, blue: 0.10).opacity(0.95), location: 1.0),
                    ], startPoint: .leading, endPoint: .trailing))
                    .frame(height: height)
                    .overlay(RoundedRectangle(cornerRadius: height / 2)
                        .stroke(Color.primary.opacity(0.22), lineWidth: 1))

                Circle()
                    .fill(Color.primary)
                    .frame(width: thumbSize, height: thumbSize)
                    .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                    .overlay(Circle().stroke(Color.primary.opacity(0.2), lineWidth: 0.5))
                    .position(x: max(padding, min(xPos, geo.size.width - padding)), y: height / 2)
                    .gesture(DragGesture(minimumDistance: 0).onChanged { gesture in
                        let localX   = max(padding, min(gesture.location.x, geo.size.width - padding))
                        let newValue = Double((localX - padding) / width) * (range.upperBound - range.lowerBound) + range.lowerBound
                        withAnimation(.interactiveSpring(response: 0.25, dampingFraction: 0.85)) {
                            value = min(range.upperBound, max(range.lowerBound, newValue))
                        }
                    })
            }
            .frame(height: height)
        }
        .frame(height: height)
    }
}

#Preview {
    InvestmentLevelView()
        .environmentObject(WalletState())
}
