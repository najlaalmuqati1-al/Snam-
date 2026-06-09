import SwiftUI

struct CompanyDetailViewV2: View {
    
    let company: Company
    @ObservedObject var vm: MarketViewModelNew
    @State private var showTradeSheet = false
    @State private var showInfo = false
    @State private var showSuccessBanner = false
    @State private var bannerMessage = ""
    @State private var hasSeenDetailTutorial = false
    @State private var detailTutorialStep = 0
    @Environment(\.dismiss) var dismiss
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
            
            if !hasSeenDetailTutorial {
                
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
                                    hasSeenDetailTutorial = true

                                        dismiss()

                                    hasSeenDetailTutorial = true

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
            
            VStack(spacing: 0) {
                HStack {

                    NavigationLink {
                        WalletView()
                    } label: {

                        Image("wallet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 44)
                    }

                    Spacer()

                    Button {
                        dismiss()
                    } label: {

                        Circle()
                            .fill(Color.white.opacity(0.08))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(systemName: "chevron.right")
                                    .font(.title2)
                                    .foregroundColor(.white)
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
                            Text(company.icon)
                                .font(.title2)
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
                    
                    HStack(spacing: 20) {
                        
                        Text("١ي")
                        Text("١ش")
                        Text("٣ش")
                        Text("٦ش")
                        Text("١س")
                        Text("٣س")
                        
                        Text("اي")
                            .padding(.horizontal,12)
                            .padding(.vertical,6)
                            .background(Color.white.opacity(0.15))
                            .clipShape(Capsule())
                        
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
                            prices: company.chartData.timeframes.oneDay.map { $0.price }
                        )
                        .padding()
                        
                    }
                    .frame(height: 200)
                    .padding(.bottom, 10)
                    
                    //                    Spacer()
                    HStack {
                        
                        Spacer()
                        
                        Button {
                            showInfo = true
                        } label: {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.title2)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal,24)
                    HStack(alignment: .top) {
                        
                        VStack(alignment: .trailing, spacing: 16) {
                            
                            Text("إفتتاح")
                            Text("الأعلى")
                            Text("الأدنى")
                            
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .center, spacing: 16) {
                            
                            Text("إغلاق سابق")
                            Text("عدد الصفقات")
                            Text("متوسط كمية الصفقة")
                            
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 16) {
                            
                            Text("الكمية المتداولة")
                            Text("القيمة المتداولة")
                            Text("القيمة السوقية")
                            
                        }
                    }
                    .padding(.horizontal, 28)
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
                            vm: vm
                        )
                        .presentationDetents([.height(670)])
                        .presentationBackground(.black)
                    }
                    
                }
                .padding(.horizontal,18)
                .padding(.top,30)
                
                .sheet(isPresented: $showInfo) {
                    
                    VStack(spacing: 20) {
                        
                        Capsule()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 50, height: 5)
                            .padding(.top)
                        
                        Text("معلومات المؤشرات")
                            .font(.headline)
                            .foregroundColor(.white)
                        
                        VStack(alignment: .trailing, spacing: 14) {
                            
                            Text("إفتتاح: أول سعر تداول في الجلسة")
                            Text("الأعلى: أعلى سعر وصل له السهم")
                            Text("الأدنى: أقل سعر وصل له السهم")
                            Text("إغلاق سابق: سعر إغلاق الجلسة السابقة")
                            Text("عدد الصفقات: إجمالي الصفقات المنفذة")
                            Text("متوسط كمية الصفقة: متوسط الأسهم بكل صفقة")
                            Text("الكمية المتداولة: إجمالي الأسهم المتداولة")
                            Text("القيمة المتداولة: إجمالي قيمة التداول")
                            
                        }
                        .foregroundColor(.white.opacity(0.8))
                        .padding()
                        
                        Spacer()
                        
                    }
                    .presentationDetents([.medium])
                    .presentationBackground(.black)
                
            
        
            
            
    
    }
    
  }
}
.onAppear {

guard !hasSeenDetailTutorial else { return }

    Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { timer in

        if detailTutorialStep < 4 {

            detailTutorialStep += 1

        } else {

            timer.invalidate()
        }
    }
}
}
}
    

    

