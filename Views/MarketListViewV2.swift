//
//  MarketListViewV2.swift
//  Snam
//
//  Created by Najla Almuqati on 20/12/1447 AH.
//

import SwiftUI

struct MarketListViewV2: View {
    
    @StateObject private var vm = MarketViewModelNew()
    @State private var showFilterMenu = false
    
    var body: some View {
        NavigationStack {
            
            ZStack {
                
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                VStack {
                    
                    HStack {
                        
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.white)
                                .frame(width: 42,height: 42)
                                .background(Color.white.opacity(0.08))
                                .clipShape(Circle())
                        }
                        if showFilterMenu {
                            
                            VStack(spacing: 0) {
                                
                                FilterItem(title: "الكل")
                                FilterItem(title: "قطاع الطاقة")
                                FilterItem(title: "قطاع المال والبنوك")
                                FilterItem(title: "قطاع الاتصالات")
                                FilterItem(title: "قطاع التقنية")
                                
                            }
                            .frame(width: 220)
                            .background(Color.black.opacity(0.95))
                            .cornerRadius(20)
                        }
                        HStack {
                            
                            
                            Text("سوق الأسهم")
                                .font(.system(size: 14))
                                .foregroundColor(.white.opacity(0.6))
                            
                            Spacer()
                            
                            Text("المحاكي")
                                .font(.system(size: 34, weight: .black))
                                .foregroundColor(.white)
                        }
                        
                        .padding(.horizontal,24)
                        ScrollView {
                            
                            LazyVStack(spacing: 14) {
                                
                                ForEach(vm.filteredCompanies) { company in
                                    
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
                                .padding(.horizontal)
                                
                            }
                        }
                    }
                    .environment(\.layoutDirection, .rightToLeft)
                }
            }
        }
    }
    struct CompanyCardV2: View {
        
        let company: Company
        let currency: String
        
        var body: some View {
            
            
            HStack {
                
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
                        company.stock.changePercent >= 0
                        ? .green
                        : .red
                    )
                }
                
                Spacer()
                MiniSparklineNew(
                    points: company.chartData.timeframes.oneDay.map { $0.price },
                    trend: company.stock.trend
                )
                .frame(width: 80, height: 25)
                
                VStack(alignment: .trailing, spacing: 4) {
                    
                    Text(company.fakeName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(sectorArabicNew(company.sector))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                ZStack {
                    
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 54, height: 54)
                    
                    Text(company.icon)
                        .font(.title3)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 22)        .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.white.opacity(0.08),
                                Color.white.opacity(0.03)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        Color.white.opacity(0.08),
                        lineWidth: 1
                    )
            )
        }
        
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
