//
//  Market.swift
//  Snam
//
//  Created by Jojo on 20/05/2026.
//

import Foundation

// MARK: - Root
struct MarketData: Codable {
    let marketName: String
    let marketStatus: String
    let currency: String
    let lastUpdated: String
    let companies: [Company]

    enum CodingKeys: String, CodingKey {
        case marketName    = "market_name"
        case marketStatus  = "market_status"
        case currency
        case lastUpdated   = "last_updated"
        case companies
    }
}

// MARK: - Company
struct Company: Codable, Identifiable {
    let id: Int
    let fakeName: String
    let imageName: String
    let inspiredBy: String
    let sector: String
    let description: String
    let icon: String
    let stock: Stock
    let news: News
    let chartData: ChartData
    let candlestickData: [Candle]

    enum CodingKeys: String, CodingKey {
        case id           = "company_id"
        case fakeName     = "fake_name"
        case imageName    = "image_name"
        case inspiredBy   = "inspired_by"
        case sector
        case description
        case icon
        case stock
        case news
        case chartData    = "chart_data"
        case candlestickData = "candlestick_data"
    }
}

// MARK: - Stock
struct Stock: Codable {
    let symbol: String
    let currentPrice: Double
    let trend: String
    let changePercent: Double
    let changeAmount: Double
    let riskLevel: String
    let marketCap: String
    let statistics: Statistics

    enum CodingKeys: String, CodingKey {
        case symbol
        case currentPrice  = "current_price"
        case trend
        case changePercent = "change_percent"
        case changeAmount  = "change_amount"
        case riskLevel     = "risk_level"
        case marketCap     = "market_cap"
        case statistics
    }
}

// MARK: - Statistics
struct Statistics: Codable {
    let previousClose: Double
    let openPrice: Double
    let dayHigh: Double
    let dayLow: Double
    let volumeTraded: Int
    let tradingValue: Double
    let numberOfTrades: Int
    let averageTradeSize: Int
    let averagePrice: Double
    let bestBid: Double
    let bestAsk: Double

    enum CodingKeys: String, CodingKey {
        case previousClose   = "previous_close"
        case openPrice       = "open_price"
        case dayHigh         = "day_high"
        case dayLow          = "day_low"
        case volumeTraded    = "volume_traded"
        case tradingValue    = "trading_value"
        case numberOfTrades  = "number_of_trades"
        case averageTradeSize = "average_trade_size"
        case averagePrice    = "average_price"
        case bestBid         = "best_bid"
        case bestAsk         = "best_ask"
    }
}

// MARK: - News
struct News: Codable {
    let headline: String
    let impact: String
}

// MARK: - ChartData
struct ChartData: Codable {
    let timeframes: Timeframes
}

struct Timeframes: Codable {
    let oneDay: [PricePoint]
    let oneWeek: [PricePoint]
    let oneMonth: [PricePoint]
    let oneYear: [PricePoint]

    enum CodingKeys: String, CodingKey {
        case oneDay   = "1D"
        case oneWeek  = "1W"
        case oneMonth = "1M"
        case oneYear  = "1Y"
    }
}

struct PricePoint: Codable {
    let timestamp: String
    let price: Double
}

// MARK: - Candle
struct Candle: Codable {
    let timestamp: String
    let open: Double
    let high: Double
    let low: Double
    let close: Double
    let volume: Int
}
