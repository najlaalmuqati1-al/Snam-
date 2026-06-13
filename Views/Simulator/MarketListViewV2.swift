


import SwiftUI

struct MarketListViewV2: View {
    
    @EnvironmentObject var vm: MarketViewModelNew
    @State private var showFilterMenu = false
    @State private var selectedSector = "الكل"
//    @AppStorage("hasSeenTutorial") var hasSeenTutorial = false
    @State private var tutorialStep = 0
    @EnvironmentObject var walletState: WalletState
    @AppStorage("hasCompletedTutorial") private var hasCompletedTutorial = false
    

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
    
    //MARK: - body
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .overlay(
                        Image("Frame")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    )
                
            //MARK: - onbording
                
//                if !hasCompletedTutorial {
//                    ZStack{
//                        Color.black.opacity(0.100)
//                            .ignoresSafeArea()
//
//                        VStack {
//
//                            switch tutorialStep {
//
//                            case 0:
//                                tutorialBubble("اسم الشركة والقطاع")
//                                    .offset(x: 20, y: 120)
//
//                            case 1:
//                                tutorialBubble("سعر السهم الحالي")
//                                    .offset(x: -120, y: 120)
//
//                            case 2:
//                                tutorialBubble("شارت السهم")
//                                    .offset(x: -30, y: 239)
//
//                            case 3:
//                                tutorialBubble("اضغط على أي شركة لعرض التفاصيل")
//                                    .offset(x: 20, y: 310)
//
//                            default:
//                                EmptyView()
//                            }
//
//                            Spacer()
//                        }
//                        .zIndex(999)
//                    }
//                }//end of if
                
                //MARK: - heder
                
                if showFilterMenu {

                    VStack {
                        HStack {
                            VStack(spacing: 20) {
                                filterButton("الكل")
                                filterButton("قطاع الطاقة")
                                filterButton("قطاع المال والبنوك")
                                filterButton("قطاع الاتصالات")
                                filterButton("قطاع التقنية")
                            }
                            .padding(.vertical, 18)
                            .frame(width: 260)
                            .background(
                                RoundedRectangle(cornerRadius: 34)
                                    .fill(Color.black)
                                    .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0.1, y: 0.1)
                                    .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.2, y: -0.2)
                            )
                        
                            Spacer()
                        }
                        .padding(.leading, 20)   // ← زيدي أو نقصي هنا فقط
                        Spacer()
                    }
                    .padding(.top, 110)
                    .zIndex(999)
                }//end of if
                
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
                                ZStack{
                                    Color.black
                                        .cornerRadius(1000)
                                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.2)
                                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.2)
                                        .frame(width: 44, height: 44)
                                        .glassEffect()
                                    
                                    Image(systemName: "line.3.horizontal.decrease")
                                        .foregroundStyle(Color.white)
                                        .font(.system(size: 22))
                                }//z
                                .glassEffect()
                            }
                    
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 42)
                        .padding(.bottom, 32)
                        .environment(\.layoutDirection, .rightToLeft)
                    
                    //MARK: - Market
                    
                        ScrollView {
                            
                            LazyVStack(spacing: 0) {
                                
                                ForEach(displayedCompanies) { company in

                                    NavigationLink {
                                        CompanyDetailViewV2(company: company, vm: vm)
                                            .environmentObject(walletState)
                                    } label: {
                                        CompanyCardV2(
                                            company: company,
                                            currency: vm.marketData?.currency ?? "SAR"
                                        )

                                    }
                                    .buttonStyle(.plain)

                                }
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
                               Image(
                                   company.fakeName == "Najd Energy" ? "energy_logo" :
                                   company.fakeName == "Desert Bank" ? "bank_logo" :
                                   company.fakeName == "Najd Telecom" ? "telecom_logo" :
                                   company.fakeName == "Souq Arabia" ? "retail_logo" :
                                   company.fakeName == "NeoTech KSA" ? "tech_logo" :
                                   company.fakeName == "Palm Foods" ? "food_logo" :
                                   company.fakeName == "Golden Cement" ? "construction_logo" :
                                   company.fakeName == "Sky Airlines" ? "travel_logo" :
                                   company.fakeName == "Future Health" ? "health_logo" :
                                   "logistics_logo"
                               )
                               .resizable()
                               .scaledToFit()
                               .frame(width: 40, height: 44)
                           }
                
                VStack(spacing: 8) {
                    
                    Text(companyNameArabic(company.fakeName))
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 120,height: 18,alignment: .leading)
                    
                    Text(sectorArabicNew(company.sector))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .frame(width: 120,height: 11,alignment: .leading)
                }
                
                
                Spacer().frame(width: 20)
                
//                هذا الشارت حق الاسهم
//                MiniSparklineNew(
//                    points: company.chartData.timeframes.oneDay.map { $0.price },
//                    trend: company.stock.trend
//                ).frame(width: 75, height: 22)
                
                Image(systemName:
                    company.stock.changePercent >= 0
                    ? "arrowtriangle.up.fill"
                    : "arrowtriangle.down.fill"
                )
                .font(.system(size: 20))
                .foregroundColor(
                    company.stock.changePercent >= 0
                    ? .green
                    : .red
                                ) .frame(width: 75, height: 22)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 4) {
                    
                    Text(arabicNumerals("\(Int(company.stock.currentPrice))"))

                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    + Text(" سنام")
                        .font(.system(size: 12,weight: .bold))
                    
                    
                    Text(arabicNumerals(company.stock.changePercent >= 0
                            ? "+\(String(format: "%.2f", company.stock.changePercent))%"
                            : "\(String(format: "%.2f", company.stock.changePercent))%"))
                    
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(
                        company.stock.changePercent >= 0 ? .green : .red
                    )
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            .overlay(
                Rectangle()
                    .fill(.gray)
                    .frame(height: 0.2),alignment: .bottom)
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
    case "Food":         return "الأغذية"
    case "Construction": return "البناء"
    case "Travel":       return "السفر"
    case "Healthcare":   return "الرعاية الصحية"
    case "Logistics":    return "اللوجستيات"
    default:              return sector
    }
}
func companyNameArabic(_ fakeName: String) -> String {
    switch fakeName {
    case "Najd Energy":    return "طاقة نجد"
    case "Desert Bank":    return "بنك الصحراء"
    case "Najd Telecom":   return "اتصالات نجد"
    case "Souq Arabia":    return "سوق العربية"
    case "NeoTech KSA":    return "نيوتك السعودية"
    case "Palm Foods":     return "النخلة للأغذية"
    case "Golden Cement":  return "الأسمنت الذهبي"
    case "Sky Airlines":   return "سكاي للطيران"
    case "Future Health":  return "مستقبل الصحة"
    case "Smart Logistics": return " خدمات لوجستيه"
    default:               return fakeName
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
#Preview {
    MarketListViewV2()
        .environmentObject(WalletState())
}
