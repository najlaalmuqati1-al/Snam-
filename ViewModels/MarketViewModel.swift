//
//  MarketViewModel.swift
//  Snam
//
//  Created by Jojo on 20/05/2026.
//
import Combine
import Foundation

class MarketViewModel: ObservableObject {

    @Published var companies: [Company] = []
    @Published var selectedSector: String = "الكل"

    var sectors: [String] {
        let all = companies.map { $0.sector }
        let unique = Array(Set(all)).sorted()
        return ["الكل"] + unique
    }

    var filteredCompanies: [Company] {
        if selectedSector == "الكل" {
            return companies
        }
        return companies.filter { $0.sector == selectedSector }
    }

    init() {
        loadData()
    }

    private func loadData() {
        print("📦 files:", Bundle.main.paths(forResourcesOfType: "json", inDirectory: nil))
        
        guard let url = Bundle.main.url(forResource: "MarketData", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("❌ ما لقى الملف")
            return
        }

        let decoder = JSONDecoder()
        do {
            let market = try decoder.decode(MarketData.self, from: data)
            self.companies = market.companies
            print("✅ تم تحميل \(market.companies.count) شركة")
        } catch {
            print("❌ خطأ في الـ decode:", error)
        }
    }
    
}
