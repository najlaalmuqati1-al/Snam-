//
//  SnamApp.swift
//  Snam
//
//  Created by Najla Almuqati on 28/11/1447 AH.
//

import SwiftUI

@main
struct YourAppName: App { // هنا اسم تطبيقك
    var body: some Scene {
        WindowGroup {
            AppContainerView {
                LevelsView() // شاشة المراحل الحين صارت محصنة بداخل الخلفية الموحدة
            }
        }
    }
}
