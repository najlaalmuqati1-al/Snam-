

import SwiftUI

struct MarketListViewV2: View {
    
    @StateObject private var vm = MarketViewModelNew()
    @State private var showFilterMenu = false
    @State private var selectedSector = "الكل"
//    @AppStorage("hasSeenTutorial") var hasSeenTutorial = false
    @State private var tutorialStep = 0
    @AppStorage("hasCompletedTutorial")
    private var hasCompletedTutorial = false

    var displayedCompanies: [Company] {

        if selectedSector == "الكل" {
            return vm.filteredCompanies
        }

        return vm.filteredCompanies.filter {
            sectorArabicNew($0.sector) == selectedSector
        }
    }

    func filterButton(_ title: String) -> some View {

        Button {

            selectedSector = title
            showFilterMenu = false

        } label: {

            HStack {

                if selectedSector == title {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                }

                Spacer()

                Text(title)
                    .foregroundColor(.white)
                    .font(.title3)
            }
            .padding(.horizontal, 24)
        }
        
    }
    func tutorialBubble(_ text: String) -> some View {

        VStack(spacing: 0) {

            Text(text)
                .font(.headline)
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
                .background(Color.white)
                .cornerRadius(16)

            Image(systemName: "triangle.fill")
                .font(.system(size: 12))
                .foregroundColor(.white)
                .rotationEffect(.degrees(180))
                .offset(y: -3)
        }
    }
    var body: some View {
        NavigationStack {
            
            ZStack {
              
                
                if !hasCompletedTutorial {

                    Color.black.opacity(0.100)
                        .ignoresSafeArea()

                    VStack {

                        switch tutorialStep {

                        case 0:
                            tutorialBubble("اسم الشركة والقطاع")
                                .offset(x: 20, y: 120)

                        case 1:
                            tutorialBubble("سعر السهم الحالي")
                                .offset(x: -120, y: 120)

                        case 2:
                            tutorialBubble("شارت السهم")
                                .offset(x: -30, y: 239)

                        case 3:
                            tutorialBubble("اضغط على أي شركة لعرض التفاصيل")
                                .offset(x: 20, y: 310)

                        default:
                            EmptyView()
                        }

                        Spacer()
                    }
                    .zIndex(999)
                }
                if showFilterMenu {

                    VStack {

                        HStack {

                            VStack(spacing: 8) {

                                filterButton("الكل")
                                filterButton("قطاع الطاقة")
                                filterButton("قطاع المال والبنوك")
                                filterButton("قطاع الاتصالات")
                                filterButton("قطاع التقنية")
                            }
                            .padding(.vertical, 10)
                            .frame(width: 260)
                            .background(
                                RoundedRectangle(cornerRadius: 34)
                                    .fill(Color.black.opacity(0.93))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 34)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )

                            Spacer()
                        }
                        .padding(.leading, 20)   // ← زيدي أو نقصي هنا فقط

                        Spacer()
                    }
                    .padding(.top, 110)
                    .zIndex(999)
                }
                VStack {
                    
                    HStack {
                        
                        Text("المحاكي")
                            .font(.system(size: 36, weight: .black))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showFilterMenu.toggle()
                            }
                                
                            } label: {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .foregroundColor(.white)
                                    .font(.system(size: 22, weight: .regular))
                                    .frame(width: 44, height: 44)
                                    .background(
                                        Circle()
                                            .fill(Color.black.opacity(0.2))
                                    )
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                            }
                    
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 55)
                        .padding(.bottom, 20)
                        .environment(\.layoutDirection, .rightToLeft)
                        ScrollView {
                            
                            LazyVStack(spacing: 0) {
                                
                                ForEach(displayedCompanies) { company in

                                    NavigationLink {

                                        CompanyDetailViewV2(
                                            company: company,
                                            vm: vm
                                        )

                                    } label: {

                                        CompanyCardV2(
                                            company: company,
                                            currency: vm.marketData?.currency ?? "SAR"
                                        )

                                    }
                                    .buttonStyle(.plain)

                                }
//                                .padding(.horizontal)
                            }
                        }
                    }
                    .environment(\.layoutDirection, .rightToLeft)
                    .onAppear {
                
                        guard !hasCompletedTutorial else { return }

                Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in

                    tutorialStep += 1

                    if tutorialStep > 3 {

                        timer.invalidate()
                    }
                }
            }
                }
            }
        }
    
}
    struct CompanyCardV2: View {
        
        let company: Company
        let currency: String
        
        var body: some View {
            
            
            HStack {
                
                ZStack {
                    
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 40, height: 44)
                    
                    Text(company.icon)
                        .font(.title3)
                }
                
                VStack(alignment: .trailing, spacing: 4) {
                    
                    Text(company.fakeName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(sectorArabicNew(company.sector))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
//                هذا الشارت حق الاسهم
                MiniSparklineNew(
                    points: company.chartData.timeframes.oneDay.map { $0.price },
                    trend: company.stock.trend
                )
                .frame(width: 75, height: 22)
                
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    
                    Text("\(Int(company.stock.currentPrice))")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(
                        company.stock.changePercent >= 0
                        ? "+\(String(format: "%.2f", company.stock.changePercent))%"
                        : "\(String(format: "%.2f", company.stock.changePercent))%"
                    )
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(
                        company.stock.changePercent >= 0 ? .green : .red
                    )
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .overlay(
                Rectangle()
                    .fill(Color(red: 89/255,
                                green: 89/255,
                                blue: 89/255))
                    .frame(height: 0.6),
                alignment: .bottom
            )
        }
        
        
        
        
        struct FilterItem: View {
            
            let title: String
            
            var body: some View {
                
                Text(title)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .overlay(
                        Divider(),
                        alignment: .bottom
                    )
            }
        }
        
        
        
        
        
    }

    #Preview {
        MarketListViewV2()
    }

struct MiniSparklineNew: View {

    let points: [Double]
    let trend: String

    var body: some View {

        GeometryReader { geo in

            let width = geo.size.width
            let height = geo.size.height

            let minValue = points.min() ?? 0
            let maxValue = points.max() ?? 1
            let range = max(maxValue - minValue, 1)

            Path { path in

                for index in points.indices {

                    let x =
                    CGFloat(index)
                    /
                    CGFloat(max(points.count - 1, 1))
                    * width

                    let y =
                    height -
                    (
                        CGFloat(points[index] - minValue)
                        /
                        CGFloat(range)
                    ) * height

                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(
                trend.lowercased() == "down"
                ? .red
                : .green,
                style: StrokeStyle(
                    lineWidth: 3,
                    lineCap: .round,
                    lineJoin: .round
                )
            )
        }
    }
}
func sectorArabicNew(_ sector: String) -> String {
    switch sector {
    case "الكل":         return "الكل"
    case "Energy":       return "قطاع الطاقة"
    case "Banking":      return "قطاع المال والبنوك"
    case "Telecom":      return "قطاع الاتصالات"
    case "Retail":       return "قطاع التجزئة"
    case "Technology":   return "قطاع التقنية"
    default:              return sector
    }
}

struct MarketBigChartView: View {
    let prices: [Double]
    
    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            
            let minPrice = prices.min() ?? 0
            let maxPrice = prices.max() ?? 1
            let range = max(maxPrice - minPrice, 1)
            
            Path { path in
                for (index, price) in prices.enumerated() {
                    
                    let x = CGFloat(index) /
                    CGFloat(max(prices.count - 1, 1))
                    * width
                    
                    let y = height -
                    CGFloat((price - minPrice) / range)
                    * height
                    
                    if index == 0 {
                        path.move(to: CGPoint(x: x, y: y))
                    } else {
                        path.addLine(to: CGPoint(x: x, y: y))
                    }
                }
            }
            .stroke(.green, lineWidth: 3)
        }
    }
}
struct StatisticsSheetViewNew: View {
    let company: Company
    let currency: String
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                HStack {
                    Spacer()
                    Text("إحصائيات وقراءات السهم").font(.title3).bold().foregroundColor(.white)
                }
                
                ScrollView {
                    VStack(spacing: 12) {
                        StatDetailRowNew(title: "الإغلاق السابق:", value: String(format: "%.2f %@", company.stock.statistics.previousClose, currency))
                        StatDetailRowNew(title: "سعر الافتتاح:", value: String(format: "%.2f %@", company.stock.statistics.openPrice, currency))
                        StatDetailRowNew(title: "أعلى سعر اليوم:", value: String(format: "%.2f %@", company.stock.statistics.dayHigh, currency))
                        StatDetailRowNew(title: "أقل سعر اليوم:", value: String(format: "%.2f %@", company.stock.statistics.dayLow, currency))
                        StatDetailRowNew(title: "عدد الصفقات المنفذة:", value: "\(company.stock.statistics.numberOfTrades)")
                        StatDetailRowNew(title: "القيمة السوقية الكلية:", value: company.stock.marketCap)
                    }
                    .padding(.top, 10)
                }
            }
            .padding(24)
        }
//            .environment(\.layoutDirection, .rightToLeft)
    }


struct StatDetailRowNew: View {
    let title: String
    let value: String
    var body: some View {
        VStack {
            HStack {
                Text(title).foregroundColor(.gray).font(.subheadline)
                Spacer()
                Text(value).foregroundColor(.white).bold().font(.subheadline)
            }
            Divider().background(Color.white.opacity(0.08))
        }
    }
}
