//
//  StockData.swift
//  Snam
//
//  Created by Faitmh ibrahim on 19/12/1447 AH.
//


import Foundation

struct StockData: Identifiable {
    let id = UUID()
    let day: Int
    let value: Double
}