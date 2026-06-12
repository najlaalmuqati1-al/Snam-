//
//  MarketViewModelNew.swift
//  Snam
//
//  Created by Najla Almuqati on 22/12/1447 AH.
//

import SwiftUI
import Combine

class MarketViewModelNew: ObservableObject {

    @Published var marketData: MarketData?
    @Published var selectedSector: String = "الكل"
    @Published var userBalance: Double = 50000.0
    @Published var ownedShares: [Int: Int] = [:] {
        didSet {
            if let encoded = try? JSONEncoder().encode(ownedShares) {
                UserDefaults.standard.set(encoded, forKey: "ownedShares")
            }
        }
    }
    var sectors: [String] {
        var list = ["الكل"]

        if let companies = marketData?.companies {
            let uniqueSectors = Set(companies.map { $0.sector })
            list.append(contentsOf: uniqueSectors.sorted())
        }

        return list
    }

    var filteredCompanies: [Company] {

        guard let companies = marketData?.companies else {
            return []
        }

        if selectedSector == "الكل" {
            return companies
        }

        return companies.filter {
            $0.sector == selectedSector
        }
    }

 

    init() {
        if let data = UserDefaults.standard.data(forKey: "ownedShares"),
           let decoded = try? JSONDecoder().decode([Int: Int].self, from: data) {
            self.ownedShares = decoded
        }
        loadLocalJSON()
    }

    private func loadLocalJSON() {
        if let url = Bundle.main.url(
            forResource: "MarketData",
            withExtension: "json"
        ) {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                self.marketData = try decoder.decode(
                    MarketData.self,
                    from: data
                )
            } catch {
                print("Error parsing MarketData.json: \(error)")
                setupFallbackMockData()
            }
        } else {
            setupFallbackMockData()
        }
    }

    private func setupFallbackMockData() {

        let dummyStats = Statistics(
            previousClose: 121.45,
            openPrice: 121.00,
            dayHigh: 126.00,
            dayLow: 119.00,
            volumeTraded: 2300000,
            tradingValue: 285200000,
            numberOfTrades: 23302,
            averageTradeSize: 12240,
            averagePrice: 123.10,
            bestBid: 123.90,
            bestAsk: 124.10
        )

        let dummyStock = Stock(
            symbol: "NJD",
            currentPrice: 124.00,
            trend: "up",
            changePercent: 2.1,
            changeAmount: 2.55,
            riskLevel: "Medium",
            marketCap: "1.2T",
            statistics: dummyStats
        )

        let dummyNews = News(
            headline: "توسع استراتيجي جديد لشركة نجد للطاقة",
            impact: "Positive"
        )

        let dummyChart = ChartData(
            timeframes: Timeframes(
                oneDay: [120, 122, 121, 125, 123, 124]
                    .map { PricePoint(timestamp: "", price: $0) },
                oneWeek: [],
                oneMonth: [],
                oneYear: []
            )
        )

        let fallbackCompanies = [

            Company(
                id: 1,
                fakeName: "Najd Energy",
                imageName: "najd_logo",
                inspiredBy: "Aramco",
                sector: "Energy",
                description: "شركة طاقة افتراضية",
                icon: "🛢️",
                stock: dummyStock,
                news: dummyNews,
                chartData: dummyChart,
                candlestickData: []
            ),

            Company(
                id: 2,
                fakeName: "Desert Bank",
                imageName: "desert_logo",
                inspiredBy: "Desert",
                sector: "Banking",
                description: "مصرف افتراضي",
                icon: "🏦",
                stock: dummyStock,
                news: dummyNews,
                chartData: dummyChart,
                candlestickData: []
            ),

            Company(
                id: 3,
                fakeName: "Najd Telecom",
                imageName: "telecom_logo",
                inspiredBy: "STC",
                sector: "Telecom",
                description: "شركة اتصالات افتراضية",
                icon: "📱",
                stock: dummyStock,
                news: dummyNews,
                chartData: dummyChart,
                candlestickData: []
            )
        ]

        self.marketData = MarketData(
            marketName: "Saudi Simulated Market",
            marketStatus: "Open",
            currency: "SAR",
            lastUpdated: "2026-05-12T14:30:00Z",
            companies: fallbackCompanies
        )
    }

    func buyStock(company: Company, count: Int) -> Bool {

        let cost = company.stock.currentPrice * Double(count)

        if userBalance >= cost {

            userBalance -= cost
            ownedShares[company.id, default: 0] += count

            return true
        }

        return false
    }

    func sellStock(company: Company, count: Int) -> Bool {

        let currentOwned = ownedShares[company.id, default: 0]

        if currentOwned >= count {

            let revenue = company.stock.currentPrice * Double(count)

            userBalance += revenue
            ownedShares[company.id] = currentOwned - count

            return true
        }

        return false
    }
}
