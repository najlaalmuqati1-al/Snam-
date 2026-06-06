//
//  InvestmentViewModel.swift
//  Snam
//
//  Created by Faitmh ibrahim on 19/12/1447 AH.
//


import SwiftUI
import Combine

@MainActor
final class InvestmentViewModel: ObservableObject {

    @Published var marketForce: Double = 0
    @Published var selectedDay: Int?   = nil
    @Published var isDragging: Bool    = false

    let daysCount = 50

    // MARK: - Static Patterns
    private lazy var neutralPattern: [StockData] = (1...daysCount).map {
        StockData(day: $0, value: 100.0 + sin(Double($0) * 0.25) * 0.4)
    }

    private lazy var upPattern: [StockData] = (1...daysCount).map { d in
        let t = Double(d) / Double(daysCount)
        return StockData(day: d, value: 100.0 + 35.0 * pow(t, 1.1)
                         + sin(Double(d) * 0.22) * 2.2 + cos(Double(d) * 0.07) * 1.6)
    }

    private lazy var downPattern: [StockData] = (1...daysCount).map { d in
        let t = Double(d) / Double(daysCount)
        return StockData(day: d, value: 100.0 - 32.0 * pow(t, 1.05)
                         + cos(Double(d) * 0.19) * 2.0 + sin(Double(d) * 0.11) * 1.4)
    }

    // MARK: - Computed
    var stockPrice: Double  { 100 + marketForce * 0.8 }
    var percentage: Double  { stockPrice - 100 }
    var buyers: Int         { Int(5000 + marketForce * 50) }
    var sellers: Int        { Int(5000 - marketForce * 50) }
    var isPositive: Bool    { marketForce >= 0 }

    var displayedPrice: Double {
        selectedDay.flatMap { day in dynamicChartPoints.first { $0.day == day } }?.value ?? stockPrice
    }

    var chartColor: Color {
        isPositive ? Color(red: 48/255, green: 209/255, blue: 88/255)
                   : Color(red: 255/255, green: 69/255, blue: 58/255)
    }

    var areaTopColor: Color    { chartColor.opacity(0.22) }
    var areaBottomColor: Color { chartColor.opacity(0.01) }

    var dynamicChartPoints: [StockData] {
        let intensity = min(1.0, abs(marketForce) / 100.0)
        let target    = isPositive ? upPattern : downPattern

        return (0..<daysCount).map { i in
            let p       = Double(i) / Double(max(1, daysCount - 1))
            let bias    = 8.0 * (marketForce / 100.0) * pow(p, 1.25)
            let blended = (1.0 - intensity) * neutralPattern[i].value + intensity * target[i].value
            let noise   = noiseValue(for: i) * intensity * 0.15
            return StockData(day: i + 1, value: max(1.0, blended + bias + noise))
        }
    }

    // MARK: - Actions
    func onDragChanged(day: Int) {
        isDragging  = true
        selectedDay = day
    }

    func onDragEnded() {
        isDragging = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { [weak self] in
            guard let self, !self.isDragging else { return }
            withAnimation(.easeOut(duration: 0.2)) { self.selectedDay = nil }
        }
    }

    // MARK: - Private
    private func noiseValue(for index: Int) -> Double {
        var hasher = Hasher()
        hasher.combine(2024)
        hasher.combine(index)
        let unit = Double(hasher.finalize() & 0x7fffffff) / Double(Int32.max)
        return (unit * 2.0 - 1.0) * 0.35
    }
}
