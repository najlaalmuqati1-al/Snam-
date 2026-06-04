//
//  ArabicNumber.swift
//  Snam
//
//  Created by Jojo on 04/06/2026.
//
import Foundation

func arabicNumber(_ n: Int) -> String {
    let formatter = NumberFormatter()
    formatter.locale = Locale(identifier: "ar_SA")
    formatter.numberStyle = .decimal
    return formatter.string(from: NSNumber(value: n)) ?? "\(n)"
}

//
