//
//  MarketListViewV2.swift
//  Snam
//
//  Created by Najla Almuqati on 20/12/1447 AH.
//

//import SwiftUI
//
//struct MarketListViewV2: View {
//    
//    @StateObject private var vm = MarketViewModelNew()
//    @State private var showFilterMenu = false
//    @State private var selectedSector = "الكل"
//    var displayedCompanies: [Company] {
//
//        if selectedSector == "الكل" {
//            return vm.filteredCompanies
//        }
//
//        return vm.filteredCompanies.filter {
//            sectorArabicNew($0.sector) == selectedSector
//        }
//    }
//    
//    var body: some View {
//        NavigationStack {
//            
//            ZStack {
//                
//                Image("background")
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//                if showFilterMenu {
//
//                    VStack {
//
//                        HStack {
//
//                            VStack(spacing: 18) {
//
//                                filterButton("الكل")
//                                filterButton("قطاع الطاقة")
//                                filterButton("قطاع المال والبنوك")
//                                filterButton("قطاع الاتصالات")
//                                filterButton("قطاع التقنية")
//                            }
//                            .padding(.vertical, 20)
//                            .frame(width: 260)
//                            .background(Color.black.opacity(0.95))
//                            .cornerRadius(28)
//
//                            Spacer()
//                        }
//
//                        Spacer()
//                    }
//                    .padding(.top, 140)
//                    .padding(.leading, 20)
//                    .zIndex(999)
//                }
//                VStack {
//                    
//                    HStack {
//                        
//                        Text("المحاكي")
//                            .font(.system(size: 30, weight: .black))
//                            .foregroundColor(.white)
//                        
//                        Spacer()
//                        
//                        Button {
//                            withAnimation {
//                                showFilterMenu.toggle()
//                            }
//                                
//                            } label: {
//                                Image(systemName: "line.3.horizontal")
//                                    .foregroundColor(.white)
//                                    .frame(width: 50, height: 50)
//                                    .background(Color.white.opacity(0.08))
//                                    .clipShape(Circle())
//                            }
//                    
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.top, 70)
//                        .padding(.bottom, 30)
//                        .environment(\.layoutDirection, .rightToLeft)
//                        ScrollView {
//                            
//                            LazyVStack(spacing: 0) {
//                                
//                                ForEach(displayedCompanies) { company in
//            
//                                        }
//                                    }
//                                    
//                                    NavigationLink {
//                                        
//                                        CompanyDetailViewV2(
//                                            company: company,
//                                            vm: vm
//                                        )
//                                        
//                                    } label: {
//                                        
//                                        CompanyCardV2(
//                                            company: company,
//                                            currency: vm.marketData?.currency ?? "SAR"
//                                        )
//                                        
//                                    }
//                                    .buttonStyle(.plain)
//                                }
//                                .padding(.horizontal)
//                                
//                            }
//                        }
//                    }
//                    .environment(\.layoutDirection, .rightToLeft)
//                }
//            }
//        
//    
//    struct CompanyCardV2: View {
//        
//        let company: Company
//        let currency: String
//        
//        var body: some View {
//            
//            
//            HStack {
//                
//                ZStack {
//                    
//                    Circle()
//                        .fill(Color.white.opacity(0.08))
//                        .frame(width: 54, height: 54)
//                    
//                    Text(company.icon)
//                        .font(.title3)
//                }
//                
//                VStack(alignment: .trailing, spacing: 4) {
//                    
//                    Text(company.fakeName)
//                        .font(.system(size: 17, weight: .bold))
//                        .foregroundColor(.white)
//                    
//                    Text(sectorArabicNew(company.sector))
//                        .font(.caption)
//                        .foregroundColor(.gray)
//                }
//                
//                Spacer()
//                
//                MiniSparklineNew(
//                    points: company.chartData.timeframes.oneDay.map { $0.price },
//                    trend: company.stock.trend
//                )
//                .frame(width: 65, height: 25)
//                
//                Spacer()
//                
//                VStack(alignment: .leading, spacing: 6) {
//                    
//                    Text("\(Int(company.stock.currentPrice))")
//                        .font(.system(size: 20, weight: .bold))
//                        .foregroundColor(.white)
//                    
//                    Text(
//                        company.stock.changePercent >= 0
//                        ? "+\(String(format: "%.2f", company.stock.changePercent))%"
//                        : "\(String(format: "%.2f", company.stock.changePercent))%"
//                    )
//                    .font(.system(size: 13, weight: .semibold))
//                    .foregroundColor(
//                        company.stock.changePercent >= 0 ? .green : .red
//                    )
//                }
//            }
//            .environment(\.layoutDirection, .rightToLeft)
//            .padding(.horizontal, 18)
//            .padding(.vertical, 18)
//            .overlay(
//                Divider()
//                    .background(Color.white.opacity(0.15)),
//                alignment: .bottom
//            )
//        }
//        
//        
//        
//        
//        struct FilterItem: View {
//            
//            let title: String
//            
//            var body: some View {
//                
//                Text(title)
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 50)
//                    .overlay(
//                        Divider(),
//                        alignment: .bottom
//                    )
//            }
//        }
//        
//        
//        
//        
//        
//    }
//
//    #Preview {
//        MarketListViewV2()
//    }

import SwiftUI

struct MarketListViewV2: View {
    
    @StateObject private var vm = MarketViewModelNew()
    @State private var showFilterMenu = false
    @State private var selectedSector = "الكل"

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

    var body: some View {
        NavigationStack {
            
            ZStack {
                
                Image("background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                if showFilterMenu {

                    VStack {

                        HStack {

                            VStack(spacing: 18) {

                                filterButton("الكل")
                                filterButton("قطاع الطاقة")
                                filterButton("قطاع المال والبنوك")
                                filterButton("قطاع الاتصالات")
                                filterButton("قطاع التقنية")
                            }
                            .padding(.vertical, 20)
                            .frame(width: 260)
                            .background(Color.black.opacity(0.95))
                            .cornerRadius(28)

                            Spacer()
                        }

                        Spacer()
                    }
                    .padding(.top, 140)
                    .padding(.leading, 20)
                    .zIndex(999)
                }
                VStack {
                    
                    HStack {
                        
                        Text("المحاكي")
                            .font(.system(size: 30, weight: .black))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button {
                            withAnimation {
                                showFilterMenu.toggle()
                            }
                                
                            } label: {
                                Image(systemName: "line.3.horizontal")
                                    .foregroundColor(.white)
                                    .frame(width: 50, height: 50)
                                    .background(Color.white.opacity(0.08))
                                    .clipShape(Circle())
                            }
                    
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 70)
                        .padding(.bottom, 30)
                        .environment(\.layoutDirection, .rightToLeft)
                        ScrollView {
                            
                            LazyVStack(spacing: 0) {
                                
                                ForEach(displayedCompanies) { company in

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
                
                ZStack {
                    
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 54, height: 54)
                    
                    Text(company.icon)
                        .font(.title3)
                }
                
                VStack(alignment: .trailing, spacing: 4) {
                    
                    Text(company.fakeName)
                        .font(.system(size: 17, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(sectorArabicNew(company.sector))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                MiniSparklineNew(
                    points: company.chartData.timeframes.oneDay.map { $0.price },
                    trend: company.stock.trend
                )
                .frame(width: 65, height: 25)
                
                Spacer()
                
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
                        company.stock.changePercent >= 0 ? .green : .red
                    )
                }
            }
            .environment(\.layoutDirection, .rightToLeft)
            .padding(.horizontal, 18)
            .padding(.vertical, 18)
            .overlay(
                Divider()
                    .background(Color.white.opacity(0.15)),
                alignment: .bottom
            )
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
