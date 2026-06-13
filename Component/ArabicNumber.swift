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
func arabicNumerals(_ text: String) -> String {
    let arabic = ["٠","١","٢","٣","٤","٥","٦","٧","٨","٩"]
    return text.map { c in
        if let digit = c.wholeNumberValue {
            return arabic[digit]
        }
        return String(c)
    }.joined()
}
