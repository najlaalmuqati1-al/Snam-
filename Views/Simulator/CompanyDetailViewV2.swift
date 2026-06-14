// CompanyDetailViewV2

import SwiftUI

struct CompanyDetailViewV2: View {
    
    let company: Company
    @ObservedObject var vm: MarketViewModelNew
    @State private var showTradeSheet = false
    @State private var showInfo = false
    @State private var showSuccessBanner = false
    @State private var bannerMessage = ""
    @State private var showSuccessToast = false
    @State private var selectedPeriod = "يوم"
    @State private var toastMessage = ""
    @AppStorage("hasCompletedTutorial")
    private var hasCompletedTutorial = false
    @State private var detailTutorialStep = 0
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var walletState: WalletState
    @State private var isSuccessToast: Bool = true
    let periods = ["سنه", "شهر", "اسبوع", "يوم"]
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
                .offset(x: 70,y: -3)
        }
    }
    var body: some View {
        
        
        ZStack {
            
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .navigationBarBackButtonHidden(true)
            
            //MARK: - onbording
            
//            if !hasCompletedTutorial {
//                
//                Color.black.opacity(0.65)
//                    .ignoresSafeArea()
//                
//                VStack {
//                    
//                    switch detailTutorialStep {
//                        
//                    case 0:
//                        tutorialBubble("هذا سعر السهم الحالي")
//                            .offset(x: 95, y: 105)
//                        
//                    case 1:
//                        tutorialBubble("هنا يمكنك متابعة حركة السهم")
//                            .offset(x: 0, y: 310)
//                        
//                    case 2:
//                        tutorialBubble("اضغط هنا لمعرفة المؤشرات")
//                            .offset(x: 80, y: 500)
//                        
//                    case 3:
//                        tutorialBubble("من هنا تستطيع شراء وبيع الأسهم")
//                            .offset(x: 0, y: 680)
//                        
//                    case 4:
//                        
//                        ZStack {
//                            
//                            Color.black.opacity(0.35)
//                                .ignoresSafeArea()
//                            
//                            VStack(spacing: 28) {
//                                
//                                
//                                Text("الآن يمكنك التداول، جرّب بنفسك")
//                                    .font(.title3)
//                                    .fontWeight(.bold)
//                                    .foregroundColor(.white)
//                                
//                                PrimaryButton(title: "ابدأ") {
//                                    
//                                    hasCompletedTutorial = true
//                                    
//                                    dismiss()
//                                }
//                                .frame(width: 220)
//                            }
//                            .padding(.vertical, 40)
//                            .padding(.horizontal, 35)
//                            .background(
//                                RoundedRectangle(cornerRadius: 35)
//                                    .fill(Color.black.opacity(0.9))
//                            )
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 35)
//                                    .stroke(Color.white.opacity(0.2))
//                            )
//                        }
//                        
//                    default:
//                        EmptyView()
//                    }
//                    
//                    Spacer()
//                }
//                .zIndex(999)
//            }
            
            
            if showSuccessBanner {
                
                VStack {
                    
                    HStack {
                        
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        
                        Text(bannerMessage)
                            .foregroundColor(.white)
                        
                        Spacer()
                    }
                    .padding()
                    .background(Color.black.opacity(0.95))
                    .cornerRadius(16)
                    .padding(.horizontal,20)
                    .padding(.top,10)
                    
                    Spacer()
                }
                .zIndex(999)
            }
            
            if showSuccessToast {

                VStack {

                    HStack(spacing: 14) {

                        Button {
                            showSuccessToast = false
                        } label: {

                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .semibold))
                        }

                        Spacer()

                        Text(toastMessage)
                            .foregroundColor(.white)
                            .font(.system(size: 13))

                        ZStack {
                            Circle()
                                .fill(isSuccessToast ? Color.green.opacity(0.19) : Color.red.opacity(0.19))
                                .frame(width: 26, height: 26)

                            Image(systemName: isSuccessToast ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(isSuccessToast ? Color(red: 65/255, green: 233/255, blue: 112/255) : .red)
                                .font(.system(size: 18))
                        }
                    }
                    .padding(.horizontal, 18)
                    .frame(height: 59)
                    .background(Color.black.opacity(0.95))
                    .cornerRadius(12)
                    .padding(.horizontal, 17)
                    .padding(.top, 50)

                    Spacer()
                }
                .zIndex(999)
            }
            
            VStack(alignment: .trailing){
                
                //MARK: - header
                HStack{
                    
                    NavigationLink {
                        WalletView()
                            .environmentObject(walletState)
                    } label: {
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 900)
                                .fill(.black)
                                .frame(width: 100, height: 44)
                                .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0, y: 0.1)
                                .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.1)
                            
                            HStack(spacing: 8) {
                                
                                Image("wallet")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30,alignment: .leading)
                                
                                Text(arabicNumber(Int(walletState.balance)))                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                                    .frame(alignment: .center)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        
                        ZStack{
                            Circle()
                                .fill(Color.black)
                                .frame(width: 44, height: 44)
                                .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0, y: 0.1)
                                .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.1)
                                
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.white)
                                        .font(.system(size: 22, weight: .medium))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                
                Spacer().frame(height: 42)
                
                //MARK: - CompanyDetails
                
                HStack(spacing: 12) {
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        
                        Text(companyNameArabic(company.fakeName))
                            .font(.system(size: 14,weight: .bold))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(sectorArabicNew(company.sector))
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                    
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 40, height: 40)
                        .overlay(
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
                            .frame(width: 40, height: 40)
                        )
                }//h
                
                Spacer().frame(height: 20)
                
                HStack {
                    
                    Text(arabicNumerals(company.stock.changePercent >= 0
                        ? "+\(String(format: "%.2f", company.stock.changePercent))%"
                        : "\(String(format: "%.2f", company.stock.changePercent))%"))
                    .foregroundColor(
                        company.stock.changePercent >= 0
                        ? .green
                        : .red
                                    ).font(.system(size: 12,weight: .semibold))
                    
                    Text(arabicNumerals("\(Int(company.stock.currentPrice))"))
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom)
                }
                .frame(width: 120,height: 50)
                
                    //MARK: - picker
                    
                VStack(alignment: .center,spacing: 16) {

                    HStack(spacing: 0) {
                        
                        ForEach(periods, id: \.self) { item in
                            
                            Button {
                                selectedPeriod = item
                            } label: {
                                
                                Text(item)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(selectedPeriod == item ? .white : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                            }
                        }
                    }
                    .frame(width: 360, height: 36)
                    .background(
                        
                        ZStack {
                            // الخلفية الأساسية
                            RoundedRectangle(cornerRadius: 900)
                                .fill(Color.black.opacity(0.1))
                            
                            // الـ indicator المتحرك
                            GeometryReader { geo in
                                
                                RoundedRectangle(cornerRadius: 18)
                                    .fill(Color.black.opacity(1))
                                    .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0.2, y: 0.2)
                                    .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.1)
                                    .frame(width: geo.size.width / 4)
                                    .offset(
                                        x: CGFloat(periods.firstIndex(of: selectedPeriod) ?? 0)
                                        * (geo.size.width / 4)
                                    )
                                    .animation(.easeInOut(duration: 0.2), value: selectedPeriod)
                            }.padding(.vertical,4)
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 900))
                    
                    //MARK: - Chart
                    
                    StockChartContainer(
                        prices: selectedPrices,
                        selectedPeriod: selectedPeriod
                    ).frame(width: 390 ,height: 220)
                   
                    //MARK: - infoButton
                    
                    Button {
                        showInfo = true
                    } label: {

                        ZStack {

                            Circle()
                                .fill(Color.black)
                                .frame(width: 22, height: 22)
                                .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.2)
                                .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.2)

                            Text("!")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }.offset(x: 180) // إذا تبينها يمين شوي
                    
                    //MARK: - Summry
                    
                    HStack(alignment: .top, spacing: 16) {
                        
                        VStack(alignment: .trailing, spacing: 16) {
                            
                            summryRow(title: "الكمية المتداولة", value: "...")
                            summryRow(title: "القيمة المتداولة", value: "...")
                        }
                        
                        Divider()
                            .frame(height: 80)
                            .background(Color.white.opacity(0.2))
                        
                        VStack(alignment: .trailing, spacing: 16) {
                            
                            summryRow(title: "إغلاق سابق", value: "...")
                            summryRow(title: "عدد الصفقات", value: "...")
                            summryRow(title: "متوسط الصفقة", value: "...")
                        }
                        
                        Divider()
                            .frame(height: 80)
                            .background(Color.white.opacity(0.2))
                        
                        VStack(alignment: .trailing, spacing: 16) {
                            
                            summryRow(title: "افتتاح", value: "...")
                            summryRow(title: "الأعلى", value: "...")
                            summryRow(title: "الأدنى", value: "...")
                        }
                    }
                   
                }//vFromPicker
                
                Spacer().frame(height: 86)
                
                    //MARK: - Tadawl
                    
                    //Button
                    PrimaryButton(title: "تداول") {
                        showTradeSheet = true
                    }.frame(maxWidth:.infinity,alignment: .center)
                    
                    //sheet
                    .sheet(isPresented: $showTradeSheet) {

                        TradeSheetView(
                            company: company,
                            vm: vm,
                            onSuccess: { message in
                                toastMessage = message
                                isSuccessToast = !message.contains("غير كافية") && !message.contains("ما عندك")
                                showSuccessToast = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    showSuccessToast = false
                                }
                            },
                            onBalanceChanged: { amount in
                                walletState.balance += amount
                            }
                        )
                        
                        .presentationDetents([.height(650)])
                        .presentationBackground(.black)
                    }
                    
                
                //MARK: - InfoSheet
                
                .sheet(isPresented: $showInfo) {
                    
                    
                    VStack(spacing: 24) {
                        
                        Capsule()
                            .fill(Color(hex: "929292"))
                            .frame(width: 36, height: 4)
                            .padding(.top, 12)
                            .presentationBackground(.black)
                        
                        Text("معلومات")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white)
                        
                        ScrollView {
                            
                            VStack(alignment: .trailing, spacing: 22) {
                                
                                (
                                    Text("• إغلاق سابق: ")
                                        .foregroundColor(Color(red: 0.60, green: 0.69, blue: 0.94))
                                        .fontWeight(.semibold)
                                    +
                                    Text("آخر سعر بيع به السهم بنهاية يوم التداول الأمس.")
                                        .foregroundColor(.white)
                                )
                                .font(.system(size: 18))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                
                                (
                                    Text("• إفتتاح: ")
                                        .foregroundColor(Color(red: 0.60, green: 0.69, blue: 0.94))
                                        .fontWeight(.semibold)
                                    +
                                    Text("أول سعر بدأ به السهم قيمته مع بداية تداول اليوم.")
                                        .foregroundColor(.white)
                                )
                                .font(.system(size: 18))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                (
                                    Text("• الأعلى: ")
                                        .foregroundColor(Color(red: 0.60, green: 0.69, blue: 0.94))
                                        .fontWeight(.semibold)
                                    +
                                    Text("أعلى قيمة سعرية وصل إليها السهم خلال جلسة اليوم.")
                                        .foregroundColor(.white)
                                )
                                .font(.system(size: 18))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                (
                                    Text("• الأدنى: ")
                                        .foregroundColor(Color(red: 0.60, green: 0.69, blue: 0.94))
                                        .fontWeight(.semibold)
                                    +
                                    Text("أقل قيمة سعرية هبط إليها السهم خلال جلسة اليوم.")
                                        .foregroundColor(.white)
                                )
                                .font(.system(size: 18))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                (
                                    Text("• عدد الصفقات: ")
                                        .foregroundColor(Color(red: 0.60, green: 0.69, blue: 0.94))
                                        .fontWeight(.semibold)
                                    +
                                    Text("مجموع عمليات البيع والشراء الناجحة التي تمت اليوم.")
                                        .foregroundColor(.white)
                                )
                                .font(.system(size: 18))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                (
                                    Text("• متوسط كمية الصفقة: ")
                                        .foregroundColor(Color(red: 0.60, green: 0.69, blue: 0.94))
                                        .fontWeight(.semibold)
                                    +
                                    Text("معدل عدد الأسهم المتبادلة في العملية الواحدة.")
                                        .foregroundColor(.white)
                                )
                                .font(.system(size: 18))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                (
                                    Text("• الكمية المتداولة: ")
                                        .foregroundColor(Color(red: 0.60, green: 0.69, blue: 0.94))
                                        .fontWeight(.semibold)
                                    +
                                    Text("إجمالي عدد الأسهم التي تم تداولها بين البائعين والمشترين اليوم.")
                                        .foregroundColor(.white)
                                )
                                .font(.system(size: 18))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)

                                (
                                    Text("• القيمة المتداولة: ")
                                        .foregroundColor(Color(red: 0.60, green: 0.69, blue: 0.94))
                                        .fontWeight(.semibold)
                                    +
                                    Text("مجموع المبالغ المالية والكاش التي دفعت في كل صفقات اليوم.")
                                        .foregroundColor(.white)
                                )
                                .font(.system(size: 18))
                                .multilineTextAlignment(.trailing)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .padding(.horizontal, 28)
                            .padding(.bottom, 30)
                        }
                    }
                    .presentationDetents([.height(585)])
                    .presentationCornerRadius(40)
                    .presentationBackground(
                        Color.black.opacity(0.2)
                    )
                }//endOfSheet
                
            }//vMain
            .safeAreaPadding(.horizontal, 16)
            
        }//zMain
        
        .onAppear {
            
            
            detailTutorialStep = 0
            
            guard !hasCompletedTutorial else { return }
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in
                
                if detailTutorialStep < 4 {
                    
                    detailTutorialStep += 1
                    
                } else {
                    
                    timer.invalidate()
                }
            }
        }
    }
    
    var selectedPrices: [Double] {

        switch selectedPeriod {

        case "أسبوع":
            return company.chartData.timeframes.oneWeek.map { $0.price }

        case "شهر":
            return company.chartData.timeframes.oneMonth.map { $0.price }

        case "سنة":
            return company.chartData.timeframes.oneYear.map { $0.price }

        default:
            return company.chartData.timeframes.oneDay.map { $0.price }
        }
    }
    
    
}

@ViewBuilder
func summryRow(title: String, value: String) -> some View {
    
    HStack {
        
        Text(value)
            .font(.system(size: 10, weight: .regular))
            .foregroundColor(.white.opacity(0.9))
            .frame(width: 30, alignment: .leading)
        
        Spacer()
        
        Text(title)
            .font(.system(size: 10, weight: .regular))
            .frame(width: 70, alignment: .trailing)
            .foregroundColor(.gray)
    }
}


func xLabels(for period: String) -> [String] {
    
    switch period {
        
    case "يوم":
        return ["١١ص","١٠ص","٩ص","٨ص","٧ص","٦ص"]
        
    case "اسبوع":
        return ["جمعة","خميس","اربعاء","ثلاثاء","اثنين","سبت"]
        
    case "شهر":
        return ["الاسبوع٤","الاسبوع٣","الاسبوع٢","الاسبوع١"]
        
    case "سنه":
        return ["رجب","جماد٢","جماد١","ربيع١","صفر","محرم"]
        
    default:
        return []
    }
}

struct GridBackground: View {
    
    var body: some View {
        
        GeometryReader { geo in
            
            Path { path in
                
                let rows = 4
                let cols = 6
                
                let rowHeight = geo.size.height / CGFloat(rows)
                let colWidth = geo.size.width / CGFloat(cols)
                
                // horizontal lines
                for i in 0...rows {
                    let y = CGFloat(i) * rowHeight
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geo.size.width, y: y))
                }
                
                // vertical lines
                for i in 0...cols {
                    let x = CGFloat(i) * colWidth
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geo.size.height))
                }
            }
            .stroke(Color.white.opacity(0.06), lineWidth: 1)
        }
    }
}

struct SimpleStockChart: View {
    
    let prices: [Double]
    
    var body: some View {
        
        GeometryReader { geo in
            
            let width = geo.size.width
            let height = geo.size.height
            
            let maxPrice = prices.max() ?? 1
            let minPrice = prices.min() ?? 0
            let range = maxPrice - minPrice
            
            ZStack {
                
                // GRID فقط
                GridBackground()
                
                // LINE
                Path { path in
                    
                    for i in prices.indices {
                        
                        let x = width * CGFloat(i) / CGFloat(prices.count - 1)
                        let y = height - CGFloat((prices[i] - minPrice) / range) * height
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.green, lineWidth: 2)
                
                // FILL
                Path { path in
                    
                    for i in prices.indices {
                        
                        let x = width * CGFloat(i) / CGFloat(prices.count - 1)
                        let y = height - CGFloat((prices[i] - minPrice) / range) * height
                        
                        if i == 0 {
                            path.move(to: CGPoint(x: x, y: height))
                            path.addLine(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                    
                    path.addLine(to: CGPoint(x: width, y: height))
                    path.closeSubpath()
                }
                .fill(
                    LinearGradient(
                        colors: [
                            Color.green.opacity(0.3),
                            Color.green.opacity(0.0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
            }
        }
    }
}

struct StockChartContainer: View {
    
    let prices: [Double]
    let selectedPeriod: String
    
    var body: some View {
        
        VStack(spacing: 8) {
            
            HStack(spacing: 8) {
                
                SimpleStockChart(
                    prices: prices
                )
                .frame(maxWidth: .infinity)
                
                VStack {
                    
                    let max = prices.max() ?? 1
                    let min = prices.min() ?? 0
                    let step = (max - min) / 3
                    
                    ForEach(0..<4) { i in
                        
                        Spacer()
                        
                        Text(arabicNumerals(String(format: "%.0f", max - step * Double(i))))
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 35)
            }
            
            HStack {
                
                ForEach(xLabels(for: selectedPeriod), id: \.self) { label in
                    
                    Text(label)
                        .font(.caption2)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }
    }
}
