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
            
            if !hasCompletedTutorial {
                
                Color.black.opacity(0.65)
                    .ignoresSafeArea()
                
                VStack {
                    
                    switch detailTutorialStep {
                        
                    case 0:
                        tutorialBubble("هذا سعر السهم الحالي")
                            .offset(x: 95, y: 105)
                        
                    case 1:
                        tutorialBubble("هنا يمكنك متابعة حركة السهم")
                            .offset(x: 0, y: 310)
                        
                    case 2:
                        tutorialBubble("اضغط هنا لمعرفة المؤشرات")
                            .offset(x: 80, y: 500)
                        
                    case 3:
                        tutorialBubble("من هنا تستطيع شراء وبيع الأسهم")
                            .offset(x: 0, y: 680)
                        
                    case 4:
                        
                        ZStack {
                            
                            Color.black.opacity(0.35)
                                .ignoresSafeArea()
                            
                            VStack(spacing: 28) {
                                
                                
                                Text("الآن يمكنك التداول، جرّب بنفسك")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                PrimaryButton(title: "ابدأ") {
                                    
                                    hasCompletedTutorial = true
                                    
                                    dismiss()
                                }
                                .frame(width: 220)
                            }
                            .padding(.vertical, 40)
                            .padding(.horizontal, 35)
                            .background(
                                RoundedRectangle(cornerRadius: 35)
                                    .fill(Color.black.opacity(0.9))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 35)
                                    .stroke(Color.white.opacity(0.2))
                            )
                        }
                        
                    default:
                        EmptyView()
                    }
                    
                    Spacer()
                }
                .zIndex(999)
            }
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
            VStack(spacing: 0) {
                HStack {
                    
                    NavigationLink {
                        WalletView()
                            .environmentObject(walletState)
                    } label: {
                        
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 900)
                                .fill(Color.black.opacity(0.55))
                                .frame(width: 112, height: 52)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 900)
                                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                                )
                            HStack(spacing: 8) {
                                
                                Image("wallet")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 30, height: 30)
                                
                                Text("\(Int(walletState.balance))")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        dismiss()
                    } label: {
                        
                        Circle()
                            .fill(Color.black.opacity(0.2))
                            .frame(width: 52, height: 52)
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                            .overlay(
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.white)
                                    .font(.system(size: 22, weight: .regular))
                            )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 10)
                
                HStack(spacing: 12) {
                    
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 60, height: 60)
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
                            .frame(width: 60, height: 60)
                        )
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        
                        Text(company.fakeName)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(sectorArabicNew(company.sector))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal,24)
                .padding(.top,20)
                .environment(\.layoutDirection, .rightToLeft)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal,24)
                .padding(.top,12)
                
                
                
                HStack {
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        
                        Text("\(Int(company.stock.currentPrice))")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(
                            company.stock.changePercent >= 0
                            ? "+\(String(format: "%.2f", company.stock.changePercent))%"
                            : "\(String(format: "%.2f", company.stock.changePercent))%"
                        )
                        .foregroundColor(.green)
                        .font(.title3)
                    }
                }
                .padding(.horizontal,24)
                .padding(.top,0)
                
                VStack(spacing: 16) {
                    
                    HStack(spacing: 16) {

                        ForEach(["سنه", "شهر","اسبوع", "يوم"], id: \.self) { period in

                            Button {

                                selectedPeriod = period

                            } label: {

                                Text(period)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(
                                        selectedPeriod == period
                                        ? .white
                                        : .gray
                                    )
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 8)
                                    .background(
                                        selectedPeriod == period
                                        ? Color.white.opacity(0.15)
                                        : Color.clear
                                    )
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.white)
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.black.opacity(0.15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.white.opacity(0.08))
                            )
                        
                        MarketBigChartView(
                            prices: selectedPrices
                        )
                        .padding()
                        
                    }
                    .frame(height: 200)
                    .padding(.bottom, 10)
                    
                    //                    Spacer()
                    Button {
                        showInfo = true
                    } label: {

                        ZStack {

                            Circle()
                                .fill(Color.black.opacity(0.2))
                                .frame(width: 22, height: 22)

                            Text("!")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }
                    .offset(x: 180) // إذا تبينها يمين شوي
                    HStack(alignment: .top, spacing: 24)
                    
                    {
                        
                        statisticsColumn(
                            values: ["٠٠،٠٠", "٠٠،٠٠"],
                            titles: ["الكمية المتداولة", "القيمة المتداولة"]
                        )
                        
                        Divider()
                            .frame(height: 80)
                        
                        statisticsColumn(
                            values: ["٠٠،٠٠", "٠٠،٠٠", "٠٠،٠٠"],
                            titles: ["إغلاق سابق", "عدد الصفقات", "متوسط كمية\nالصفقة"]
                        )
                        
                        Divider()
                            .frame(height: 80)
                        statisticsColumn(
                            values: ["٠٠،٠٠", "٠٠،٠٠", "٠٠،٠٠"],
                            titles: ["إفتتاح", "الأعلى", "الأدنى"]
                        )
                        
                    
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    Divider()
                        .background(Color.white.opacity(0.08))
                        .padding(.horizontal, 24)
                        .padding(.top, 12)
                    PrimaryButton(title: "تداول") {
                        showTradeSheet = true
                    }
                    .padding(.horizontal, 18)
                    .padding(.top, 25)
                    .offset(y: -25)
                    .cornerRadius(60)
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
                        
                        .presentationDetents([.height(730)])
                        .presentationBackground(.black)
                    }
                    
                }
                .padding(.horizontal,18)
                .padding(.top,30)
                
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
                }
                
                
                
                
                
            }
            
        }
        
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
    @ViewBuilder
    func statisticsColumn(
        values: [String],
        titles: [String]
    ) -> some View {
        
        VStack(alignment: .trailing, spacing: 16) {
            
            ForEach(0..<titles.count, id: \.self) { index in
                
                HStack(spacing: 8) {
                    
                    Text(values[index])
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(titles[index])
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.trailing)
                }
            }
        }
    }
    
    
    
    
    
}

