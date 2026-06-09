//
//  CompanyDetailView.swift
//  Snam
//
//  Created by Jojo on 20/05/2026.
//

//import SwiftUI
//
////  CompanyDetailView.swift
////  Snam
////
////  Created by Jojo on 20/05/2026.
////
//
//import SwiftUI
//
//// MARK: - CompanyDetailView
//struct CompanyDetailView: View {
//
//    let company: Company
//    @Environment(\.dismiss) private var dismiss
//    @State private var selectedTimeframe: String = "1D"
//
//    private let timeframes = ["1D", "1W", "1M", "1Y"]
//
//    private var chartPoints: [PricePoint] {
//        switch selectedTimeframe {
//        case "1D": return company.chartData.timeframes.oneDay
//        case "1W": return company.chartData.timeframes.oneWeek
//        case "1M": return company.chartData.timeframes.oneMonth
//        case "1Y": return company.chartData.timeframes.oneYear
//        default:   return company.chartData.timeframes.oneDay
//        }
//    }
//
//    private var isUp: Bool {
//        company.stock.changePercent >= 0
//    }
//
//    private var chartColor: Color {
//        isUp ? Color(hex: "#34D399") : Color(hex: "#F87171")
//    }
//
//    private var chartFillColor: Color {
//        isUp ? Color(hex: "#0D2B1F") : Color(hex: "#2B0D0D")
//    }
//
//    var body: some View {
//        ZStack {
//            Color(hex: "#0E0E10").ignoresSafeArea()
//
//            VStack(spacing: 0) {
//
//                // MARK: - Header
//                HStack {
//                    // ويدجت عرض معلومات الشركة الصغير (على اليسار)
//                    HStack(spacing: 6) {
//                        CompanyLogoSmall(company: company)
//                        Text("..")
//                            .font(.system(size: 14, weight: .medium))
//                            .foregroundColor(.white.opacity(0.6))
//                    }
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 8)
//                    .background(Color.white.opacity(0.08))
//                    .cornerRadius(20)
//
//                    Spacer()
//
//                    Text(company.fakeName)
//                        .font(.system(size: 18, weight: .bold))
//                        .foregroundColor(.white)
//
//                    Spacer()
//
//                    // زر سهم العودة (على اليمين) - تم ربطه بـ dismiss وتغيير اتجاه السهم لليمين ليتناسق مع الـ RTL العربي
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "chevron.right")
//                            .font(.system(size: 16, weight: .semibold))
//                            .foregroundColor(.white)
//                            .frame(width: 40, height: 40)
//                            .background(Color.white.opacity(0.08))
//                            .clipShape(Circle())
//                    }
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 16)
//                .padding(.bottom, 20)
//
//                ScrollView(showsIndicators: false) {
//                    VStack(spacing: 0) {
//
//                        // MARK: - Company Info + Price
//                        HStack(alignment: .top) {
//                            VStack(alignment: .trailing, spacing: 4) {
//                                Text(company.fakeName)
//                                    .font(.system(size: 17, weight: .semibold))
//                                    .foregroundColor(.white)
//                                Text(sectorArabic(company.sector))
//                                    .font(.system(size: 13))
//                                    .foregroundColor(.white.opacity(0.45))
//                            }
//                            Spacer()
//                            CompanyLogoMedium(company: company)
//                        }
//                        .padding(.horizontal, 20)
//                        .environment(\.layoutDirection, .rightToLeft)
//
//                        // السعر + النسبة
//                        HStack(alignment: .firstTextBaseline, spacing: 10) {
//                            Text(String(format: "%+.2f%%", company.stock.changePercent))
//                                .font(.system(size: 16, weight: .medium))
//                                .foregroundColor(chartColor)
//
//                            Spacer()
//
//                            Text(String(format: "%.2f", company.stock.currentPrice))
//                                .font(.system(size: 32, weight: .bold))
//                                .foregroundColor(.white)
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.top, 16)
//                        .padding(.bottom, 8)
//                        .environment(\.layoutDirection, .rightToLeft)
//
//                        // MARK: - Timeframe Selector
//                        HStack(spacing: 0) {
//                            ForEach(timeframes, id: \.self) { tf in
//                                Button {
//                                    withAnimation(.spring(response: 0.3)) {
//                                        selectedTimeframe = tf
//                                    }
//                                } label: {
//                                    Text(timeframeArabic(tf))
//                                        .font(.system(size: 13, weight: selectedTimeframe == tf ? .semibold : .regular))
//                                        .foregroundColor(selectedTimeframe == tf ? .white : .white.opacity(0.35))
//                                        .frame(maxWidth: .infinity)
//                                        .padding(.vertical, 8)
//                                        .background(
//                                            selectedTimeframe == tf
//                                                ? Color.white.opacity(0.12)
//                                                : Color.clear
//                                        )
//                                        .cornerRadius(10)
//                                }
//                            }
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 6)
//                        .environment(\.layoutDirection, .rightToLeft)
//
//                        // MARK: - Chart
//                        DetailChart(
//                            points: chartPoints.map { $0.price },
//                            color: chartColor,
//                            fillColor: chartFillColor
//                        )
//                        .frame(height: 200)
//                        .padding(.horizontal, 12)
//                        .padding(.top, 8)
//                        .padding(.bottom, 4)
//
//                        // MARK: - Statistics Grid
//                        StatisticsGrid(stats: company.stock.statistics)
//                            .padding(.horizontal, 20)
//                            .padding(.top, 16)
//
//                        Spacer().frame(height: 100)
//                    }
//                }
//
//                // MARK: - زر التداول
//                VStack(spacing: 0) {
//                    Divider()
//                        .background(Color.white.opacity(0.08))
//
//                    Button {} label: {
//                        Text("تداول")
//                            .font(.system(size: 18, weight: .semibold))
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 54)
//                            .background(Color.white.opacity(0.08))
//                            .cornerRadius(16)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 16)
//                                    .stroke(Color.white.opacity(0.12), lineWidth: 0.5)
//                            )
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.vertical, 16)
//                }
//                .background(Color(hex: "#0E0E10"))
//            }
//        }
//        .navigationBarHidden(true)
//    }
//}
//
//// MARK: - DetailChart
//struct DetailChart: View {
//
//    let points: [Double]
//    let color: Color
//    let fillColor: Color
//
//    var body: some View {
//        GeometryReader { geo in
//            let w = geo.size.width
//            let h = geo.size.height
//            let mn = (points.min() ?? 0) * 0.998
//            let mx = (points.max() ?? 1) * 1.002
//            let range = mx - mn == 0 ? 1 : mx - mn
//
//            let x: (Int) -> CGFloat = { i in
//                CGFloat(i) / CGFloat(max(points.count - 1, 1)) * w
//            }
//            let y: (Double) -> CGFloat = { p in
//                h - CGFloat((p - mn) / range) * h
//            }
//
//            ZStack {
//                // Fill
//                Path { path in
//                    guard !points.isEmpty else { return }
//                    path.move(to: CGPoint(x: x(0), y: h))
//                    for (i, p) in points.enumerated() {
//                        path.addLine(to: CGPoint(x: x(i), y: y(p)))
//                    }
//                    path.addLine(to: CGPoint(x: x(points.count - 1), y: h))
//                    path.closeSubpath()
//                }
//                .fill(fillColor)
//
//                // Line
//                Path { path in
//                    guard !points.isEmpty else { return }
//                    path.move(to: CGPoint(x: x(0), y: y(points[0])))
//                    for (i, p) in points.enumerated().dropFirst() {
//                        path.addLine(to: CGPoint(x: x(i), y: y(p)))
//                    }
//                }
//                .stroke(color, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
//
//                // Y axis labels
//                VStack {
//                    ForEach(0..<5) { i in
//                        let val = mx - (Double(i) / 4.0) * range
//                        HStack {
//                            Spacer()
//                            Text(String(format: "%.0f", val))
//                                .font(.system(size: 10))
//                                .foregroundColor(.white.opacity(0.3))
//                                .frame(width: 36)
//                        }
//                        if i < 4 { Spacer() }
//                    }
//                }
//
//                // X axis labels
//                VStack {
//                    Spacer()
//                    HStack {
//                        ForEach(0..<min(points.count, 7), id: \.self) { i in
//                            Text("\(i + 1)")
//                                .font(.system(size: 10))
//                                .foregroundColor(.white.opacity(0.3))
//                            if i < min(points.count, 7) - 1 { Spacer() }
//                        }
//                    }
//                    .padding(.horizontal, 4)
//                    .padding(.bottom, 2)
//                }
//            }
//        }
//    }
//}
//
//// MARK: - StatisticsGrid
//struct StatisticsGrid: View {
//
//    let stats: Statistics
//
//    private var items: [(String, String)] {
//        [
//            ("إفتتاح",              String(format: "%.2f", stats.openPrice)),
//            ("إغلاق سابق",          String(format: "%.2f", stats.previousClose)),
//            ("الكمية المتداولة",     formatNumber(stats.volumeTraded)),
//            ("الأعلى",              String(format: "%.2f", stats.dayHigh)),
//            ("عدد الصفقات",          formatNumber(stats.numberOfTrades)),
//            ("القيمة المتداولة",     formatLarge(stats.tradingValue)),
//            ("الأدنى",              String(format: "%.2f", stats.dayLow)),
//            ("متوسط كمية الصفقة",    formatNumber(stats.averageTradeSize)),
//        ]
//    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            ForEach(0..<(items.count / 2), id: \.self) { row in
//                HStack(spacing: 0) {
//                    StatCell(label: items[row * 2].0, value: items[row * 2].1)
//                    Divider()
//                        .frame(width: 0.5)
//                        .background(Color.white.opacity(0.08))
//                    StatCell(label: items[row * 2 + 1].0, value: items[row * 2 + 1].1)
//                }
//                .environment(\.layoutDirection, .rightToLeft)
//
//                if row < (items.count / 2) - 1 {
//                    Divider().background(Color.white.opacity(0.08))
//                }
//            }
//        }
//        .background(Color.white.opacity(0.04))
//        .cornerRadius(14)
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
//        )
//    }
//
//    private func formatNumber(_ n: Int) -> String {
//        let f = NumberFormatter()
//        f.numberStyle = .decimal
//        return f.string(from: NSNumber(value: n)) ?? "\(n)"
//    }
//
//    private func formatLarge(_ n: Double) -> String {
//        if n >= 1_000_000_000 {
//            return String(format: "%.1fB", n / 1_000_000_000)
//        } else if n >= 1_000_000 {
//            return String(format: "%.1fM", n / 1_000_000)
//        }
//        return String(format: "%.0f", n)
//    }
//}
//
//// MARK: - StatCell
//struct StatCell: View {
//    let label: String
//    let value: String
//
//    var body: some View {
//        VStack(alignment: .trailing, spacing: 4) {
//            Text(value)
//                .font(.system(size: 14, weight: .semibold))
//                .foregroundColor(.white)
//            Text(label)
//                .font(.system(size: 11))
//                .foregroundColor(.white.opacity(0.4))
//                .multilineTextAlignment(.trailing)
//        }
//        .frame(maxWidth: .infinity, alignment: .trailing)
//        .padding(.horizontal, 14)
//        .padding(.vertical, 12)
//    }
//}
//
//// MARK: - CompanyLogoSmall
//struct CompanyLogoSmall: View {
//    let company: Company
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(logoBackground(for: company.sector))
//                .frame(width: 28, height: 28)
//            Text(company.icon)
//                .font(.system(size: 14))
//        }
//    }
//}
//
//// MARK: - CompanyLogoMedium
//struct CompanyLogoMedium: View {
//    let company: Company
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(logoBackground(for: company.sector))
//                .frame(width: 52, height: 52)
//            Text(company.icon)
//                .font(.system(size: 26))
//        }
//    }
//}
//
//// MARK: - Helpers
//func timeframeArabic(_ tf: String) -> String {
//    switch tf {
//    case "1D": return "اي"
//    case "1W": return "اش"
//    case "1M": return "اش١"
//    case "1Y": return "اس"
//    default:   return tf
//    }
//}
//
//func logoBackground(for sector: String) -> Color {
//    switch sector {
//    case "Energy":       return Color(hex: "#1E3A2F")
//    case "Banking":      return Color(hex: "#1A2A4A")
//    case "Telecom":      return Color(hex: "#2A1A4A")
//    case "Retail":       return Color(hex: "#3A2A1A")
//    case "Technology":   return Color(hex: "#1A1A3A")
//    case "Food":         return Color(hex: "#2A3A1A")
//    case "Construction": return Color(hex: "#3A2A1A")
//    case "Travel":       return Color(hex: "#1A3A3A")
//    case "Healthcare":   return Color(hex: "#1A3A2A")
//    case "Logistics":    return Color(hex: "#3A1A1A")
//    default:             return Color.white.opacity(0.1)
//    }
//}
//
//// MARK: - Preview
//#Preview {
//    let url = Bundle.main.url(forResource: "MarketData", withExtension: "json")!
//    let data = try! JSONDecoder().decode(MarketData.self, from: Data(contentsOf: url))
//    return CompanyDetailView(company: data.companies[0])
//}
//// MARK: - Preview
//#Preview {
//    let url = Bundle.main.url(forResource: "MarketData", withExtension: "json")!
//    let data = try! JSONDecoder().decode(MarketData.self, from: Data(contentsOf: url))
//    return CompanyDetailView(company: data.companies[0])
//}
//import SwiftUI
//
//struct companyDetailView: View {
//    let company: Company
//    let currency: String
//    
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 20) {
//                // الهيدر الرئيسي للشركة
//                headerSection
//                
//                // تفاصيل السعر الحالية
//                priceSection
//                
//                // قسم الأخبار وتأثيرها
//                newsSection
//                
//                // جدول الإحصائيات والأرقام
//                statisticsSection
//            }
//            .padding()
//        }
//        .navigationTitle(company.fakeName)
//        .navigationBarTitleDisplayMode(.inline)
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//    
//    // الهيدر: الاسم، الرمز والوصف
//    private var headerSection: some View {
//        VStack(alignment: .leading, spacing: 10) {
//            HStack {
//                Text(company.icon)
//                    .font(.system(size: 40))
//                
//                VStack(alignment: .leading, spacing: 2) {
//                    HStack {
//                        Text(company.fakeName)
//                            .font(.title2)
//                            .bold()
//                        Text("(\(company.stock.symbol))")
//                            .font(.headline)
//                            .foregroundColor(.secondary)
//                    }
//                    Text("مستوحاة من: \(company.inspiredBy) • \(company.sector)")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//            }
//            
//            Text(company.description)
//                .font(.body)
//                .foregroundColor(.secondary)
//                .padding(.top, 5)
//            
//            Divider()
//        }
//    }
//    
//    // السعر الحالي والتغييرات ومستوى المخاطرة
//    private var priceSection: some View {
//        HStack {
//            VStack(alignment: .leading, spacing: 4) {
//                Text("السعر الحالي")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                Text("\(String(format: "%.2f", company.stock.currentPrice)) \(currency)")
//                    .font(.title)
//                    .bold()
//            }
//            
//            Spacer()
//            
//            VStack(alignment: .trailing, spacing: 4) {
//                Text("التغيير")
//                    .font(.caption)
//                    .foregroundColor(.secondary)
//                
//                HStack(spacing: 4) {
//                    Text("\(company.stock.changeAmount > 0 ? "+" : "")\(String(format: "%.2f", company.stock.changeAmount))")
//                    Text("(\(String(format: "%.2f", company.stock.changePercent))%)")
//                }
//                .font(.headline)
//                .foregroundColor(trendColor(trend: company.stock.trend))
//            }
//        }
//        .padding()
//        .background(Color(.systemBackground))
//        .cornerRadius(12)
//        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
//    }
//    
//    // قسم الأخبار وتأثيرها على السهم
//    private var newsSection: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            Text("آخر الأخبار")
//                .font(.headline)
//            
//            HStack(alignment: .top, spacing: 10) {
//                // مؤشر مرئي لمدى تأثير الخبر
//                Circle()
//                    .fill(newsImpactColor(impact: company.news.impact))
//                    .frame(width: 12, height: 12)
//                    .padding(.top, 4)
//                
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(company.news.headline)
//                        .font(.body)
//                        .bold()
//                    Text("تأثير الخبر: \(translateImpact(company.news.impact))")
//                        .font(.caption)
//                        .foregroundColor(.secondary)
//                }
//            }
//            .padding()
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(newsImpactColor(impact: company.news.impact).opacity(0.1))
//            .cornerRadius(10)
//        }
//    }
//    
//    // الإحصائيات اليومية وبيانات التداول
//    private var statisticsSection: some View {
//        VStack(alignment: .leading, spacing: 12) {
//            Text("إحصائيات التداول اليومية")
//                .font(.headline)
//                .padding(.bottom, 4)
//            
//            Group {
//                statRow(title: "الإغلاق السابق", value: "\(company.stock.statistics.previousClose) \(currency)")
//                statRow(title: "سعر الفتح", value: "\(company.stock.statistics.openPrice) \(currency)")
//                statRow(title: "الأعلى اليوم", value: "\(company.stock.statistics.dayHigh) \(currency)")
//                statRow(title: "الأدنى اليوم", value: "\(company.stock.statistics.dayLow) \(currency)")
//                statRow(title: "حجم التداول", value: "\(company.stock.statistics.volumeTraded)")
//                statRow(title: "القيمة السوقية للشركة", value: "\(company.stock.marketCap) \(currency)")
//                statRow(title: "مستوى المخاطرة", value: translateRisk(company.stock.riskLevel))
//            }
//        }
//    }
//    
//    // صف مخصص لعرض كل معلومة إحصائية بنظام Grid مبسط
//    private func statRow(title: String, value: String) -> some View {
//        VStack(spacing: 8) {
//            HStack {
//                Text(title)
//                    .foregroundColor(.secondary)
//                Spacer()
//                Text(value)
//                    .bold()
//            }
//            .font(.subheadline)
//            Divider()
//        }
//    }
//    
//    // دالة مساعدة لتحديد لون الاتجاه
//    private func trendColor(trend: String) -> Color {
//        switch trend.lowercased() {
//        case "up": return .green
//        case "down": return .red
//        default: return .gray
//        }
//    }
//    
//    // دالة مساعدة لتحديد لون تأثير الخبر
//    private func newsImpactColor(impact: String) -> Color {
//        switch impact.lowercased() {
//        case "positive": return .green
//        case "negative": return .red
//        default: return .gray
//        }
//    }
//    
//    // ترجمة التأثير للعربية
//    private func translateImpact(_ impact: String) -> String {
//        switch impact.lowercased() {
//        case "positive": return "إيجابي"
//        case "negative": return "سلبي"
//        default: return "محايد"
//        }
//    }
//    
//    // ترجمة مستوى المخاطر للعربية
//    private func translateRisk(_ risk: String) -> String {
//        switch risk.lowercased() {
//        case "high": return "عالي"
//        case "medium": return "متوسط"
//        case "low": return "منخفض"
//        default: return risk
//        }
//    }
//}
import SwiftUI

struct companyDetailView: View {

    let company: Company
    let currency: String

    var body: some View {

        ScrollView {

            VStack(spacing: 20) {

                VStack(spacing: 12) {

                    Circle()
                        .fill(Color.green.opacity(0.15))
                        .frame(width: 80,height: 80)
                        .overlay(
                            Text(company.icon)
                                .font(.system(size: 40))
                        )

                    Text(company.fakeName)
                        .font(.title2.bold())

                    Text(company.stock.symbol)
                        .foregroundColor(.secondary)

                    Text(
                        String(
                            format: "%.2f",
                            company.stock.currentPrice
                        )
                    )
                    .font(.system(size: 46,weight: .bold))

                    Text(
                        company.stock.changePercent >= 0
                        ? String(format: "+%.2f%%", company.stock.changePercent)
                        : String(format: "%.2f%%", company.stock.changePercent)
                    )
                    .foregroundColor(
                        company.stock.changePercent >= 0
                        ? .green
                        : .red
                    )
                    .font(.headline)

                }

                BigChartView(
                    prices:
                    company.chartData.timeframes.oneDay.map {
                        $0.price
                    }
                )
                .frame(height: 220)

                LazyVGrid(
                    columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ],
                    spacing: 12
                ) {

                    StatCard(
                        title: "الإغلاق السابق",
                        value:
                        "\(company.stock.statistics.previousClose)"
                    )

                    StatCard(
                        title: "الافتتاح",
                        value:
                        "\(company.stock.statistics.openPrice)"
                    )

                    StatCard(
                        title: "الأعلى",
                        value:
                        "\(company.stock.statistics.dayHigh)"
                    )

                    StatCard(
                        title: "الأدنى",
                        value:
                        "\(company.stock.statistics.dayLow)"
                    )

                    StatCard(
                        title: "حجم التداول",
                        value:
                        "\(company.stock.statistics.volumeTraded)"
                    )

                    StatCard(
                        title: "المخاطرة",
                        value:
                        company.stock.riskLevel
                    )
                }

                Button {

                } label: {

                    Text("تداول")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 55)
                        .background(Color.black)
                        .cornerRadius(18)
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct StatCard: View {

    let title: String
    let value: String

    var body: some View {

        VStack(spacing: 8) {

            Text(value)
                .font(.headline)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct BigChartView: View {

    let prices: [Double]

    var body: some View {

        GeometryReader { geo in

            let width = geo.size.width
            let height = geo.size.height

            let minPrice = prices.min() ?? 0
            let maxPrice = prices.max() ?? 1

            let range = maxPrice - minPrice

            Path { path in

                for (index,value)
                in prices.enumerated() {

                    let x =
                    width *
                    CGFloat(index)
                    /
                    CGFloat(max(prices.count - 1,1))

                    let y =
                    height -
                    (
                        CGFloat(value - minPrice)
                        /
                        CGFloat(range == 0 ? 1 : range)
                    ) * height

                    if index == 0 {
                        path.move(
                            to: CGPoint(x: x,y: y)
                        )
                    } else {
                        path.addLine(
                            to: CGPoint(x: x,y: y)
                        )
                    }
                }
            }
            .stroke(
                Color.green,
                style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round
                )
            )
        }
    }
}
