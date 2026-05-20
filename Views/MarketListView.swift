//
//  MarketListView.swift
//  Snam
//
//  Created by Jojo on 20/05/2026.




import SwiftUI
//  MarketListView.swift
//  Snam
//
//  Created by Jojo on 20/05/2026.


import SwiftUI

// MARK: - MarketListView
struct MarketListView: View {

    @StateObject private var vm = MarketViewModel()
    @State private var showSectorPicker = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {

                Color(hex: "#0E0E10")
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    // MARK: Header
                    HStack {
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                showSectorPicker.toggle()
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                        }

                        Spacer()

                        Text("المحاكي")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .environment(\.layoutDirection, .rightToLeft)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 12)

                    // MARK: شريط الفلتر النشط
                    if vm.selectedSector != "الكل" {
                        HStack {
                            Spacer()
                            HStack(spacing: 6) {
                                Text(sectorArabic(vm.selectedSector))
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(Color(hex: "#A78BFA"))

                                Button {
                                    withAnimation { vm.selectedSector = "الكل" }
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundColor(Color(hex: "#A78BFA"))
                                }
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(hex: "#A78BFA").opacity(0.12))
                            .cornerRadius(20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }

                    // MARK: القائمة
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(vm.filteredCompanies) { company in
                                // الانتقال لصفحة التفاصيل عند الضغط على الشركة
                                NavigationLink(destination: CompanyDetailView(company: company)) {
                                    CompanyRow(company: company)
                                }
                                .buttonStyle(PlainButtonStyle()) // للحفاظ على الثيم الداكن للسطر بدون تأثيرات زرقاء
                                
                                Divider()
                                    .background(Color.white.opacity(0.07))
                                    .padding(.leading, 76)
                            }
                        }
                        .padding(.top, 4)
                        .padding(.bottom, 32)
                    }
                }

                // MARK: Sector Picker Overlay
                if showSectorPicker {
                    Color.black.opacity(0.45)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3)) {
                                showSectorPicker = false
                            }
                        }
                        .transition(.opacity)

                    SectorPickerMenu(
                        sectors: vm.sectors,
                        selectedSector: $vm.selectedSector,
                        isVisible: $showSectorPicker
                    )
                    .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .topLeading)))
                    .padding(.top, 72)
                    .padding(.leading, 16)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
            }
            .animation(.spring(response: 0.3), value: showSectorPicker)
            .animation(.spring(response: 0.3), value: vm.selectedSector)
            .navigationBarHidden(true)
        }
    }
}

// MARK: - CompanyRow
struct CompanyRow: View {

    let company: Company

    var body: some View {
        HStack(spacing: 14) {

            // السعر + التغيير
            VStack(alignment: .leading, spacing: 4) {
                Text(String(format: "%.2f", company.stock.currentPrice))
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                let change = company.stock.changePercent
                Text(String(format: "%+.2f%%", change))
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(
                        change >= 0
                            ? Color(hex: "#34D399")
                            : Color(hex: "#F87171")
                    )
            }
            .frame(width: 72, alignment: .leading)

            // Mini Sparkline
            MiniSparkline(
                points: company.chartData.timeframes.oneDay.map { $0.price },
                trend: company.stock.trend
            )
            .frame(width: 80, height: 36)

            Spacer()

            // الاسم + القطاع
            VStack(alignment: .trailing, spacing: 3) {
                Text(company.fakeName)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)

                Text(sectorArabic(company.sector))
                    .font(.system(size: 12))
                    .foregroundColor(Color.white.opacity(0.45))
            }

            // اللوقو
            CompanyLogo(company: company)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .contentShape(Rectangle())
    }
}

// MARK: - CompanyLogo
struct CompanyLogo: View {

    let company: Company

    var body: some View {
        ZStack {
            Circle()
                .fill(logoBackground(for: company.sector))
                .frame(width: 46, height: 46)

            Text(company.icon)
                .font(.system(size: 22))
        }
    }

    private func logoBackground(for sector: String) -> Color {
        switch sector {
        case "Energy":       return Color(hex: "#1E3A2F")
        case "Banking":      return Color(hex: "#1A2A4A")
        case "Telecom":      return Color(hex: "#2A1A4A")
        case "Retail":       return Color(hex: "#3A2A1A")
        case "Technology":   return Color(hex: "#1A1A3A")
        case "Food":         return Color(hex: "#2A3A1A")
        case "Construction": return Color(hex: "#3A2A1A")
        case "Travel":       return Color(hex: "#1A3A3A")
        case "Healthcare":   return Color(hex: "#1A3A2A")
        case "Logistics":    return Color(hex: "#3A1A1A")
        default:             return Color.white.opacity(0.1)
        }
    }
}

// MARK: - MiniSparkline
struct MiniSparkline: View {

    let points: [Double]
    let trend: String

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let mn = points.min() ?? 0
            let mx = points.max() ?? 1
            let range = mx - mn == 0 ? 1 : mx - mn

            let color: Color = trend == "up"
                ? Color(hex: "#34D399")
                : trend == "down"
                    ? Color(hex: "#F87171")
                    : Color(hex: "#A0A0A0")

            Path { path in
                for (i, p) in points.enumerated() {
                    let x = CGFloat(i) / CGFloat(max(points.count - 1, 1)) * w
                    let y = h - CGFloat((p - mn) / range) * h
                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
                    else       { path.addLine(to: CGPoint(x: x, y: y)) }
                }
            }
            .stroke(
                color,
                style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round)
            )
        }
    }
}

// MARK: - Sector Picker Menu
struct SectorPickerMenu: View {

    let sectors: [String]
    @Binding var selectedSector: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack(alignment: .trailing, spacing: 0) {
            // تم تصحيح الخطأ هنا باستخدام ForEach الخاصة بـ SwiftUI
            ForEach(sectors, id: \.self) { sector in
                Button {
                    withAnimation(.spring(response: 0.25)) {
                        selectedSector = sector
                        isVisible = false
                    }
                } label: {
                    HStack {
                        if selectedSector == sector {
                            Image(systemName: "checkmark")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(Color(hex: "#A78BFA"))
                        } else {
                            Spacer().frame(width: 17)
                        }

                        Spacer()

                        Text(sectorArabic(sector))
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 13)
                }

                if sector != sectors.last {
                    Divider()
                        .background(Color.white.opacity(0.1))
                }
            }
        }
        .frame(width: 220)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color(hex: "#1C1C1E"))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
                )
        )
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// MARK: - Helpers

func sectorArabic(_ sector: String) -> String {
    switch sector {
    case "الكل":         return "الكل"
    case "Energy":       return "قطاع الطاقة"
    case "Banking":      return "قطاع المال"
    case "Telecom":      return "قطاع الاتصالات"
    case "Retail":       return "قطاع التجزئة"
    case "Technology":   return "قطاع التقنية"
    case "Food":         return "قطاع الغذاء"
    case "Construction": return "قطاع البناء"
    case "Travel":       return "قطاع السفر"
    case "Healthcare":   return "قطاع الصحة"
    case "Logistics":    return "قطاع اللوجستيك"
    default:             return sector
    }
}

extension Color {
    init(hex: String) {
        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: h).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

// MARK: - Preview

#Preview {
    MarketListView()
}
