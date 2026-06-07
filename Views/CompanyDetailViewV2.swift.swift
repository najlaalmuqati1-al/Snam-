//
//  CompanyDetailViewV2.swift.swift
//  Snam
//
//  Created by Najla Almuqati on 20/12/1447 AH.
//

//import SwiftUI
//
//struct CompanyDetailViewV2: View {
//
//    let company: Company
//    @ObservedObject var vm: MarketViewModelNew
//
//    @Environment(\.dismiss) var dismiss
//
//    @State private var showTradeSheet = false
//
//    var body: some View {
//
//        ZStack {
//
//            Image("background")
//                .resizable()
//                .scaledToFill()
//                .ignoresSafeArea()
//
//            VStack(spacing: 0) {
//
//                // Header
//                HStack {
//
//                    Button {
//                        dismiss()
//                    } label: {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.white)
//                            .frame(width: 50,height: 50)
//                            .background(Color.white.opacity(0.06))
//                            .clipShape(Circle())
//                    }
//
//                    Spacer()
//
//                    Text(company.fakeName)
//                        .font(.headline)
//                        .foregroundColor(.white)
//                }
//                .padding()
//
//                Spacer()
//
//                // Company Info
//                HStack {
//
//                    VStack(alignment: .trailing) {
//
//                        Text(company.fakeName)
//                            .font(.title2.bold())
//                            .foregroundColor(.white)
//
//                        Text(sectorArabicNew(company.sector))
//                            .foregroundColor(.gray)
//                    }
//
//                    Spacer()
//
//                    Circle()
//                        .fill(Color.white.opacity(0.08))
//                        .frame(width: 60,height: 60)
//                        .overlay(
//                            Text(company.icon)
//                        )
//                }
//                .padding(.horizontal)
//
//                HStack {
//
//                    Spacer()
//
//                    Text(
//                        company.stock.changePercent >= 0
//                        ? "+\(String(format: "%.2f", company.stock.changePercent))%"
//                        : "\(String(format: "%.2f", company.stock.changePercent))%"
//                    )
//                    .foregroundColor(.green)
//                    .font(.title3.bold())
//                }
//                .padding(.horizontal)
//
//                // الفترات
//                HStack(spacing: 24) {
//
//                    Text("1ي")
//                    Text("1س")
//                    Text("1ش")
//                    Text("3ش")
//                    Text("6ش")
//                    Text("1س")
//
//                }
//                .foregroundColor(.white.opacity(0.8))
//                .padding(.top, 20)
//
//                MarketBigChartView(
//                    prices: company.chartData.timeframes.oneDay.map { $0.price }
//                )
//                .frame(height: 260)
//                .padding()
//
//                Spacer()
//
//                Button {
//
//                    showTradeSheet = true
//
//                } label: {
//
//                    Text("تداول")
//                        .font(.system(size: 22, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(maxWidth: .infinity)
//                        .frame(height: 60)
//                        .background(Color.blue.opacity(0.8))
//                        .cornerRadius(30)
//
//                }
//                .padding(.horizontal,24)
//                .padding(.bottom,30)
//
//            }
//        }
//    }
//}
import SwiftUI

struct CompanyDetailViewV2: View {
    
    let company: Company
    @ObservedObject var vm: MarketViewModelNew
    @State private var showTradeSheet = false
    @State private var showInfo = false
    @State private var showSuccessBanner = false
    @State private var bannerMessage = ""
    var body: some View {
        
        
        ZStack {
            
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
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
    }
    
    
}
