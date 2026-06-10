//
//  NavigationHeader.swift
//  Snam
//
//  Created by Jojo on 10/06/2026.
import SwiftUI

// MARK: - NavigationHeader Component

struct NavigationHeader: View {
    
    // MARK: - Properties
    let title: String
    var onBack: (() -> Void)? = nil
    var showBackButton: Bool = true
    
    @Environment(\.colorScheme) private var colorScheme
    
    // MARK: - Body
    var body: some View {
        toolbar
            .frame(maxWidth: .infinity)
    }
    
    // MARK: - Toolbar
    private var toolbar: some View {
        ZStack {
            // Title في المنتصف
            Text(title)
                .font(.custom("SF Arabic", size: 24))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .tracking(-0.43)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            
            // زر الرجوع على اليمين
            HStack {
                if showBackButton {
                    Button(action: { onBack?() }) {
                        ZStack {
                            Circle()
                                .fill(colorScheme == .dark
                                      ? AnyShapeStyle(.ultraThinMaterial)
                                      : AnyShapeStyle(Color.black.opacity(0.08)))
                                .overlay(
                                    Circle()
                                        .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                                )
                                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
                                .frame(width: 44, height: 44)
                            
                            Image(systemName: "chevron.right")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.primary)
                        }
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .frame(height: 54)
        .padding(.bottom, 10)
    }
}

// MARK: - Preview
struct NavigationHeader_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ZStack {
                Color(red: 0.1, green: 0.1, blue: 0.18).ignoresSafeArea()
                VStack {
                    NavigationHeader(title: "الإعدادات", onBack: { print("رجوع") })
                    Spacer()
                }
            }
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark")

            ZStack {
                Color.white.ignoresSafeArea()
                VStack {
                    NavigationHeader(title: "الإعدادات", onBack: { print("رجوع") })
                    Spacer()
                }
            }
            .preferredColorScheme(.light)
            .previewDisplayName("Light")
        }
    }
}
/**
 
 NavigationHeader(title: "تحدي التنويع", onBack: {})
     .padding(.bottom, 20)
 
 */
