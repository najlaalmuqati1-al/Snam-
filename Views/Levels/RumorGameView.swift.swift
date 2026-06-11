
import SwiftUI

struct RumorGameView: View {
    
    @StateObject private var vm = MarketViewModelNew()
    @State private var company: Company?
    @State private var showSuccess = false
    @State private var showFailure = false
    
    var body: some View {
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
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.green)
                    
                    Text("توقعك صح")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("ارتفع سعر السهم زي ما توقعت")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(red: 43/255, green: 64/255, blue: 117/255).opacity(0.2))
                        .frame(height: 92)
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
                        .fill(Color(red: 43/255, green: 64/255, blue: 117/255).opacity(0.2))
                        .frame(height: 119)
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
                    PrimaryButton(title: "خلصت") {
                        
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 24)
                }
            }
        } else if showFailure {
            
            
        } else {
            
            VStack(spacing: 24) {
                
                // الهيدر
                Text("لفل ٢")
                    .font(.title)
                    .foregroundColor(.white)
                
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
                                
                                Text(company.icon)
                                    .font(.system(size: 30))
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
                        .frame(width: 145, height: 60)
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
                        .frame(width: 145, height: 60)
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
                        )
                    }
                }
                .padding(.top, 16)
                
            }
            .onAppear {
                
                company = vm.marketData?.companies.randomElement()
            }
        }
    }
}
    #Preview {
        RumorGameView()
    }
    
    

