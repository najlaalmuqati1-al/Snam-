//
//  MarketListView.swift
//  Snam
//
//  Created by Jojo on 20/05/2026.




//import SwiftUI
////  MarketListView.swift
////  Snam
////
////  Created by Jojo on 20/05/2026.
//
//
//import SwiftUI
//
//// MARK: - MarketListView
//struct MarketListView: View {
//
//    @StateObject private var vm = MarketViewModel()
//    @State private var showSectorPicker = false
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .top) {
//
//                Color(hex: "#0E0E10")
//                    .ignoresSafeArea()
//
//                VStack(spacing: 0) {
//
//                    // MARK: Header
//                    HStack {
//                        Button {
//                            withAnimation(.spring(response: 0.3)) {
//                                showSectorPicker.toggle()
//                            }
//                        } label: {
//                            Image(systemName: "line.3.horizontal")
//                                .font(.system(size: 18, weight: .medium))
//                                .foregroundColor(.white)
//                                .frame(width: 44, height: 44)
//                                .background(Color.white.opacity(0.08))
//                                .clipShape(Circle())
//                        }
//
//                        Spacer()
//
//                        Text("المحاكي")
//                            .font(.system(size: 28, weight: .bold))
//                            .foregroundColor(.white)
//                            .environment(\.layoutDirection, .rightToLeft)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 16)
//                    .padding(.bottom, 12)
//
//                    // MARK: شريط الفلتر النشط
//                    if vm.selectedSector != "الكل" {
//                        HStack {
//                            Spacer()
//                            HStack(spacing: 6) {
//                                Text(sectorArabic(vm.selectedSector))
//                                    .font(.system(size: 13, weight: .medium))
//                                    .foregroundColor(Color(hex: "#A78BFA"))
//
//                                Button {
//                                    withAnimation { vm.selectedSector = "الكل" }
//                                } label: {
//                                    Image(systemName: "xmark")
//                                        .font(.system(size: 11, weight: .bold))
//                                        .foregroundColor(Color(hex: "#A78BFA"))
//                                }
//                            }
//                            .padding(.horizontal, 12)
//                            .padding(.vertical, 6)
//                            .background(Color(hex: "#A78BFA").opacity(0.12))
//                            .cornerRadius(20)
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.bottom, 8)
//                        .transition(.opacity.combined(with: .move(edge: .top)))
//                    }
//
//                    // MARK: القائمة
//                    ScrollView {
//                        LazyVStack(spacing: 0) {
//                            ForEach(vm.filteredCompanies) { company in
//                                // الانتقال لصفحة التفاصيل عند الضغط على الشركة
//                                NavigationLink(destination: CompanyDetailView(company: company)) {
//                                    CompanyRow(company: company)
//                                }
//                                .buttonStyle(PlainButtonStyle()) // للحفاظ على الثيم الداكن للسطر بدون تأثيرات زرقاء
//                                
//                                Divider()
//                                    .background(Color.white.opacity(0.07))
//                                    .padding(.leading, 76)
//                            }
//                        }
//                        .padding(.top, 4)
//                        .padding(.bottom, 32)
//                    }
//                }
//
//                // MARK: Sector Picker Overlay
//                if showSectorPicker {
//                    Color.black.opacity(0.45)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation(.spring(response: 0.3)) {
//                                showSectorPicker = false
//                            }
//                        }
//                        .transition(.opacity)
//
//                    SectorPickerMenu(
//                        sectors: vm.sectors,
//                        selectedSector: $vm.selectedSector,
//                        isVisible: $showSectorPicker
//                    )
//                    .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .topLeading)))
//                    .padding(.top, 72)
//                    .padding(.leading, 16)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                }
//            }
//            .animation(.spring(response: 0.3), value: showSectorPicker)
//            .animation(.spring(response: 0.3), value: vm.selectedSector)
//            .navigationBarHidden(true)
//        }
//    }
//}
//
//// MARK: - CompanyRow
//struct CompanyRow: View {
//
//    let company: Company
//
//    var body: some View {
//        HStack(spacing: 14) {
//
//            // السعر + التغيير
//            VStack(alignment: .leading, spacing: 4) {
//                Text(String(format: "%.2f", company.stock.currentPrice))
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.white)
//
//                let change = company.stock.changePercent
//                Text(String(format: "%+.2f%%", change))
//                    .font(.system(size: 13, weight: .medium))
//                    .foregroundColor(
//                        change >= 0
//                            ? Color(hex: "#34D399")
//                            : Color(hex: "#F87171")
//                    )
//            }
//            .frame(width: 72, alignment: .leading)
//
//            // Mini Sparkline
//            MiniSparkline(
//                points: company.chartData.timeframes.oneDay.map { $0.price },
//                trend: company.stock.trend
//            )
//            .frame(width: 80, height: 36)
//
//            Spacer()
//
//            // الاسم + القطاع
//            VStack(alignment: .trailing, spacing: 3) {
//                Text(company.fakeName)
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.white)
//
//                Text(sectorArabic(company.sector))
//                    .font(.system(size: 12))
//                    .foregroundColor(Color.white.opacity(0.45))
//            }
//
//            // اللوقو
//            CompanyLogo(company: company)
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 14)
//        .contentShape(Rectangle())
//    }
//}
//
//// MARK: - CompanyLogo
//struct CompanyLogo: View {
//
//    let company: Company
//
//    var body: some View {
//        ZStack {
//            Circle()
//                .fill(logoBackground(for: company.sector))
//                .frame(width: 46, height: 46)
//
//            Text(company.icon)
//                .font(.system(size: 22))
//        }
//    }
//
//    private func logoBackground(for sector: String) -> Color {
//        switch sector {
//        case "Energy":       return Color(hex: "#1E3A2F")
//        case "Banking":      return Color(hex: "#1A2A4A")
//        case "Telecom":      return Color(hex: "#2A1A4A")
//        case "Retail":       return Color(hex: "#3A2A1A")
//        case "Technology":   return Color(hex: "#1A1A3A")
//        case "Food":         return Color(hex: "#2A3A1A")
//        case "Construction": return Color(hex: "#3A2A1A")
//        case "Travel":       return Color(hex: "#1A3A3A")
//        case "Healthcare":   return Color(hex: "#1A3A2A")
//        case "Logistics":    return Color(hex: "#3A1A1A")
//        default:             return Color.white.opacity(0.1)
//        }
//    }
//}
//
//// MARK: - MiniSparkline
//struct MiniSparkline: View {
//
//    let points: [Double]
//    let trend: String
//
//    var body: some View {
//        GeometryReader { geo in
//            let w = geo.size.width
//            let h = geo.size.height
//            let mn = points.min() ?? 0
//            let mx = points.max() ?? 1
//            let range = mx - mn == 0 ? 1 : mx - mn
//
//            let color: Color = trend == "up"
//                ? Color(hex: "#34D399")
//                : trend == "down"
//                    ? Color(hex: "#F87171")
//                    : Color(hex: "#A0A0A0")
//
//            Path { path in
//                for (i, p) in points.enumerated() {
//                    let x = CGFloat(i) / CGFloat(max(points.count - 1, 1)) * w
//                    let y = h - CGFloat((p - mn) / range) * h
//                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
//                    else       { path.addLine(to: CGPoint(x: x, y: y)) }
//                }
//            }
//            .stroke(
//                color,
//                style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round)
//            )
//        }
//    }
//}
//
//// MARK: - Sector Picker Menu
//struct SectorPickerMenu: View {
//
//    let sectors: [String]
//    @Binding var selectedSector: String
//    @Binding var isVisible: Bool
//
//    var body: some View {
//        VStack(alignment: .trailing, spacing: 0) {
//            // تم تصحيح الخطأ هنا باستخدام ForEach الخاصة بـ SwiftUI
//            ForEach(sectors, id: \.self) { sector in
//                Button {
//                    withAnimation(.spring(response: 0.25)) {
//                        selectedSector = sector
//                        isVisible = false
//                    }
//                } label: {
//                    HStack {
//                        if selectedSector == sector {
//                            Image(systemName: "checkmark")
//                                .font(.system(size: 13, weight: .semibold))
//                                .foregroundColor(Color(hex: "#A78BFA"))
//                        } else {
//                            Spacer().frame(width: 17)
//                        }
//
//                        Spacer()
//
//                        Text(sectorArabic(sector))
//                            .font(.system(size: 16))
//                            .foregroundColor(.white)
//                    }
//                    .padding(.horizontal, 18)
//                    .padding(.vertical, 13)
//                }
//
//                if sector != sectors.last {
//                    Divider()
//                        .background(Color.white.opacity(0.1))
//                }
//            }
//        }
//        .frame(width: 220)
//        .background(
//            RoundedRectangle(cornerRadius: 14)
//                .fill(Color(hex: "#1C1C1E"))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 14)
//                        .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
//                )
//        )
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// MARK: - Helpers
//
//func sectorArabic(_ sector: String) -> String {
//    switch sector {
//    case "الكل":         return "الكل"
//    case "Energy":       return "قطاع الطاقة"
//    case "Banking":      return "قطاع المال"
//    case "Telecom":      return "قطاع الاتصالات"
//    case "Retail":       return "قطاع التجزئة"
//    case "Technology":   return "قطاع التقنية"
//    case "Food":         return "قطاع الغذاء"
//    case "Construction": return "قطاع البناء"
//    case "Travel":       return "قطاع السفر"
//    case "Healthcare":   return "قطاع الصحة"
//    case "Logistics":    return "قطاع اللوجستيك"
//    default:             return sector
//    }
//}
//
//extension Color {
//    init(hex: String) {
//        let h = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: h).scanHexInt64(&int)
//        let r = Double((int >> 16) & 0xFF) / 255
//        let g = Double((int >> 8)  & 0xFF) / 255
//        let b = Double(int         & 0xFF) / 255
//        self.init(red: r, green: g, blue: b)
//    }
//}
//import SwiftUI
//
//// MARK: - 1. الـ ViewModel لإدارة وقراءة بيانات الـ JSON والعمليات
//class MarketViewModel: ObservableObject {
//    @Published var marketData: MarketData?
//    @Published var selectedSector: String = "الكل"
//    @Published var userBalance: Double = 50000.0 // رصيد افتراضي للتداول التجريبي
//    @Published var ownedShares: [Int: Int] = [:] // تتبع الأسهم المملوكة [ID الشركة: الكمية]
//    
//    // استخراج القطاعات المتوفرة ديناميكياً من البيانات
//    var sectors: [String] {
//        var list = ["الكل"]
//        if let companies = marketData?.companies {
//            let uniqueSectors = Set(companies.map { $0.sector })
//            list.append(contentsOf: uniqueSectors.sorted())
//        }
//        return list
//    }
//    
//    // تصفية الشركات حسب القطاع المختار
//    var filteredCompanies: [Company] {
//        guard let companies = marketData?.companies else { return [] }
//        if selectedSector == "الكل" {
//            return companies
//        } else {
//            return companies.filter { $0.sector == selectedSector }
//        }
//    }
//    
//    init() {
//        loadLocalJSON()
//    }
//    
//    // قراءة ملف الـ JSON المسمى MarketData.json في المشروع
//    private func loadLocalJSON() {
//        if let url = Bundle.main.url(forResource: "MarketData", withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                self.marketData = try decoder.decode(MarketData.self, from: data)
//            } catch {
//                print("Error parsing MarketData.json: \(error)")
//                setupFallbackMockData()
//            }
//        } else {
//            setupFallbackMockData()
//        }
//    }
//    
//    // بيانات احتياطية مطابقة للمودل الخاص بك تماماً في حال لم يتم العثور على الملف فوراً
//    private func setupFallbackMockData() {
//        let dummyStats = Statistics(previousClose: 121.45, openPrice: 121.00, dayHigh: 126.00, dayLow: 119.00, volumeTraded: 2300000, tradingValue: 285200000, numberOfTrades: 23302, averageTradeSize: 12240, averagePrice: 123.10, bestBid: 123.90, bestAsk: 124.10)
//        let dummyStock = Stock(symbol: "NJD", currentPrice: 124.00, trend: "up", changePercent: 2.1, changeAmount: 2.55, riskLevel: "Medium", marketCap: "1.2T", statistics: dummyStats)
//        let dummyNews = News(headline: "توسع استراتيجي جديد لشركة نجد للطاقة", impact: "Positive")
//        let dummyChart = ChartData(timeframes: Timeframes(oneDay: [PricePoint(timestamp: "10:00", price: 120), PricePoint(timestamp: "14:00", price: 124)], oneWeek: [], oneMonth: [], oneYear: []))
//        
//        let fallbackCompanies = [
//            Company(id: 1, fakeName: "Najd Energy", imageName: "najd_logo", inspiredBy: "Aramco", sector: "Energy", description: "شركة طاقة افتراضية", icon: "🛢️", stock: dummyStock, news: dummyNews, chartData: dummyChart, candlestickData: [])
//        ]
//        self.marketData = MarketData(marketName: "Saudi Simulated Market", marketStatus: "Open", currency: "SAR", lastUpdated: "2026-05-12T14:30:00Z", companies: fallbackCompanies)
//    }
//    
//    // منطق الشراء
//    func buyStock(company: Company, count: Int) -> Bool {
//        let cost = company.stock.currentPrice * Double(count)
//        if userBalance >= cost {
//            userBalance -= cost
//            ownedShares[company.id, default: 0] += count
//            return true
//        }
//        return false
//    }
//    
//    // منطق البيع
//    func sellStock(company: Company, count: Int) -> Bool {
//        let currentOwned = ownedShares[company.id, default: 0]
//        if currentOwned >= count {
//            let revenue = company.stock.currentPrice * Double(count)
//            userBalance += revenue
//            ownedShares[company.id] = currentOwned - count
//            return true
//        }
//        return false
//    }
//}
//
//// MARK: - 2. واجهة التطبيق الرئيسية (MarketListView)
//struct MarketListView: View {
//    @StateObject private var vm = MarketViewModel()
//    @State private var showSectorPicker = false
//    @State private var selectedTab = "المحاكي"
//    @State private var showDisclaimer = false
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .bottom) {
//                Color(hex: "#0E0E10")
//                    .ignoresSafeArea()
//
//                VStack(spacing: 0) {
//                    if selectedTab == "المحاكي" {
//                        simulatorMainContent
//                    } else if selectedTab == "المحفظة" {
//                        walletContent
//                    } else {
//                        Spacer()
//                        Text("صفحة الرحلات")
//                            .foregroundColor(.white.opacity(0.4))
//                        Spacer()
//                    }
//                    
//                    Spacer()
//                    customTabBar
//                }
//                
//                // قائمة القطاعات المنبثقة
//                if showSectorPicker {
//                    Color.black.opacity(0.45)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation(.spring(response: 0.3)) { showSectorPicker = false }
//                        }
//                    
//                    SectorPickerMenu(
//                        sectors: vm.sectors,
//                        selectedSector: $vm.selectedSector,
//                        isVisible: $showSectorPicker
//                    )
//                    .padding(.top, 72)
//                    .padding(.leading, 16)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                }
//            }
//            .sheet(isPresented: $showDisclaimer) {
//                DisclaimerView()
//            }
//            .navigationBarHidden(true)
//        }
//    }
//    
//    private var simulatorMainContent: some View {
//        VStack(spacing: 0) {
//            HStack {
//                Button {
//                    withAnimation(.spring(response: 0.3)) { showSectorPicker.toggle() }
//                } label: {
//                    Image(systemName: "line.3.horizontal")
//                        .font(.system(size: 18, weight: .medium))
//                        .foregroundColor(.white)
//                        .frame(width: 44, height: 44)
//                        .background(Color.white.opacity(0.08))
//                        .clipShape(Circle())
//                }
//
//                Spacer()
//
//                Text("المحاكي")
//                    .font(.system(size: 28, weight: .bold))
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 16)
//            .padding(.bottom, 12)
//            .environment(\.layoutDirection, .rightToLeft)
//
//            if vm.selectedSector != "الكل" {
//                HStack {
//                    Spacer()
//                    HStack(spacing: 6) {
//                        Text(sectorArabic(vm.selectedSector))
//                            .font(.system(size: 13, weight: .medium))
//                            .foregroundColor(Color(hex: "#A78BFA"))
//
//                        Button {
//                            withAnimation { vm.selectedSector = "الكل" }
//                        } label: {
//                            Image(systemName: "xmark")
//                                .font(.system(size: 11, weight: .bold))
//                                .foregroundColor(Color(hex: "#A78BFA"))
//                        }
//                    }
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 6)
//                    .background(Color(hex: "#A78BFA").opacity(0.12))
//                    .cornerRadius(20)
//                }
//                .padding(.horizontal, 20)
//                .padding(.bottom, 8)
//            }
//
//            ScrollView {
//                LazyVStack(spacing: 0) {
//                    ForEach(vm.filteredCompanies) { company in
//                        NavigationLink(destination: CompanyDetailView(company: company, vm: vm)) {
//                            CompanyRow(company: company, currency: vm.marketData?.currency ?? "SAR")
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.07))
//                            .padding(.leading, 76)
//                    }
//                }
//                .padding(.bottom, 100)
//            }
//        }
//    }
//    
//    private var walletContent: some View {
//        VStack(spacing: 24) {
//            HStack {
//                Button { showDisclaimer = true } label: {
//                    Image(systemName: "info.circle")
//                        .font(.title2)
//                        .foregroundColor(.white.opacity(0.7))
//                }
//                Spacer()
//                Text("المحفظة")
//                    .font(.system(size: 24, weight: .bold))
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 16)
//            
//            VStack(spacing: 12) {
//                Text("رصيدك الحالي بالمحاكي")
//                    .font(.subheadline)
//                    .foregroundColor(.white.opacity(0.6))
//                
//                Text(String(format: "%.2f %@", vm.userBalance, vm.marketData?.currency ?? "SAR"))
//                    .font(.system(size: 32, weight: .bold))
//                    .foregroundColor(Color(hex: "#34D399"))
//            }
//            .frame(maxWidth: .infinity)
//            .padding(24)
//            .background(Color(hex: "#1C1C1E"))
//            .cornerRadius(16)
//            .padding(.horizontal, 20)
//            
//            Spacer()
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//    
//    private var customTabBar: some View {
//        HStack {
//            Spacer()
//            Button { selectedTab = "المحفظة" } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "briefcase.fill")
//                    Text("المحفظة").font(.system(size: 11))
//                }
//                .foregroundColor(selectedTab == "المحفظة" ? Color(hex: "#A78BFA") : .gray)
//            }
//            Spacer()
//            Button { selectedTab = "رحلتك" } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "flag.checkered")
//                    Text("رحلتك").font(.system(size: 11))
//                }
//                .foregroundColor(selectedTab == "رحلتك" ? Color(hex: "#A78BFA") : .gray)
//            }
//            Spacer()
//            Button { selectedTab = "المحاكي" } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "chart.line.uptrend.xyaxis")
//                    Text("المحاكي").font(.system(size: 11))
//                }
//                .foregroundColor(selectedTab == "المحاكي" ? Color(hex: "#A78BFA") : .white)
//                .padding(.horizontal, 16)
//                .padding(.vertical, 8)
//                .background(selectedTab == "المحاكي" ? Color.white.opacity(0.12) : Color.clear)
//                .cornerRadius(20)
//            }
//            Spacer()
//        }
//        .frame(height: 70)
//        .background(Color(hex: "#111115").opacity(0.9))
//        .cornerRadius(30)
//        .padding(.horizontal, 20)
//        .padding(.bottom, 20)
//    }
//}
//
//// MARK: - 3. سطر عرض الشركة في القائمة الرئيسية
//struct CompanyRow: View {
//    let company: Company
//    let currency: String
//
//    var body: some View {
//        HStack(spacing: 14) {
//            VStack(alignment: .leading, spacing: 4) {
//                Text(String(format: "%.2f", company.stock.currentPrice))
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.white)
//
//                Text(String(format: "%+.2f%%", company.stock.changePercent))
//                    .font(.system(size: 13, weight: .medium))
//                    .foregroundColor(company.stock.trend.lowercased() == "up" ? Color(hex: "#34D399") : Color(hex: "#F87171"))
//            }
//            .frame(width: 72, alignment: .leading)
//
//            MiniSparkline(points: company.chartData.timeframes.oneDay.map { $0.price }, trend: company.stock.trend)
//                .frame(width: 80, height: 36)
//
//            Spacer()
//
//            VStack(alignment: .trailing, spacing: 3) {
//                Text(company.fakeName)
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.white)
//
//                Text(sectorArabic(company.sector))
//                    .font(.system(size: 12))
//                    .foregroundColor(Color.white.opacity(0.45))
//            }
//
//            ZStack {
//                Circle()
//                    .fill(Color.white.opacity(0.06))
//                    .frame(width: 46, height: 46)
//                Text(company.icon)
//                    .font(.system(size: 22))
//            }
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 14)
//        .contentShape(Rectangle())
//    }
//}
//
//// MARK: - 4. الرسم البياني المصغر للأسهم
//struct MiniSparkline: View {
//    let points: [Double]
//    let trend: String
//
//    var body: some View {
//        GeometryReader { geo in
//            let w = geo.size.width
//            let h = geo.size.height
//            let mn = points.min() ?? 0
//            let mx = points.max() ?? 1
//            let range = mx - mn == 0 ? 1 : mx - mn
//            let color = trend.lowercased() == "up" ? Color(hex: "#34D399") : Color(hex: "#F87171")
//
//            Path { path in
//                for (i, p) in points.enumerated() {
//                    let x = CGFloat(i) / CGFloat(max(points.count - 1, 1)) * w
//                    let y = h - CGFloat((p - mn) / range) * h
//                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
//                    else       { path.addLine(to: CGPoint(x: x, y: y)) }
//                }
//            }
//            .stroke(color, style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
//        }
//    }
//}
//
//// MARK: - 5. قائمة الفلترة المنبثقة للقطاعات
//struct SectorPickerMenu: View {
//    let sectors: [String]
//    @Binding var selectedSector: String
//    @Binding var isVisible: Bool
//
//    var body: some View {
//        VStack(alignment: .trailing, spacing: 0) {
//            ForEach(sectors, id: \.self) { sector in
//                Button {
//                    withAnimation(.spring(response: 0.25)) {
//                        selectedSector = sector
//                        isVisible = false
//                    }
//                } label: {
//                    HStack {
//                        if selectedSector == sector {
//                            Image(systemName: "checkmark")
//                                .font(.system(size: 13, weight: .semibold))
//                                .foregroundColor(Color(hex: "#A78BFA"))
//                        } else {
//                            Spacer().frame(width: 17)
//                        }
//                        Spacer()
//                        Text(sectorArabic(sector)).font(.system(size: 16)).foregroundColor(.white)
//                    }
//                    .padding(.horizontal, 18)
//                    .padding(.vertical, 13)
//                }
//
//                if sector != sectors.last {
//                    Divider().background(Color.white.opacity(0.1))
//                }
//            }
//        }
//        .frame(width: 220)
//        .background(
//            RoundedRectangle(cornerRadius: 14)
//                .fill(Color(hex: "#1C1C1E"))
//                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
//        )
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// MARK: - 6. شاشة تفاصيل التداول والشراء والبيع للشركة
//struct CompanyDetailView: View {
//    let company: Company
//    @ObservedObject var vm: MarketViewModel
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var tradeType = "شراء"
//    @State private var quantity = 1
//    @State private var showStatsSheet = false
//    
//    // تنبيهات صح وخطأ المنبثقة التفاعلية للعملية
//    @State private var showSuccessToast = false
//    @State private var toastMessage = ""
//    @State private var showErrorPopup = false
//    @State private var errorMessage = ""
//    
//    var body: some View {
//        ZStack {
//            Color(hex: "#0E0E10").ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                HStack {
//                    Button { dismiss() } label: {
//                        Image(systemName: "chevron.left").font(.title3).foregroundColor(.white)
//                    }
//                    Spacer()
//                    Text(company.fakeName).font(.title3).bold().foregroundColor(.white)
//                    Spacer()
//                    Button { showStatsSheet = true } label: {
//                        Image(systemName: "info.circle").font(.title3).foregroundColor(.white)
//                    }
//                }
//                .padding()
//                
//                VStack(spacing: 6) {
//                    Text(String(format: "%.2f", company.stock.currentPrice))
//                        .font(.system(size: 44, weight: .bold))
//                        .foregroundColor(.white)
//                    Text("السعر الحالي (\(company.stock.symbol))")
//                        .font(.caption).foregroundColor(.gray)
//                }
//                .padding(.vertical, 20)
//                
//                HStack {
//                    Spacer()
//                    Text("الكمية المملوكة في محفظتك: \(vm.ownedShares[company.id, default: 0]) سهم")
//                        .font(.system(size: 14))
//                        .foregroundColor(.white.opacity(0.6))
//                }
//                .padding(.horizontal, 24)
//                .padding(.bottom, 16)
//                
//                VStack(spacing: 20) {
//                    Picker("نوع العملية", selection: $tradeType) {
//                        Text("شراء").tag("شراء")
//                        Text("بيع").tag("بيع")
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    
//                    HStack {
//                        Spacer()
//                        HStack(spacing: 16) {
//                            Button { if quantity > 1 { quantity -= 1 } } label: {
//                                Image(systemName: "minus.circle.fill").font(.title2).foregroundColor(.gray)
//                            }
//                            Text("\(quantity)").font(.title3).bold().foregroundColor(.white)
//                            Button { quantity += 1 } label: {
//                                Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(.gray)
//                            }
//                        }
//                        Spacer()
//                        Text("الكمية المراد تداولها:").foregroundColor(.white).font(.subheadline)
//                    }
//                    
//                    let totalPrice = company.stock.currentPrice * Double(quantity)
//                    HStack {
//                        Text(String(format: "%.2f %@", totalPrice, vm.marketData?.currency ?? "SAR"))
//                            .foregroundColor(Color(hex: "#34D399")).bold()
//                        Spacer()
//                        Text("إجمالي التكلفة المتوقعة:").foregroundColor(.gray).font(.caption)
//                    }
//                    
//                    Button {
//                        processSimulatorTrade()
//                    } label: {
//                        Text(tradeType == "شراء" ? "تأكيد عملية الشراء" : "تأكيد عملية البيع")
//                            .font(.headline).bold()
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 48)
//                            .background(tradeType == "شراء" ? Color(hex: "#1E3A8A") : Color(hex: "#991B1B"))
//                            .cornerRadius(12)
//                    }
//                }
//                .padding(20)
//                .background(Color(hex: "#1C1C1E"))
//                .cornerRadius(16)
//                .padding(.horizontal)
//                
//                Spacer()
//            }
//            
//            // تنبيه نجاح العملية
//            if showSuccessToast {
//                VStack {
//                    HStack {
//                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
//                        Text(toastMessage).foregroundColor(.white).font(.system(size: 14, weight: .medium))
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color(hex: "#1C1C1E"))
//                    .cornerRadius(10)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.4), lineWidth: 1))
//                    .padding()
//                    Spacer()
//                }
//                .transition(.move(edge: .top).combined(with: .opacity))
//            }
//            
//            // تنبيه خطأ العملية المنبثق
//            if showErrorPopup {
//                Color.black.opacity(0.55).ignoresSafeArea()
//                VStack(spacing: 16) {
//                    Text("عملية خاطئة").font(.headline).bold().foregroundColor(.white)
//                    Text(errorMessage).font(.subheadline).foregroundColor(.white.opacity(0.7)).multilineTextAlignment(.center).padding(.horizontal)
//                    
//                    Button { showErrorPopup = false } label: {
//                        Text("حسناً")
//                            .foregroundColor(.white).font(.subheadline).bold()
//                            .frame(maxWidth: .infinity).frame(height: 40)
//                            .background(Color(hex: "#1E3A8A")).cornerRadius(8)
//                    }
//                    .padding(.horizontal)
//                }
//                .padding(.vertical, 20)
//                .frame(width: 290)
//                .background(Color(hex: "#1C1C1E"))
//                .cornerRadius(14)
//            }
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//        .sheet(isPresented: $showStatsSheet) {
//            StatisticsSheetView(company: company, currency: vm.marketData?.currency ?? "SAR")
//        }
//    }
//    
//    private func processSimulatorTrade() {
//        if tradeType == "شراء" {
//            if vm.buyStock(company: company, count: quantity) {
//                toastMessage = "تم شراء السهم بنجاح واحتسابه بمحفظتك"
//                triggerSuccessAnimation()
//            } else {
//                errorMessage = "ليس لديك العملات الافتراضية الكافية لإتمام الشراء، يرجى مراجعة رصيد محفظتك"
//                withAnimation { showErrorPopup = true }
//            }
//        } else {
//            if vm.sellStock(company: company, count: quantity) {
//                toastMessage = "تم بيع السهم بنجاح وتحديث الرصيد الافتراضي"
//                triggerSuccessAnimation()
//            } else {
//                errorMessage = "خطأ في البيع، الكمية المدخلة تتجاوز عدد الأسهم المتاحة لديك حالياً"
//                withAnimation { showErrorPopup = true }
//            }
//        }
//    }
//    
//    private func triggerSuccessAnimation() {
//        withAnimation { showSuccessToast = true }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            withAnimation { showSuccessToast = false }
//        }
//    }
//}
//
//// MARK: - 7. شاشة عرض تفاصيل الإحصائيات والأرقام المأخوذة من الـ JSON
//struct StatisticsSheetView: View {
//    let company: Company
//    let currency: String
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        ZStack {
//            Color(hex: "#1C1C1E").ignoresSafeArea()
//            VStack(alignment: .trailing, spacing: 16) {
//                HStack {
//                    Spacer()
//                    Text("إحصائيات وقراءات السهم").font(.title3).bold().foregroundColor(.white)
//                }
//                
//                ScrollView {
//                    VStack(spacing: 12) {
//                        StatDetailRow(title: "الإغلاق السابق:", value: String(format: "%.2f %@", company.stock.statistics.previousClose, currency))
//                        StatDetailRow(title: "سعر الافتتاح:", value: String(format: "%.2f %@", company.stock.statistics.openPrice, currency))
//                        StatDetailRow(title: "أعلى سعر اليوم:", value: String(format: "%.2f %@", company.stock.statistics.dayHigh, currency))
//                        StatDetailRow(title: "أقل سعر اليوم:", value: String(format: "%.2f %@", company.stock.statistics.dayLow, currency))
//                        StatDetailRow(title: "عدد الصفقات المنفذة:", value: "\(company.stock.statistics.numberOfTrades)")
//                        StatDetailRow(title: "القيمة السوقية الكلية:", value: company.stock.marketCap)
//                    }
//                    .padding(.top, 10)
//                }
//            }
//            .padding(24)
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//struct StatDetailRow: View {
//    let title: String
//    let value: String
//    var body: some View {
//        VStack {
//            HStack {
//                Text(title).foregroundColor(.gray).font(.subheadline)
//                Spacer()
//                Text(value).foregroundColor(.white).bold().font(.subheadline)
//            }
//            Divider().background(Color.white.opacity(0.08))
//        }
//    }
//}
//
//// MARK: - 8. شاشة شروط وإخلاء المسؤولية للمحاكي
//struct DisclaimerView: View {
//    @Environment(\.dismiss) var dismiss
//    var body: some View {
//        ZStack {
//            Color(hex: "#0E0E10").ignoresSafeArea()
//            VStack(spacing: 24) {
//                Text("شروط وإخلاء مسؤولية المحاكي")
//                    .font(.title3).bold()
//                    .foregroundColor(.white)
//                
//                Text("إن جميع الأسعار والصفقات والعمليات المالية التي تتم داخل هذا القسم هي محاكاة افتراضية تعليمية بحتة ولا ترتبط بأسواق الأسهم الحقيقية المالية بأي شكل من الأشكال، وتهدف فقط إلى توفير بيئة محاكاة تدريبية لرحلتك الاستثمارية.")
//                    .font(.system(size: 15))
//                    .foregroundColor(.white.opacity(0.75))
//                    .multilineTextAlignment(.center)
//                    .lineSpacing(6)
//                    .padding(.horizontal, 16)
//                
//                Button { dismiss() } label: {
//                    Text("فهمت وموافق")
//                        .font(.headline).bold()
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity).frame(height: 48)
//                        .background(Color(hex: "#A78BFA"))
//                        .cornerRadius(12)
//                }
//                .padding(.horizontal, 16)
//            }
//            .padding()
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// MARK: - 9. دوال مساعدة لترجمة القطاعات والألوان
//func sectorArabic(_ sector: String) -> String {
//    switch sector {
//    case "الكل":         return "الكل"
//    case "Energy":       return "قطاع الطاقة"
//    case "Banking":      return "قطاع المال"
//    case "Telecom":      return "قطاع الاتصالات"
//    case "Retail":       return "قطاع التجزئة"
//    case "Technology":   return "قطاع التقنية"
//    case "Food":         return "قطاع الغذاء"
//    case "Construction": return "قطاع البناء"
//    case "Travel":       return "قطاع السفر"
//    case "Healthcare":   return "قطاع الصحة"
//    case "Logistics":    return "قطاع اللوجستيك"
//    default:             return sector
//    }
//}
//
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3:
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6:
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 7:
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8:
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 1)
//        }
//        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
//    }
//}
//
//// MARK: - 10. الـ Preview النظيف والآمن من الأخطاء ليعمل بدون مشاكل
//#Preview {
//    MarketListView()
//}
//import SwiftUI
//
//// MARK: - 1. الـ ViewModel لإدارة العمليات وقراءة الـ JSON
//class MarketViewModel: ObservableObject {
//    @Published var marketData: MarketData?
//    @Published var selectedSector: String = "الكل"
//    @Published var userBalance: Double = 50000.0 // رصيد افتراضي للتداول التجريبي
//    @Published var ownedShares: [Int: Int] = [:] // تتبع الأسهم المملوكة [ID الشركة: الكمية]
//    
//    var sectors: [String] {
//        var list = ["الكل"]
//        if let companies = marketData?.companies {
//            let uniqueSectors = Set(companies.map { $0.sector })
//            list.append(contentsOf: uniqueSectors.sorted())
//        }
//        return list
//    }
//    
//    var filteredCompanies: [Company] {
//        guard let companies = marketData?.companies else { return [] }
//        if selectedSector == "الكل" {
//            return companies
//        } else {
//            return companies.filter { $0.sector == selectedSector }
//        }
//    }
//    
//    init() {
//        loadLocalJSON()
//    }
//    
//    private func loadLocalJSON() {
//        if let url = Bundle.main.url(forResource: "MarketData", withExtension: "json") {
//            do {
//                let data = try Data(contentsOf: url)
//                let decoder = JSONDecoder()
//                self.marketData = try decoder.decode(MarketData.self, from: data)
//            } catch {
//                print("Error parsing MarketData.json: \(error)")
//                setupFallbackMockData()
//            }
//        } else {
//            setupFallbackMockData()
//        }
//    }
//    
//    private func setupFallbackMockData() {
//        let dummyStats = Statistics(previousClose: 121.45, openPrice: 121.00, dayHigh: 126.00, dayLow: 119.00, volumeTraded: 2300000, tradingValue: 285200000, numberOfTrades: 23302, averageTradeSize: 12240, averagePrice: 123.10, bestBid: 123.90, bestAsk: 124.10)
//        let dummyStock = Stock(symbol: "NJD", currentPrice: 124.00, trend: "up", changePercent: 2.1, changeAmount: 2.55, riskLevel: "Medium", marketCap: "1.2T", statistics: dummyStats)
//        let dummyNews = News(headline: "توسع استراتيجي جديد لشركة نجد للطاقة", impact: "Positive")
//        let dummyChart = ChartData(timeframes: Timeframes(oneDay: [PricePoint(timestamp: "10:00", price: 120), PricePoint(timestamp: "14:00", price: 124)], oneWeek: [], oneMonth: [], oneYear: []))
//        
//        let fallbackCompanies = [
//            Company(id: 1, fakeName: "Najd Energy", imageName: "najd_logo", inspiredBy: "Aramco", sector: "Energy", description: "شركة طاقة افتراضية", icon: "🛢️", stock: dummyStock, news: dummyNews, chartData: dummyChart, candlestickData: [])
//        ]
//        self.marketData = MarketData(marketName: "Saudi Simulated Market", marketStatus: "Open", currency: "SAR", lastUpdated: "2026-05-12T14:30:00Z", companies: fallbackCompanies)
//    }
//    
//    func buyStock(company: Company, count: Int) -> Bool {
//        let cost = company.stock.currentPrice * Double(count)
//        if userBalance >= cost {
//            userBalance -= cost
//            ownedShares[company.id, default: 0] += count
//            return true
//        }
//        return false
//    }
//    
//    func sellStock(company: Company, count: Int) -> Bool {
//        let currentOwned = ownedShares[company.id, default: 0]
//        if currentOwned >= count {
//            let revenue = company.stock.currentPrice * Double(count)
//            userBalance += revenue
//            ownedShares[company.id] = currentOwned - count
//            return true
//        }
//        return false
//    }
//}
//
//// MARK: - 2. واجهة التطبيق الرئيسية (MarketListView)
//struct MarketListView: View {
//    @StateObject private var vm = MarketViewModel()
//    @State private var showSectorPicker = false
//    @State private var selectedTab = "المحاكي"
//    @State private var showDisclaimer = false
//
//    var body: some View {
//        NavigationStack {
//            ZStack(alignment: .bottom) {
//                Color(hex: "#0E0E10")
//                    .ignoresSafeArea()
//
//                VStack(spacing: 0) {
//                    if selectedTab == "المحاكي" {
//                        simulatorMainContent
//                    } else if selectedTab == "المحفظة" {
//                        walletContent
//                    } else {
//                        Spacer()
//                        Text("صفحة الرحلات")
//                            .foregroundColor(.white.opacity(0.4))
//                        Spacer()
//                    }
//                    
//                    Spacer()
//                    customTabBar
//                }
//                
//                if showSectorPicker {
//                    Color.black.opacity(0.45)
//                        .ignoresSafeArea()
//                        .onTapGesture {
//                            withAnimation(.spring(response: 0.3)) { showSectorPicker = false }
//                        }
//                    
//                    SectorPickerMenu(
//                        sectors: vm.sectors,
//                        selectedSector: $vm.selectedSector,
//                        isVisible: $showSectorPicker
//                    )
//                    .padding(.top, 72)
//                    .padding(.leading, 16)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//                }
//            }
//            .sheet(isPresented: $showDisclaimer) {
//                DisclaimerView()
//            }
//            .navigationBarHidden(true)
//        }
//    }
//    
//    private var simulatorMainContent: some View {
//        VStack(spacing: 0) {
//            HStack {
//                Button {
//                    withAnimation(.spring(response: 0.3)) { showSectorPicker.toggle() }
//                } label: {
//                    Image(systemName: "line.3.horizontal")
//                        .font(.system(size: 18, weight: .medium))
//                        .foregroundColor(.white)
//                        .frame(width: 44, height: 44)
//                        .background(Color.white.opacity(0.08))
//                        .clipShape(Circle())
//                }
//
//                Spacer()
//
//                Text("المحاكي")
//                    .font(.system(size: 28, weight: .bold))
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 16)
//            .padding(.bottom, 12)
//            .environment(\.layoutDirection, .rightToLeft)
//
//            if vm.selectedSector != "الكل" {
//                HStack {
//                    Spacer()
//                    HStack(spacing: 6) {
//                        Text(sectorArabic(vm.selectedSector))
//                            .font(.system(size: 13, weight: .medium))
//                            .foregroundColor(Color(hex: "#A78BFA"))
//
//                        Button {
//                            withAnimation { vm.selectedSector = "الكل" }
//                        } label: {
//                            Image(systemName: "xmark")
//                                .font(.system(size: 11, weight: .bold))
//                                .foregroundColor(Color(hex: "#A78BFA"))
//                        }
//                    }
//                    .padding(.horizontal, 12)
//                    .padding(.vertical, 6)
//                    .background(Color(hex: "#A78BFA").opacity(0.12))
//                    .cornerRadius(20)
//                }
//                .padding(.horizontal, 20)
//                .padding(.bottom, 8)
//            }
//
//            ScrollView {
//                LazyVStack(spacing: 0) {
//                    ForEach(vm.filteredCompanies) { company in
//                        NavigationLink(destination: CompanyDetailView(company: company, vm: vm)) {
//                            CompanyRow(company: company, currency: vm.marketData?.currency ?? "SAR")
//                        }
//                        .buttonStyle(PlainButtonStyle())
//                        
//                        Divider()
//                            .background(Color.white.opacity(0.07))
//                            .padding(.leading, 76)
//                    }
//                }
//                .padding(.bottom, 100)
//            }
//        }
//    }
//    
//    private var walletContent: some View {
//        VStack(spacing: 24) {
//            HStack {
//                Button { showDisclaimer = true } label: {
//                    Image(systemName: "info.circle")
//                        .font(.title2)
//                        .foregroundColor(.white.opacity(0.7))
//                }
//                Spacer()
//                Text("المحفظة")
//                    .font(.system(size: 24, weight: .bold))
//                    .foregroundColor(.white)
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 16)
//            
//            VStack(spacing: 12) {
//                Text("رصيدك الحالي بالمحاكي")
//                    .font(.subheadline)
//                    .foregroundColor(.white.opacity(0.6))
//                
//                Text(String(format: "%.2f %@", vm.userBalance, vm.marketData?.currency ?? "SAR"))
//                    .font(.system(size: 32, weight: .bold))
//                    .foregroundColor(Color(hex: "#34D399"))
//            }
//            .frame(maxWidth: .infinity)
//            .padding(24)
//            .background(Color(hex: "#1C1C1E"))
//            .cornerRadius(16)
//            .padding(.horizontal, 20)
//            
//            Spacer()
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//    
//    private var customTabBar: some View {
//        HStack {
//            Spacer()
//            Button { selectedTab = "المحفظة" } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "briefcase.fill")
//                    Text("المحفظة").font(.system(size: 11))
//                }
//                .foregroundColor(selectedTab == "المحفظة" ? Color(hex: "#A78BFA") : .gray)
//            }
//            Spacer()
//            Button { selectedTab = "رحلتك" } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "flag.checkered")
//                    Text("رحلتك").font(.system(size: 11))
//                }
//                .foregroundColor(selectedTab == "رحلتك" ? Color(hex: "#A78BFA") : .gray)
//            }
//            Spacer()
//            Button { selectedTab = "المحاكي" } label: {
//                VStack(spacing: 4) {
//                    Image(systemName: "chart.line.uptrend.xyaxis")
//                    Text("المحاكي").font(.system(size: 11))
//                }
//                .foregroundColor(selectedTab == "المحاكي" ? Color(hex: "#A78BFA") : .white)
//                .padding(.horizontal, 16)
//                .padding(.vertical, 8)
//                .background(selectedTab == "المحاكي" ? Color.white.opacity(0.12) : Color.clear)
//                .cornerRadius(20)
//            }
//            Spacer()
//        }
//        .frame(height: 70)
//        .background(Color(hex: "#111115").opacity(0.9))
//        .cornerRadius(30)
//        .padding(.horizontal, 20)
//        .padding(.bottom, 20)
//    }
//}
//
//// MARK: - 3. سطر عرض الشركة
//struct CompanyRow: View {
//    let company: Company
//    let currency: String
//
//    var body: some View {
//        HStack(spacing: 14) {
//            VStack(alignment: .leading, spacing: 4) {
//                Text(String(format: "%.2f", company.stock.currentPrice))
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.white)
//
//                Text(String(format: "%+.2f%%", company.stock.changePercent))
//                    .font(.system(size: 13, weight: .medium))
//                    .foregroundColor(company.stock.trend.lowercased() == "up" ? Color(hex: "#34D399") : Color(hex: "#F87171"))
//            }
//            .frame(width: 72, alignment: .leading)
//
//            MiniSparkline(points: company.chartData.timeframes.oneDay.map { $0.price }, trend: company.stock.trend)
//                .frame(width: 80, height: 36)
//
//            Spacer()
//
//            VStack(alignment: .trailing, spacing: 3) {
//                Text(company.fakeName)
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.white)
//
//                Text(sectorArabic(company.sector))
//                    .font(.system(size: 12))
//                    .foregroundColor(Color.white.opacity(0.45))
//            }
//
//            ZStack {
//                Circle()
//                    .fill(Color.white.opacity(0.06))
//                    .frame(width: 46, height: 46)
//                Text(company.icon)
//                    .font(.system(size: 22))
//            }
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 14)
//        .contentShape(Rectangle())
//    }
//}
//
//// MARK: - 4. الرسم البياني المصغر
//struct MiniSparkline: View {
//    let points: [Double]
//    let trend: String
//
//    var body: some View {
//        GeometryReader { geo in
//            let w = geo.size.width
//            let h = geo.size.height
//            let mn = points.min() ?? 0
//            let mx = points.max() ?? 1
//            let range = mx - mn == 0 ? 1 : mx - mn
//            let color = trend.lowercased() == "up" ? Color(hex: "#34D399") : Color(hex: "#F87171")
//
//            Path { path in
//                for (i, p) in points.enumerated() {
//                    let x = CGFloat(i) / CGFloat(max(points.count - 1, 1)) * w
//                    let y = h - CGFloat((p - mn) / range) * h
//                    if i == 0 { path.move(to: CGPoint(x: x, y: y)) }
//                    else       { path.addLine(to: CGPoint(x: x, y: y)) }
//                }
//            }
//            .stroke(color, style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
//        }
//    }
//}
//
//// MARK: - 5. قائمة الفلترة
//struct SectorPickerMenu: View {
//    let sectors: [String]
//    @Binding var selectedSector: String
//    @Binding var isVisible: Bool
//
//    var body: some View {
//        VStack(alignment: .trailing, spacing: 0) {
//            ForEach(sectors, id: \.self) { sector in
//                Button {
//                    withAnimation(.spring(response: 0.25)) {
//                        selectedSector = sector
//                        isVisible = false
//                    }
//                } label: {
//                    HStack {
//                        if selectedSector == sector {
//                            Image(systemName: "checkmark")
//                                .font(.system(size: 13, weight: .semibold))
//                                .foregroundColor(Color(hex: "#A78BFA"))
//                        } else {
//                            Spacer().frame(width: 17)
//                        }
//                        Spacer()
//                        Text(sectorArabic(sector)).font(.system(size: 16)).foregroundColor(.white)
//                    }
//                    .padding(.horizontal, 18)
//                    .padding(.vertical, 13)
//                }
//
//                if sector != sectors.last {
//                    Divider().background(Color.white.opacity(0.1))
//                }
//            }
//        }
//        .frame(width: 220)
//        .background(
//            RoundedRectangle(cornerRadius: 14)
//                .fill(Color(hex: "#1C1C1E"))
//                .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.1), lineWidth: 0.5))
//        )
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// MARK: - 6. شاشة تفاصيل التداول والشراء والبيع
//struct CompanyDetailView: View {
//    let company: Company
//    @ObservedObject var vm: MarketViewModel
//    @Environment(\.dismiss) var dismiss
//    
//    @State private var tradeType = "شراء"
//    @State private var quantity = 1
//    @State private var showStatsSheet = false
//    
//    @State private var showSuccessToast = false
//    @State private var toastMessage = ""
//    @State private var showErrorPopup = false
//    @State private var errorMessage = ""
//    
//    var body: some View {
//        ZStack {
//            Color(hex: "#0E0E10").ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                HStack {
//                    Button { dismiss() } label: {
//                        Image(systemName: "chevron.left").font(.title3).foregroundColor(.white)
//                    }
//                    Spacer()
//                    Text(company.fakeName).font(.title3).bold().foregroundColor(.white)
//                    Spacer()
//                    Button { showStatsSheet = true } label: {
//                        Image(systemName: "info.circle").font(.title3).foregroundColor(.white)
//                    }
//                }
//                .padding()
//                
//                VStack(spacing: 6) {
//                    Text(String(format: "%.2f", company.stock.currentPrice))
//                        .font(.system(size: 44, weight: .bold))
//                        .foregroundColor(.white)
//                    Text("السعر الحالي (\(company.stock.symbol))")
//                        .font(.caption).foregroundColor(.gray)
//                }
//                .padding(.vertical, 20)
//                
//                HStack {
//                    Spacer()
//                    Text("الكمية المملوكة في محفظتك: \(vm.ownedShares[company.id, default: 0]) سهم")
//                        .font(.system(size: 14))
//                        .foregroundColor(.white.opacity(0.6))
//                }
//                .padding(.horizontal, 24)
//                .padding(.bottom, 16)
//                
//                VStack(spacing: 20) {
//                    Picker("نوع العملية", selection: $tradeType) {
//                        Text("شراء").tag("شراء")
//                        Text("بيع").tag("بيع")
//                    }
//                    .pickerStyle(SegmentedPickerStyle())
//                    
//                    HStack {
//                        Spacer()
//                        HStack(spacing: 16) {
//                            Button { if quantity > 1 { quantity -= 1 } } label: {
//                                Image(systemName: "minus.circle.fill").font(.title2).foregroundColor(.gray)
//                            }
//                            Text("\(quantity)").font(.title3).bold().foregroundColor(.white)
//                            Button { quantity += 1 } label: {
//                                Image(systemName: "plus.circle.fill").font(.title2).foregroundColor(.gray)
//                            }
//                        }
//                        Spacer()
//                        Text("الكمية المراد تداولها:").foregroundColor(.white).font(.subheadline)
//                    }
//                    
//                    let totalPrice = company.stock.currentPrice * Double(quantity)
//                    HStack {
//                        Text(String(format: "%.2f %@", totalPrice, vm.marketData?.currency ?? "SAR"))
//                            .foregroundColor(Color(hex: "#34D399")).bold()
//                        Spacer()
//                        Text("إجمالي التكلفة المتوقعة:").foregroundColor(.gray).font(.caption)
//                    }
//                    
//                    Button {
//                        processSimulatorTrade()
//                    } label: {
//                        Text(tradeType == "شراء" ? "تأكيد عملية الشراء" : "تأكيد عملية البيع")
//                            .font(.headline).bold()
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 48)
//                            .background(tradeType == "شراء" ? Color(hex: "#1E3A8A") : Color(hex: "#991B1B"))
//                            .cornerRadius(12)
//                    }
//                }
//                .padding(20)
//                .background(Color(hex: "#1C1C1E"))
//                .cornerRadius(16)
//                .padding(.horizontal)
//                
//                Spacer()
//            }
//            
//            if showSuccessToast {
//                VStack {
//                    HStack {
//                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
//                        Text(toastMessage).foregroundColor(.white).font(.system(size: 14, weight: .medium))
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color(hex: "#1C1C1E"))
//                    .cornerRadius(10)
//                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.4), lineWidth: 1))
//                    .padding()
//                    Spacer()
//                }
//                .transition(.move(edge: .top).combined(with: .opacity))
//            }
//            
//            if showErrorPopup {
//                Color.black.opacity(0.55).ignoresSafeArea()
//                VStack(spacing: 16) {
//                    Text("عملية خاطئة").font(.headline).bold().foregroundColor(.white)
//                    Text(errorMessage).font(.subheadline).foregroundColor(.white.opacity(0.7)).multilineTextAlignment(.center).padding(.horizontal)
//                    
//                    Button { showErrorPopup = false } label: {
//                        Text("حسناً")
//                            .foregroundColor(.white).font(.subheadline).bold()
//                            .frame(maxWidth: .infinity).frame(height: 40)
//                            .background(Color(hex: "#1E3A8A")).cornerRadius(8)
//                    }
//                    .padding(.horizontal)
//                }
//                .padding(.vertical, 20)
//                .frame(width: 290)
//                .background(Color(hex: "#1C1C1E"))
//                .cornerRadius(14)
//            }
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//        .sheet(isPresented: $showStatsSheet) {
//            StatisticsSheetView(company: company, currency: vm.marketData?.currency ?? "SAR")
//        }
//    }
//    
//    private func processSimulatorTrade() {
//        if tradeType == "شراء" {
//            if vm.buyStock(company: company, count: quantity) {
//                toastMessage = "تم شراء السهم بنجاح واحتسابه بمحفظتك"
//                triggerSuccessAnimation()
//            } else {
//                errorMessage = "ليس لديك العملات الافتراضية الكافية لإتمام الشراء، يرجى مراجعة رصيد محفظتك"
//                withAnimation { showErrorPopup = true }
//            }
//        } else {
//            if vm.sellStock(company: company, count: quantity) {
//                toastMessage = "تم بيع السهم بنجاح وتحديث الرصيد الافتراضي"
//                triggerSuccessAnimation()
//            } else {
//                errorMessage = "خطأ في البيع، الكمية المدخلة تتجاوز عدد الأسهم المتاحة لديك حالياً"
//                withAnimation { showErrorPopup = true }
//            }
//        }
//    }
//    
//    private func triggerSuccessAnimation() {
//        withAnimation { showSuccessToast = true }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
//            withAnimation { showSuccessToast = false }
//        }
//    }
//}
//
//// MARK: - 7. شاشة عرض تفاصيل الإحصائيات
//struct StatisticsSheetView: View {
//    let company: Company
//    let currency: String
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        ZStack {
//            Color(hex: "#1C1C1E").ignoresSafeArea()
//            VStack(alignment: .trailing, spacing: 16) {
//                HStack {
//                    Spacer()
//                    Text("إحصائيات وقراءات السهم").font(.title3).bold().foregroundColor(.white)
//                }
//                
//                ScrollView {
//                    VStack(spacing: 12) {
//                        StatDetailRow(title: "الإغلاق السابق:", value: String(format: "%.2f %@", company.stock.statistics.previousClose, currency))
//                        StatDetailRow(title: "سعر الافتتاح:", value: String(format: "%.2f %@", company.stock.statistics.openPrice, currency))
//                        StatDetailRow(title: "أعلى سعر اليوم:", value: String(format: "%.2f %@", company.stock.statistics.dayHigh, currency))
//                        StatDetailRow(title: "أقل سعر اليوم:", value: String(format: "%.2f %@", company.stock.statistics.dayLow, currency))
//                        StatDetailRow(title: "عدد الصفقات المنفذة:", value: "\(company.stock.statistics.numberOfTrades)")
//                        StatDetailRow(title: "القيمة السوقية الكلية:", value: company.stock.marketCap)
//                    }
//                    .padding(.top, 10)
//                }
//            }
//            .padding(24)
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//struct StatDetailRow: View {
//    let title: String
//    let value: String
//    var body: some View {
//        VStack {
//            HStack {
//                Text(title).foregroundColor(.gray).font(.subheadline)
//                Spacer()
//                Text(value).foregroundColor(.white).bold().font(.subheadline)
//            }
//            Divider().background(Color.white.opacity(0.08))
//        }
//    }
//}
//
//// MARK: - 8. شاشة شروط وإخلاء المسؤولية للمحاكي
//struct DisclaimerView: View {
//    @Environment(\.dismiss) var dismiss
//    var body: some View {
//        ZStack {
//            Color(hex: "#0E0E10").ignoresSafeArea()
//            VStack(spacing: 24) {
//                Text("شروط وإخلاء مسؤولية المحاكي")
//                    .font(.title3).bold()
//                    .foregroundColor(.white)
//                
//                Text("إن جميع الأسعار والصفقات والعمليات المالية التي تتم داخل هذا القسم هي محاكاة افتراضية تعليمية بحتة ولا ترتبط بأسواق الأسهم الحقيقية المالية بأي شكل من الأشكال، وتهدف فقط إلى توفير بيئة محاكاة تدريبية لرحلتك الاستثمارية.")
//                    .font(.system(size: 15))
//                    .foregroundColor(.white.opacity(0.75))
//                    .multilineTextAlignment(.center)
//                    .lineSpacing(6)
//                    .padding(.horizontal, 16)
//                
//                Button { dismiss() } label: {
//                    Text("فهمت وموافق")
//                        .font(.headline).bold()
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity).frame(height: 48)
//                        .background(Color(hex: "#A78BFA"))
//                        .cornerRadius(12)
//                }
//                .padding(.horizontal, 16)
//            }
//            .padding()
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// MARK: - 9. المساعدات الإضافية والترجمات
//func sectorArabic(_ sector: String) -> String {
//    switch sector {
//    case "الكل":         return "الكل"
//    case "Energy":       return "قطاع الطاقة"
//    case "Banking":      return "قطاع المال"
//    case "Telecom":      return "قطاع الاتصالات"
//    case "Retail":       return "قطاع التجزئة"
//    case "Technology":   return "قطاع التقنية"
//    case "Food":         return "قطاع الغذاء"
//    case "Construction": return "قطاع البناء"
//    case "Travel":       return "قطاع السفر"
//    case "Healthcare":   return "قطاع الصحة"
//    case "Logistics":    return "قطاع اللوجستيك"
//    default:             return sector
//    }
//}
//
//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//        let a, r, g, b: UInt64
//        switch hex.count {
//        case 3:
//            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
//        case 6:
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 7:
//            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
//        case 8:
//            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
//        default:
//            (a, r, g, b) = (1, 1, 1, 1)
//        }
//        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
//    }
//}
//
//// MARK: - 10. الـ Preview النظيف
//#Preview {
//    MarketListView()
//}
