//
//  AppColors.swift
//  Snam
//
//  Created by Jojo on 03/06/2026.
import SwiftUI

struct AppContainerView<Content: View>: View {
    let content: Content
    
    // هذي الـ init تسمح لنا نمرر أي شاشة داخل الـ Container
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        Color(.systemBackground)
            .ignoresSafeArea()
            .overlay(
                Image("Frame")
                    .resizable()
                    .scaledToFill()
            )
            .overlay(
                // هنا الشاشة حقتك بتجلس بكل راحة وبدون ما تتأثر إزاحاتها
                content
            )
            .ignoresSafeArea() // يضمن إن الـ Blur يغطي كامل الشاشة خلف الساعة والبطارية
    }
}
/**
 كيف الاستخدام
 
 بس حطوا بالبرفيو حقكم كذا
 #Preview {
     AppContainerView {
         LevelsView()
     }
 }
 
 
 
 */
