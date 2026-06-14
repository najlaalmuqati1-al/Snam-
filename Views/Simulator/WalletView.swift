//
//  WalletView.swift
//  Snam
//
//  Created by Najla Almuqati on 23/12/1447 AH.
//
import SwiftUI

struct WalletView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var walletState: WalletState
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
            
           
                
                
                VStack(spacing: 32){ //main
                  
                //MARK: - shareRectangle
                    
                    ZStack{
                        Rectangle()
                            .cornerRadius(20)
                            .frame(width: 360,height: 80)
                            .foregroundStyle(.black)
                            .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0, y: 0.1)
                            .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.1)
                        
                        HStack{
                            
                            Button{}label: {
                                ZStack{
                           
                                Circle()
                                .frame(width: 44,height: 44)
                                .foregroundStyle(.brandPrimary)
                                .shadow(color: .black.opacity(0.1), radius: 1)
                                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 1)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 100)
                                        .stroke(Color.white.opacity(0.15), lineWidth: 1)
                                                                       )
                           
                                Image(systemName:"square.and.arrow.up")
                                    .font(.system(size: 20))
                                    .foregroundStyle(.white)
                                                               }//z
                                                           }//b
                            
                            Spacer().frame(width: 80)
                            
                            VStack{
                                Text("شارك مع صديق واحصل")
                                    .font(.system(size: 18,weight: .semibold))

                                
                                Text("على ١٠٠ سنام في محفظتك")
                                    .font(.system(size: 18,weight: .semibold))
                                
                            }//v
                            .frame(width: 200,height: 48,alignment: .trailing)
                            
                        }//h
                    }//z
                    
                   // Spacer().frame(height: 32)
                    
                    
                    //MARK: - moneyyyy
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        
                        ForEach(items, id: \.0) { item in
                            
                            VStack(spacing: 32) {
                                
                                HStack(spacing: 0) {
                                    
                                    Text("سنام")
                                        .font(.system(size: 10))
                                        .foregroundColor(.gray)
                                    
                                    Text(item.0)
                                        .font(.system(size: 22, weight: .medium))
                                        .foregroundColor(.white)
                                }
                                
                                Image("wallet")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80,height: 80)
                                
                                WalletButton(title: item.1) {
                                    
                                }
                                
                            }
                            //.scaleEffect(0.85)
                        }
                        .frame(width: 175, height: 209)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.black)
                                .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0, y: 0.1)
                                .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.1)
                        )
                    }
                }//vMain
                .padding(.horizontal,16)
                .padding(.bottom,120)
          
        //.padding(.bottom, 40)
        }
        .navigationTitle("سوق سنام")
        
    }
}

