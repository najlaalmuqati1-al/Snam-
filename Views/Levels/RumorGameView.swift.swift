
import SwiftUI

struct RumorGameView: View {
    
    @StateObject private var vm = MarketViewModelNew()
    @State private var company: Company?
    @State private var showSuccess = false
    @State private var showFailure = false
    @State private var showRumorPopup = true
    @Environment(\.dismiss) private var dismiss
    @AppStorage("selectedTab") private var selectedTab: Int = 2
    @EnvironmentObject var walletState: WalletState

    @State private var showReward = false
    @StateObject private var rewardVM = PortfolioViewModel()
    
    var body: some View {
        ZStack {
            if showSuccess {
                VStack(spacing: 28) {
                    
                    ZStack {
                        
                        Circle()
                            .fill(Color.green.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "checkmark")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.green)
                    }
                    
                    VStack(spacing: 12) {
                        
                        Text("كفو عليك!")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.green)
                        
                        Text("توقعك صح")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("ارتفع سعر السهم زي ما توقعت")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.15))
                            .frame(height: 92)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                            .overlay {
                                
                                HStack {
                                    
                                    VStack(spacing: 8) {
                                        
                                        Text("التغيير")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Text("+9.99")
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundColor(.green)
                                    }
                                    
                                    Spacer()
                                    
                                    Divider()
                                        .frame(height: 50)
                                        .background(Color.gray.opacity(0.5))
                                    
                                    Spacer()
                                    
                                    VStack(spacing: 8) {
                                        
                                        Text("السعر الحين")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                        
                                        Text("1.23")
                                            .font(.system(size: 28, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal, 40)
                            }
                            .padding(.horizontal, 16)
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.15))
                            .frame(height: 92)
                            .overlay(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.white.opacity(0.15), lineWidth: 1)
                            )
                            .overlay {
                                HStack {
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 6) {
                                        
                                        Text("السبب")
                                            .font(.system(size: 16, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Text("ارتفاع أسعار النفط وزيادة الطلب العالمي أثر في ارتفاع أرباح الشركة")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                            .multilineTextAlignment(.trailing)
                                    }
                                    
                                    Image(systemName: "fuelpump.fill")
                                        .font(.system(size: 48))
                                        .foregroundColor(
                                            Color(
                                                red: 109/255,
                                                green: 144/255,
                                                blue: 229/255
                                            )
                                        )
                                }
                                .padding(.horizontal, 24)
                                .padding(.horizontal, 24)
                            }
                            .padding(.horizontal, 16)
                        PrimaryButton(title: "انتهيت") {
                            showReward = true
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 24)
                        .fullScreenCover(isPresented: $showReward) {

                            PortfolioCongratsView(
                                vm: rewardVM,
                                onFinished: {

                                    walletState.collectReward(forLevel: 3)

                                    selectedTab = 2
                                    dismiss()
                                }
                            )
                        }
                    }
                }
                
            } else if showFailure {
                VStack(spacing: 28) {
                    
                    ZStack {
                        
                        Circle()
                            .fill(Color.red.opacity(0.2))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "xmark")
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(.red)
                    }
                    
                    VStack(spacing: 12) {
                        
                        Text("ما جبتها صح")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(.red)
                        
                        Text("توقعك مو بمحله")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text("انخفض سعر السهم عكس توقعك")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black.opacity(0.15))
                        .frame(height: 92)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .overlay {
                            
                            HStack {
                                
                                VStack(spacing: 8) {
                                    
                                    Text("التغيير")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Text("-1.23")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.red)
                                }
                                
                                Spacer()
                                
                                Divider()
                                    .frame(height: 50)
                                    .background(Color.gray.opacity(0.5))
                                
                                Spacer()
                                
                                VStack(spacing: 8) {
                                    
                                    Text("السعر الحين")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                    
                                    Text("9.99")
                                        .font(.system(size: 28, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 40)
                        }
                        .padding(.horizontal, 16)
                    
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.black.opacity(0.15))
                        .frame(height: 92)
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(Color.white.opacity(0.15), lineWidth: 1)
                        )
                        .overlay {
                            
                            HStack {
                                
                                Spacer()
                                
                                VStack(alignment: .trailing, spacing: 6) {
                                    
                                    Text("السبب")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("على الرغم من ارتفاع النفط إلا أن توقعات الأرباح كانت أقل من المتوقع")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.trailing)
                                }
                                
                                Image(systemName: "fuelpump.fill")
                                    .font(.system(size: 48))
                                    .foregroundColor(
                                        Color(
                                            red: 109/255,
                                            green: 144/255,
                                            blue: 229/255
                                        )
                                    )
                            }
                            .padding(.horizontal, 24)
                        }
                        .padding(.horizontal, 16)
                    
                    PrimaryButton(title: "جرب مرة ثانية") {
                        
                        showFailure = false
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                }
                
                
            } else {
                
                VStack(spacing: 24) {
                    
                    
                    
                    // السؤال
                    VStack(alignment: .trailing, spacing: 4) {
                        
                        Text("من إشاعة اليوم والرسم البياني وش تتوقع تكون حالة السهم بكرة؟")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.trailing)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, 20)
                    
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black.opacity(0.2))
                        
                        if let company = company {
                            
                            VStack(spacing: 16) {
                                
                                // الهيدر
                                HStack(spacing: 8) {
                                    
                                    Spacer()
                                    
                                    VStack(alignment: .trailing, spacing: 4) {
                                        
                                        Text(company.fakeName)
                                            .font(.system(size: 14, weight: .bold))
                                            .foregroundColor(.white)
                                        
                                        Text(sectorArabicNew(company.sector))
                                            .font(.system(size: 10))
                                            .foregroundColor(.gray)
                                    }
                                    
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
                                }
                                .environment(\.layoutDirection, .leftToRight)
                                
                                // السعر
                                HStack {
                                    
                                    Spacer()
                                    
                                    HStack(alignment: .bottom, spacing: 12) {
                                        
                                        Text(
                                            company.stock.changePercent >= 0
                                            ? "+\(String(format: "%.1f", company.stock.changePercent))%"
                                            : "\(String(format: "%.1f", company.stock.changePercent))%"
                                        )
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(
                                            company.stock.changePercent >= 0
                                            ? .green
                                            : .red
                                        )
                                        
                                        Text("\(company.stock.currentPrice, specifier: "%.2f")")
                                            .font(.system(size: 20, weight: .bold))
                                            .foregroundColor(.white)
                                    }
                                    .environment(\.layoutDirection, .leftToRight)
                                }
                                
                                MarketBigChartView(
                                    prices: company.chartData.timeframes.oneDay.map {
                                        $0.price
                                    }
                                )
                                .frame(height: 140)
                                .padding(.top, 8)
                            }
                            .padding(16)
                        }
                    }
                    .frame(width: 358, height: 309)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.1))
                    )
                    .frame(width: 358, height: 309)
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.white.opacity(0.1))
                        
                    )
                    HStack(spacing: 24) {
                        
                        Button {
                            
                            if let company = company {
                                
                                if company.stock.changePercent < 0 {
                                    showSuccess = true
                                    showFailure = false
                                } else {
                                    showFailure = true
                                    showSuccess = false
                                }
                            }
                            
                        } label: {
                            
                            HStack(spacing: 12) {
                                
                                Image(systemName: "chart.line.downtrend.xyaxis")
                                
                                Text("ينزل")
                            }
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 130, height: 50)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.98, green: 0.35, blue: 0.32),
                                        Color(red: 0.93, green: 0.25, blue: 0.22)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.2))
                                    .glassEffect()
                                    .opacity(0.5)
                            )
                        }
                        
                        Button {
                            
                            if let company = company {
                                
                                if company.stock.changePercent >= 0 {
                                    showSuccess = true
                                    showFailure = false
                                } else {
                                    showFailure = true
                                    showSuccess = false
                                }
                            }
                            
                        } label: {
                            
                            HStack(spacing: 12) {
                                
                                Image(systemName: "chart.line.uptrend.xyaxis")
                                
                                Text("يرتفع")
                                
                            }
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 130, height: 50)
                            .background(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.20, green: 0.80, blue: 0.38),
                                        Color(red: 0.12, green: 0.70, blue: 0.28)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(Capsule())
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.2))
                                    .glassEffect()
                                    .opacity(0.5)
                            )
                        }
                    }
                    .padding(.top, 16)
                    
                }
                .onAppear {
                    company = vm.marketData?.companies.randomElement()
                }
                
                if showRumorPopup {
                    
                    Color.black.opacity(0.85)
                        .ignoresSafeArea()
                    
                    VStack(spacing: 32) {
                        
                        Text("إشاعات اليوم")
                            .font(.system(size: 34, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Image(systemName: "fuelpump.fill")
                            .font(.system(size: 84))
                            .foregroundColor(
                                Color(red: 109/255,
                                      green: 144/255,
                                      blue: 229/255)
                                
                            )
                        
                        VStack(spacing: 12) {
                            
                            Text("ارتفاع أسعار النفط وزيادة الطلب")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text("ارتفعت أسعار النفط بسبب زيادة الطلب من الدول الكبرى، مما يعزز أرباح أرامكو ويتوقع أن يؤثر إيجابياً على سعر السهم.")
                                .font(.system(size: 18))
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        
                        
                        PrimaryButton(title: "حسنًا") {
                            showRumorPopup = false
                        }
                    }
                    
                    .padding(32)
                    .frame(width: 353, height: 428)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.black.opacity(0.45))
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(
                                        Color.white.opacity(0.15),
                                        lineWidth: 1
                                    )
                            )
                   
                    )
                    
                }
            
               
                
            }// نهاية الـ ZStack
        } // نهاية body
    } // نهاية RumorGameView
}
//    #Preview {
//        RumorGameView()
//    }
#Preview {
    AppContainerView {
        RumorGameView()
            .environmentObject(WalletState())
    }
}
    

//تمممممممتتت المعلومات✌🏻


// ====== التعديلات المطلوبة ======
// ١. أضيف فوق body:
// @Environment(\.dismiss) private var dismiss
// @AppStorage("selectedTab") private var selectedTab: Int = 2
// @State private var showReward = false
// @StateObject private var rewardVM = PortfolioViewModel()

// ٢. زر الانتهاء:
// PrimaryButton(title: "انتهيت") {
//     showReward = true
// }

// ٣. آخر شيء داخل ZStack قبل قفل القوس:
// if showReward {
//     PortfolioCongratsView(vm: rewardVM, onFinished: {
//         selectedTab = 2
//         dismiss()
//     })
//     .transition(.opacity.combined(with: .scale))
// }

// ٤. على الـ ZStack الرئيسي:
// .animation(.easeInOut(duration: 0.4), value: showReward)
// ================================

// ============================================================
// تعليمات إضافة النافيقيشن وتحديث الرصيد للمراحل الجديدة
// ============================================================
//
// الخطوات المطلوبة في كل مرحلة جديدة:
//
// 1️⃣ أضيفي هذه المتغيرات فوق الـ body:
//
//    @Environment(\.dismiss) private var dismiss
//    @AppStorage("selectedTab") private var selectedTab: Int = 2
//    @EnvironmentObject var walletState: WalletState
//    @State private var showReward = false
//    @StateObject private var rewardVM = PortfolioViewModel()
//
// 2️⃣ زر الانتهاء يكون كذا:
//
//    PrimaryButton(title: "انتهيت") {
//        showReward = true
//    }
//
// 3️⃣ آخر شيء داخل الـ ZStack الرئيسي قبل قفل القوس:
//
//    if showReward {
//        PortfolioCongratsView(vm: rewardVM, onFinished: {
//            walletState.collectReward(forLevel: X) // ← غيري X برقم المرحلة
//            selectedTab = 2
//            dismiss()
//        })
//        .transition(.opacity.combined(with: .scale))
//    }
//
// 4️⃣ على الـ ZStack الرئيسي أضيفي:
//
//    .animation(.easeInOut(duration: 0.4), value: showReward)
//
// 5️⃣ عدّلي الـ Preview:
//
//    #Preview {
//        YourLevelView()
//            .environmentObject(WalletState())
//    }
//
// ⚠️ مهم: غيري X في collectReward(forLevel: X) برقم المرحلة الصحيح
//    المرحلة الثالثة  → forLevel: 3
//    المرحلة الرابعة → forLevel: 4
// ============================================================
