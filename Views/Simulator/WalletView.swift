//
//  WalletView.swift
//  Snam
//
//  Created by Najla Almuqati on 23/12/1447 AH.
//
import SwiftUI

struct WalletView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let items = [
        ("100", "اعلان"),
        ("500", "5 ريال"),
        ("1100", "9 ريال"),
        ("2500", "15 ريال")
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        
        ZStack {
            
            Image("background")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            ScrollView {
                
                
                VStack(spacing: 24) {
                    
                    ZStack {

                        Text("المال الحلال")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)

                        HStack {

                            Spacer()

                            Button {
                                dismiss()
                            } label: {

                                Circle()
                                    .fill(Color.black.opacity(0.2))
                                    .frame(width: 44, height: 44)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                    )
                                    .overlay(
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.white)
                                            .font(.system(size: 22, weight: .regular))
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 52)
                    
                    Color.clear
                        .frame(height: 50)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.black.opacity(0.2))
                        .frame(height: 85)
                        .overlay {
                            
                            HStack {
                                
                                ZStack {
                                    
                                    Circle()
                                        .fill(Color(red: 0.137, green: 0.235, blue: 0.455))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: "square.and.arrow.up")
                                        .foregroundColor(.white)
                                        .font(.system(size: 20))
                                }
                                
                                Spacer()
                                
                                HStack(alignment: .top, spacing: 8) {
                                    
                                    VStack(spacing: 0) {
                                        
                                        Text("100")
                                            .font(.system(size: 22, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Text("سنام")
                                            .font(.system(size: 9))
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Text("شارك سهم مع ربعك وتبرع\nفي محفظتك")
                                        .font(.system(size: 18, weight: .semibold))
                                        .multilineTextAlignment(.trailing)
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.15))
                        )
                        .padding(.horizontal)
                    Color.clear
                        .frame(height: 12)
                    
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        ForEach(items, id: \.0) { item in
                            
                            VStack(spacing: 20) {
                                
                                VStack(spacing: 0) {
                                    
                                    Text(item.0)
                                        .font(.system(size: 22, weight: .medium))
                                        .foregroundColor(.white)
                                    
                                    Text("سنام")
                                        .font(.system(size: 9))
                                        .foregroundColor(.gray)
                                }
                                
                                Image("wallet")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 120)
                                
                                WalletButton(title: item.1) {
                                    
                                }
                                
                            }
                            .scaleEffect(0.85)
                        }
                        .padding()
                        .frame(height: 209)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black.opacity(0.2))
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.15))
                            
                        )
                    }
                }
                
                .padding(.horizontal)
            }
            .padding(.top, 20)
            .padding(.bottom, 40)
            .navigationBarBackButtonHidden(true)
        }
        
    }
    
    
    
    
}
