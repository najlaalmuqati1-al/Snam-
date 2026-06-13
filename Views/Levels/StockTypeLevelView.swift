// لمن يتوسع خلي البوتن ( السهم المضارب - الامن ) ظاهرة شوي من ورا بحيث يبان انه يقدر يضغط بس ويرجع لهم
// تعديل متعلق باللوجك 
//  StockTypeLevelView.swift
//  Snam
//
//  Created by Najla Almuqati on 25/12/1447 AH.
//
import SwiftUI

struct StockTypeLevelView: View {
    @State private var currentStep = 1
    @State private var selectedCard: Int? = nil
    @StateObject private var vm = MarketViewModelNew()
    @State private var company: Company?
    @EnvironmentObject var walletState: WalletState
    @State private var visitedSpeculative = false
    @State private var visitedSafe = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            if currentStep == 1 {

                VStack(spacing: 32) {

                    Text("اختار نوع السهم")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                

                    
                // كارد السهم المضارب
                    if selectedCard != 2 {
                        Button {
                            withAnimation(.spring(response: 0.5,
                                                  dampingFraction: 0.85)) {
                                if selectedCard == 1 {
                                    selectedCard = nil
                                    visitedSpeculative = true
                                } else {
                                    selectedCard = 1
                                }
                            }
                        } label: {
                            
                            ZStack {
                                
                                if selectedCard == 1 {
                                    
                                    VStack(spacing: 20) {
                                        
                                        // الجزء العلوي
                                        HStack(alignment: .top) {
                                            
                                            VStack(spacing: 8) {
                                                
                                                Image(systemName: "clock")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(
                                                        Color(
                                                            red: 157/255,
                                                            green: 181/255,
                                                            blue: 239/255
                                                        )
                                                    )
                                                
                                                Text("بعد أسبوع")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.white)
                                            }
                                            
                                            Spacer()
                                            
                                            VStack(alignment: .trailing, spacing: 4) {
                                                
                                                HStack(spacing: 12) {
                                                    
                                                    VStack(alignment: .trailing, spacing: 4) {
                                                        
                                                        Text("بيرن اكس")
                                                            .font(.system(size: 20, weight: .bold))
                                                            .foregroundColor(.white)
                                                        
                                                        Text("قطاع الأعمال")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(.gray)
                                                    }
                                                    
                                                    Image("bx")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 40)
                                                    
                                                }
                                                HStack(spacing: 10) {
                                                    
                                                    Text(
                                                        String(format: "%.2f",
                                                               company?.stock.currentPrice ?? 0)
                                                    )
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .foregroundColor(
                                                        company?.stock.changePercent ?? 0 >= 0
                                                        ? .green : .red
                                                    )
                                                    
                                                    let change = company?.stock.changePercent ?? 0
                                                    
                                                    Text(
                                                        change >= 0
                                                        ? "+\(String(format: "%.2f", change))%"
                                                        : "\(String(format: "%.2f", change))%"
                                                    )
                                                    .foregroundColor(
                                                        change >= 0 ? .green : .red
                                                    )
                                                    .font(.system(size: 20,
                                                                  weight: .bold))
                                                    .foregroundColor(.white)
                                                }
                                                .environment(\.layoutDirection, .leftToRight)
                                            }
                                        }
                                        
                                        // الشارت
                                        if let company {
                                            
                                            MarketBigChartView(
                                                prices: company.chartData.timeframes.oneDay.map {
                                                    $0.price
                                                }
                                            )
                                            .frame(height: 180)
                                        }
                                        
                                        // العنوان
                                        Text("السهم المضارب")
                                            .font(.system(size: 28,
                                                          weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity,
                                                   alignment: .trailing)
                                        
                                        // الشرح
                                        Text("""
                            هنا تشتري وتبيع في نفس اليوم أو الأسبوع عشان تطلع بربح سريع من حركة السعر. في المضاربة، أنت ما يهمك وش تسوي الشركة أو وش قيمتها، المهم عندك إذا السعر بيرتفع أو ينخفض.
                            """)
                                        .font(.system(size: 18))
                                        .foregroundColor(.white.opacity(0.5))
                                        .multilineTextAlignment(.trailing)
                                    }
                                    
                                    .padding()
                                    .offset(y: -60)
                                } else {
                                    
                                    // الكارد الحالية نفسها بدون أي تغيير
                                    HStack {
                                        
                                        Image(systemName: "chart.line.uptrend.xyaxis")
                                            .font(.system(size: 80, weight: .medium))
                                            .foregroundColor(
                                                Color(
                                                    red: 157/255,
                                                    green: 181/255,
                                                    blue: 239/255
                                                )
                                            )
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 18) {
                                            
                                            Text("السهم المضارب")
                                                .font(.system(size: 28, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            Text("تشتري وتراقب وش يتغير بالسهم.")
                                                .font(.system(size: 20))
                                                .foregroundColor(Color.white.opacity(0.5))
                                                .multilineTextAlignment(.trailing)
                                        }
                                    }
                                    .padding(.horizontal, 28)
                                }
                            }
                            .frame(
                                width: 361,
                                height: selectedCard == 1 ? 525 : 176
                                
                            )
                            .offset(y: selectedCard == 1 ? 40 : 0)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.black.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(
                                                Color.white.opacity(0.15),
                                                lineWidth: 1
                                            )
                                    )
                            )
                            .animation(.spring(response: 0.5, dampingFraction: 0.85),
                            )
                        }
                    }
                    // كارد السهم الآمن
                    
                    if selectedCard != 1 {

                        Button {
                            withAnimation(.spring(response: 0.5,
                                                   dampingFraction: 0.85)) {
                                if selectedCard == 2 {
                                    selectedCard = nil
                                    visitedSafe = true
                                } else {
                                    selectedCard = 2
                                }
                            }
                            
                        } label: {
                            ZStack {
                                
                                if selectedCard == 2 {
                                    
                                    VStack(spacing: 20) {
                                        
                                        // الجزء العلوي
                                        HStack(alignment: .top) {
                                            
                                            VStack(spacing: 8) {
                                                
                                                Image(systemName: "clock")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(
                                                        Color(
                                                            red: 157/255,
                                                            green: 181/255,
                                                            blue: 239/255
                                                        )
                                                    )
                                                
                                                Text("بعد 5 سنوات ")
                                                    .font(.system(size: 15))
                                                    .foregroundColor(.white)
                                            }
                                            
                                            Spacer()
                                            
                                            VStack(alignment: .trailing, spacing: 4) {
                                                
                                                HStack(spacing: 12) {
                                                    
                                                    VStack(alignment: .trailing, spacing: 4) {
                                                        
                                                        Text("بيرن اكس")
                                                            .font(.system(size: 20, weight: .bold))
                                                            .foregroundColor(.white)
                                                        
                                                        Text("قطاع الأعمال")
                                                        .font(.system(size: 16))
                                                        .foregroundColor(.gray)
                                                    }
                                                    
                                                    Image("bx")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 40, height: 40)
                                                    
                                                }
                                                HStack(spacing: 10) {
                                                    
                                                    Text(
                                                        String(format: "%.2f",
                                                               company?.stock.currentPrice ?? 0)
                                                    )
                                                    .font(.system(size: 20, weight: .bold))
                                                    .foregroundColor(.white)
                                                    .foregroundColor(
                                                        company?.stock.changePercent ?? 0 >= 0
                                                        ? .green : .red
                                                    )
                                                    
                                                    let change = company?.stock.changePercent ?? 0
                                                    
                                                    Text(
                                                        change >= 0
                                                        ? "+\(String(format: "%.2f", change))%"
                                                        : "\(String(format: "%.2f", change))%"
                                                    )
                                                    .foregroundColor(
                                                        change >= 0 ? .green : .red
                                                    )
                                                    .font(.system(size: 20,
                                                                  weight: .bold))
                                                    .foregroundColor(.white)
                                                }
                                                .environment(\.layoutDirection, .leftToRight)
                                            }
                                        }
                                        
                                        // الشارت
                                        if let company {
                                            
                                            MarketBigChartView(
                                                prices: company.chartData.timeframes.oneDay.map {
                                                    $0.price
                                                }
                                            )
                                            .frame(height: 180)
                                        }
                                        
                                        // العنوان
                                        Text("السهم الامن")
                                            .font(.system(size: 28,
                                                          weight: .bold))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity,
                                                   alignment: .trailing)
                                        
                                        // الشرح
                                        Text("""
                            هذا السهم حق المدى الطويل.
                             تشتري فيه وتخليه سنين عشان فلوسك تكبر بهدوء وأمان. الشركات هنا تكون عملاقة وراسخة بالسوق، وما تهزها الأزمات بسهولة.
                            """)
                                            .font(.system(size: 18))
                                            .foregroundColor(.white.opacity(0.5))
                                            .multilineTextAlignment(.trailing)
                                    }
                                    
                                    .padding()
                                    .offset(y: 7)
                                } else {
                                    
                                    HStack {
                                        
                                        ZStack {

                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .font(.system(size: 80, weight: .medium))
                                                .foregroundColor(
                                                    Color(
                                                        red: 157/255,
                                                        green: 181/255,
                                                        blue: 239/255
                                                    )
                                                )

                                            Image(systemName: "shield.fill")
                                                .font(.system(size: 40, weight: .bold))
                                                .foregroundColor(
                                                    Color(
                                                        red: 157/255,
                                                        green: 181/255,
                                                        blue: 239/255
                                                    
                                                
                                                    )
                                                )
                                                .offset(x: 29, y: -18) // عدلي المكان لين يركب على رأس السهم
                                        }
                                        .frame(width: 90, height: 90)
                                        
                                        Spacer()
                                        
                                        VStack(alignment: .trailing, spacing: 18) {
                                            
                                            Text("السهم الآمن")
                                                .font(.system(size: 28, weight: .semibold))
                                                .foregroundColor(.white)
                                            
                                            Text("تشتري بدون ما تراقب بشكل مستمر وش يتغير بالسهم.")
                                                .font(.system(size: 20))
                                                .foregroundColor(Color.white.opacity(0.5))
                                                .multilineTextAlignment(.trailing)
                                        }
                                    }
                                    .padding(.horizontal, 28)
                                }
                            }
                            .frame(
                                width: 361,
                                height: selectedCard == 2 ? 525 : 176
                            )
                            .animation(
                                .spring(response: 0.5, dampingFraction: 0.85),
                                value: selectedCard
                            )
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.black.opacity(0.15))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 25)
                                            .stroke(
                                                Color.white.opacity(0.15),
                                                lineWidth: 1
                                            )
                                    )
                            )
                           
                        }
                    }

                    if visitedSpeculative && visitedSafe {

                        PrimaryButton(title: "انتهيت") {
                            currentStep += 1
                        }
                    }
                }
                .padding()
                .onAppear {
                    company = vm.marketData?.companies.first
                }
                
        }
        }
        .navigationTitle("المستثمر الذكي")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AppContainerView {
        NavigationStack {
            StockTypeLevelView()
        }
    }
}
