//
//  AppColors.swift
//  Snam
//
//  Created by Jojo on 03/06/2026.
//

import SwiftUI

extension Color {
    static let backgroundStart = Color("BgStart")
    static let backgroundEnd   = Color("BgEnd")
}

extension RadialGradient {
    static let appBackground = RadialGradient(
        colors: [.bgStart, .bgEnd],
        center: .center,
        startRadius: 0,
        endRadius: 400
    )
}
/**
 
استخدام هذا للباكقرواند
 RadialGradient.appBackground
     .ignoresSafeArea()
 او استخدموا الايمج الموجودة 
 
 */
