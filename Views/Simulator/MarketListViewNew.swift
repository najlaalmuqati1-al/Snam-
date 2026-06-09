import SwiftUI
import Combine

// MARK: - MarketListViewNew
struct MarketListViewNew: View {
    @StateObject private var vm = MarketViewModelNew()
    @State private var showSectorPicker = false

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                LinearGradient(
                    colors: [
                        Color.black,
                        Color("#09101E")
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        Text("المحاكي")
                            .font(.system(size: 30, weight: .black))

                        Spacer()

                        Button {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) { showSectorPicker.toggle() }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 44, height: 44)
                                .background(Color.white.opacity(0.05))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 16)
                    .padding(.bottom, 20)

                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 12) {
                            ForEach(vm.filteredCompanies) { company in
                                NavigationLink(
                                    destination: CompanyDetailViewNew(
                                        company: company,
                                        vm: vm
                                    )
                                ) {

                                    CompanyRowNew(
                                        company: company,
                                        currency: vm.marketData?.currency ?? "SAR"
                                    )
                                    .background(
                                        RoundedRectangle(cornerRadius: 24)
                                            .fill(Color.white.opacity(0.03))
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 24)
                                            .stroke(
                                                Color.white.opacity(0.05),
                                                lineWidth: 1
                                            )
                                    )
                                    .padding(.vertical,1)
                                }
                                .buttonStyle(.plain)
                                
                            }
                        }
                    }
                }

                if showSectorPicker {
                    Color.black.opacity(0.2)
                        .ignoresSafeArea()
                        .onTapGesture { withAnimation { showSectorPicker = false } }

                SectorPickerMenuNew(
                        sectors: vm.sectors,
                        selectedSector: $vm.selectedSector,
                        isVisible: $showSectorPicker
                    )
                    .padding(.top, 90)
                    .padding(.trailing, 35)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
            }
            .navigationBarHidden(true)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}
struct CompanyRowNew: View {
    let company: Company
    let currency: String

    var body: some View {

        HStack {

            // الشركة والقطاع واللوقو (يمين)

            HStack(spacing: 12) {

                VStack(alignment: .trailing, spacing: 4) {

                    Text(company.fakeName)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)

                    Text(sectorArabicMLN(company.sector))
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }

                ZStack {

                    Circle()
                        .fill(Color.white.opacity(0.05))
                        .frame(width: 48, height: 48)

                    Text(company.icon)
                        .font(.system(size: 20))
                }
            }

            Spacer()

//            // الشارت بالنص
//
//            MLNSparkline(
//                points: company.chartData.timeframes.oneDay.map { $0.price },
//                trend: company.stock.trend
//
//            )
//            .frame(width: 120, height: 34)
            MLNSparkline(
                points: company.chartData.timeframes.oneDay.map { $0.price },
                trend: company.stock.trend
            )
            .frame(width: 70, height: 20)

            // السعر والنسبة (يسار)

            VStack(alignment: .leading, spacing: 4) {

                Text("\(Int(company.stock.currentPrice)) \(currency)")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)

                Text(
                    company.stock.changePercent >= 0
                    ? "+\(String(format: "%.2f", company.stock.changePercent))%"
                    : "\(String(format: "%.2f", company.stock.changePercent))%"
                )
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(
                    company.stock.trend.lowercased() == "up"
                    ? Color.green
                    : Color.red
                )
            }
            .frame(width: 90, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .contentShape(Rectangle())
    }
}
//// MARK: - CompanyRowNew
//struct CompanyRowNew: View {
//    let company: Company
//    let currency: String
//
//    var body: some View {
//        HStack(spacing: 0) {
//            VStack(alignment: .leading, spacing: 4) {
//                HStack(spacing: 4) {
//                    Text(currency)
//                        .font(.system(size: 11, weight: .medium))
//                        .foregroundColor(.gray)
//                    Text("\(Int(company.stock.currentPrice))")
//                        .font(.system(size: 17, weight: .bold))
//                        .foregroundColor(.white)
//                }
//
//                Text(company.stock.changePercent >= 0 ? String(format: "+%.2f%%", company.stock.changePercent) : String(format: "%.2f%%", company.stock.changePercent))
//                    .font(.system(size: 12, weight: .bold))
//                    .foregroundColor(company.stock.trend.lowercased() == "up" ? Color("#22C55E") : Color("#EF4444"))
//            }
//            .frame(width: 85, alignment: .leading)
//
//            Spacer()
//
//            MLNSparkline(points: company.chartData.timeframes.oneDay.map { $0.price }, trend: company.stock.trend)
//                .frame(width: 95, height: 34)
//
//            Spacer()
//
//            HStack(spacing: 12) {
//                VStack(alignment: .trailing, spacing: 4) {
//                    Text(company.fakeName)
//                        .font(.system(size: 15, weight: .bold))
//                        .foregroundColor(.white)
//
//                    Text(sectorArabicMLN(company.sector))
//                        .font(.system(size: 11))
//                        .foregroundColor(.gray)
//                }
//
//                ZStack {
//                    Circle()
//                        .fill(Color.white.opacity(0.04))
//                        .frame(width: 54, height: 54)
//                        .overlay(Circle().stroke(Color.white.opacity(0.06), lineWidth: 1))
//
//                    Text(company.icon)
//                        .font(.system(size: 18))
//                }
//            }
//            .frame(width: 150, alignment: .trailing)
//        }
//        .padding(.horizontal, 24)
//        .padding(.vertical, 16)
//        .contentShape(Rectangle())
//    }
//}

// MARK: - MLNSparkline
struct MLNSparkline: View {

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

// MARK: - SectorPickerMenuNew
struct SectorPickerMenuNew: View {
    let sectors: [String]
    @Binding var selectedSector: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(sectors, id: \.self) { sector in
                SectorRowNew(
                    title: sectorArabicMLN(sector),
                    isSelected: selectedSector == sector
                ) {
                    selectedSector = sector
                    isVisible = false
                }
                if sector != sectors.last {
                    Divider().background(Color.white.opacity(0.05))
                }
            }
        }
        .frame(width: 220)

        .background(
            RoundedRectangle(cornerRadius: 32)
                .fill(Color.black.opacity(0.75))
        )

        .overlay(
            RoundedRectangle(cornerRadius: 32)
                .stroke(
                    Color.white.opacity(0.18),
                    lineWidth: 1
                )
        )

        .shadow(
            color: .black.opacity(0.5),
            radius: 20,
            x: 0,
            y: 10
        )
    }
}

private struct SectorRowNew: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(Color("#A78BFA"))
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - CompanyDetailViewNew
struct CompanyDetailViewNew: View {
    let company: Company
    @ObservedObject var vm: MarketViewModelNew
    @Environment(\.dismiss) var dismiss
    
    @State private var tradeType = "شراء"
    @State private var quantity = 1
    @State private var showStatsSheet = false
    
    @State private var showSuccessToast = false
    @State private var toastMessage = ""
    @State private var showErrorPopup = false
    @State private var errorMessage = ""
    @State private var showTradeSheet = false
    @State private var selectedTimeFrame = "1ي"
    var body: some View {
        ZStack {
            Color("#05070A").ignoresSafeArea()
            
            VStack(spacing: 0) {
                HStack {
                    Button { showStatsSheet = true } label: {
                        Image(systemName: "info.circle")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text(company.fakeName)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                VStack(spacing: 12) {

                    HStack {
                        Spacer()

                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.08))
                                .frame(width: 55, height: 55)

                            Text(company.icon)
                                .font(.system(size: 24))
                        }
                    }

                    Text(company.fakeName)
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    HStack(spacing: 4) {

                        Text(
                            company.stock.changePercent >= 0
                            ? "+\(String(format: "%.2f", company.stock.changePercent))%"
                            : "\(String(format: "%.2f", company.stock.changePercent))%"
                        )
                        .foregroundColor(.green)

                        Text("")
                            .foregroundColor(.white.opacity(0.8))
                    }

                    HStack(spacing: 18) {

                        Text("1س")
                        Text("6س")
                        Text("1ي")
                        Text("1ش")
                        Text("3ش")
                        Text("1س")

                    }
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                }
                .padding(.top,20)
//
//                VStack(spacing: 6) {
//                    Text(String(format: "%.2f", company.stock.currentPrice))
//                        .font(.system(size: 48, weight: .bold))
//                        .foregroundColor(.white)
//                    
//                    Text("السعر الحالي (\(company.stock.symbol))")
//                        .font(.system(size: 12))
//                        .foregroundColor(.gray)
//                }
//                .padding(.top, 40)
//                .padding(.bottom, 20)
//                
//                Text("الكمية المملوكة في محفظتك: \(vm.ownedShares[company.id, default: 0]) سهم")
//                    .font(.system(size: 13))
//                    .foregroundColor(.white.opacity(0.5))
//                    .padding(.bottom, 40)
                MLNBigChartView(
                    prices: company.chartData.timeframes.oneDay.map { $0.price }
                )
                
                
                
                VStack(spacing: 28) {
                    
                    HStack(spacing: 12) {
                        
                        Button {
                            withAnimation {
                                tradeType = "بيع"
                            }
                        } label: {
                            Text("بيع")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(tradeType == "بيع" ? .white : .gray)
                                .frame(maxWidth: .infinity)
                                .frame(height: 38)
                                .background(
                                    tradeType == "بيع"
                                    ? Color.white.opacity(0.15)
                                    : Color.white.opacity(0.04)
                                )
                                .cornerRadius(20)
                        }
                        
                        Button {
                            withAnimation {
                                tradeType = "شراء"
                            }
                        } label: {
                            Text("شراء")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(tradeType == "شراء" ? .white : .gray)
                                .frame(maxWidth: .infinity)
                                .frame(height: 38)
                                .background(
                                    tradeType == "شراء"
                                    ? Color.white.opacity(0.15)
                                    : Color.white.opacity(0.04)
                                )
                                .cornerRadius(20)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    HStack {
                        Text("الكمية المراد تداولها:")
                            .font(.system(size: 15, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        HStack(spacing: 16) {
                            Button { if quantity > 1 { quantity -= 1 } } label: {
                                Image(systemName: "minus.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.gray)
                            }
                            
                            Text("\(quantity)")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Button { quantity += 1 } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    
                    let totalPrice = company.stock.currentPrice * Double(quantity)
                    HStack {
                        Text("إجمالي التكلفة المتوقعة:")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        Spacer()
                        Text(String(format: "%.2f %@", totalPrice, vm.marketData?.currency ?? "SAR"))
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 24)
                    
                    Spacer()
                    
                    Button {
                        processSimulatorTrade()
                    } label: {
                        Text(tradeType == "شراء" ? "تأكيد عملية الشراء" : "تأكيد عملية البيع")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(Color("#101622"))
                            .cornerRadius(14)
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.05), lineWidth: 1))
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                }
                
                Spacer()
            }
            
            if showSuccessToast {
                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle.fill").foregroundColor(.green)
                        Text(toastMessage).foregroundColor(.white).font(.system(size: 13))
                        Spacer()
                    }
                    .padding()
                    .background(Color("#0D1527"))
                    .cornerRadius(10)
                    .padding()
                    Spacer()
                }
            }
            
            if showErrorPopup {
                Color.black.opacity(0.4).ignoresSafeArea()
                VStack(spacing: 16) {
                    Text("عملية خاطئة").font(.headline).bold().foregroundColor(.white)
                    Text(errorMessage).font(.subheadline).foregroundColor(.white.opacity(0.7)).multilineTextAlignment(.center).padding(.horizontal)
                    Button { showErrorPopup = false } label: {
                        Text("حسناً")
                            .foregroundColor(.white).bold()
                            .frame(maxWidth: .infinity).frame(height: 40)
                            .background(Color.blue).cornerRadius(8)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 20)
                .frame(width: 280)
                .background(Color("#0D1527"))
                .cornerRadius(12)
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .sheet(isPresented: $showStatsSheet) {
            MLNStatisticsSheetView(company: company, currency: vm.marketData?.currency ?? "SAR")
        }
    }
    
    private func processSimulatorTrade() {
        if tradeType == "شراء" {
            if vm.buyStock(company: company, count: quantity) {
                toastMessage = "تم شراء السهم بنجاح واحتسابه بمحفظتك"
                triggerSuccessAnimation()
            } else {
                errorMessage = "ليس لديك العملات الافتراضية الكافية لإتمام الشراء"
                withAnimation { showErrorPopup = true }
            }
        } else {
            if vm.sellStock(company: company, count: quantity) {
                toastMessage = "تم بيع السهم بنجاح وتحديث الرصيد الافتراضي"
                triggerSuccessAnimation()
            } else {
                errorMessage = "خطأ في البيع، الكمية المدخلة تتجاوز المتاح لديك"
                withAnimation { showErrorPopup = true }
            }
        }
    }
    
    private func triggerSuccessAnimation() {
        withAnimation { showSuccessToast = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation { showSuccessToast = false }
        }
    }
}
    
    // MARK: - MLNStatisticsSheetView
    struct MLNStatisticsSheetView: View {
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
                            MLNStatDetailRow(title: "الإغلاق السابق:", value: String(format: "%.2f %@", company.stock.statistics.previousClose, currency))
                            MLNStatDetailRow(title: "سعر الافتتاح:", value: String(format: "%.2f %@", company.stock.statistics.openPrice, currency))
                            MLNStatDetailRow(title: "أعلى سعر اليوم:", value: String(format: "%.2f %@", company.stock.statistics.dayHigh, currency))
                            MLNStatDetailRow(title: "أقل سعر اليوم:", value: String(format: "%.2f %@", company.stock.statistics.dayLow, currency))
                            MLNStatDetailRow(title: "عدد الصفقات المنفذة:", value: "\(company.stock.statistics.numberOfTrades)")
                            MLNStatDetailRow(title: "القيمة السوقية الكلية:", value: company.stock.marketCap)
                        }
                        .padding(.top, 10)
                    }
                }
                .padding(24)
            }
//            .environment(\.layoutDirection, .rightToLeft)
        }

    
    struct MLNStatDetailRow: View {
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
    
    // MARK: - Helpers (Arabic sectors)
    func sectorArabicMLN(_ sector: String) -> String {
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
    struct MLNBigChartView: View {
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
    // MARK: - Preview
    #Preview {
        MarketListViewNew()
        
    }

