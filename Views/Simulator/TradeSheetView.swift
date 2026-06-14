//
//  TradeSheetView.swift
//  Snam
//
//  Created by Najla Almuqati on 20/12/1447 AH.
//

import SwiftUI

struct TradeSheetView: View {

    let company: Company
    @ObservedObject var vm: MarketViewModelNew
    let onSuccess: (String) -> Void

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var walletState: WalletState
    @State private var quantity = 1
    @State private var isBuy = true
    @State private var showErrorPopup = false
    @State private var errorMessage = ""
    
    var onBalanceChanged: (Double) -> Void
    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()
            
//            if showSuccessToast {
//
//                VStack {
//
//                    HStack {
//
//                        Image(systemName: "checkmark.circle.fill")
//                            .foregroundColor(.green)
//
//                        Text(toastMessage)
//                            .foregroundColor(.white)
//
//                        Spacer()
//                    }
//                    .padding()
//                    .background(Color.black.opacity(0.95))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 16)
//                            .stroke(Color.white.opacity(0.08))
//                    )
//                    .cornerRadius(16)
//                    .padding(.horizontal, 20)
//
//                    Spacer()
//                }
//                .padding(.top, -40)
//                .zIndex(999)
//            }

            VStack/*(spacing: 24)*/ {


                Capsule()
                    .fill(.gray)
                    .frame(width: 36,height: 5)
                    .padding(.top)

                Text("صفحة تداول")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)
                
                Spacer().frame(height: 57)
                
                ZStack{
                    Rectangle()
                        .fill(.black)
                        .frame(width: 104,height: 24)
                        .cornerRadius(11)
                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0.1, y: 0.1)
                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.2, y: -0.2)
                    
                    Text("\(arabicNumber(vm.ownedShares[company.id, default: 0])) من أسهم")
                        .foregroundStyle(.white)
                        .font(.system(size: 16))
                    
                }//z

                Spacer().frame(height: 25)
                
                HStack{
                    
                    Text("سنام")
                        .font(.system(size: 18,weight: .light))
                        .foregroundColor(.gray)
                        .padding(.top)
                    
                    Text(arabicNumber(Int(company.stock.currentPrice * Double(quantity))))
                        .font(.system(size: 64, weight: .semibold))
                        .foregroundColor(.white)
                        //.padding(.top, 35)
                    
                }//h

                Spacer().frame(height: 100)
                
                HStack(alignment: .top) {

                    VStack(alignment: .leading, spacing: 40) {

                        Text("الكمية التي تم تداولها مسبقاً")

                        Text("نوع العملية")

                        Text("الكمية المرادة")
                    }
                    .foregroundColor(.white)
                    .font(.system(size: 18,weight: .medium))

                    Spacer()

                    VStack(spacing: 40) {

                        Text("\(arabicNumber(vm.ownedShares[company.id, default: 0])) من أسهم")               .foregroundColor(.white)
                            .font(.system(size: 16))

                        HStack(spacing: 8) {
                            
                            Button {
                                isBuy = false
                            } label: {
                                Text("بيع")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(isBuy ? .white : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                            }
                            
                            Button {
                                isBuy = true
                            } label: {
                                Text("شراء")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(isBuy ? .white : .white)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 6)
                            }
                        }
                        .frame(width: 110, height: 34)
                        .padding(.horizontal,6)
                        .background(
                            ZStack {
                                // الخلفية الأساسية
                                RoundedRectangle(cornerRadius: 90000)
                                    .fill(Color.black)
                                    .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0.1, y: 0.2)
                                    .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.2)
                                
                                // المتحرك (highlight)
                                GeometryReader { geo in
                                    
                                    RoundedRectangle(cornerRadius: 18)
                                        .fill(Color.black.opacity(0.9))
                                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0.1, y: 0.2)
                                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.2)
                                        .frame(width: geo.size.width / 2)
                                        .offset(x: isBuy ? geo.size.width / 2 : 0)
                                        .animation(.easeInOut(duration: 0.2), value: isBuy)
                                }
                            }
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0.1, y: 0.1)
                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0, y: -0.1)
                        
                        
                        
                        HStack(spacing: 20) {

                            Button {
                                if quantity > 1 {
                                    quantity -= 1
                                }
                            } label: {
                                Image(systemName: "minus")
                                    .font(.system(size: 17,weight: .semibold))
                                    .foregroundColor(.white)
                            }

                            Text(arabicNumber(quantity))
                                .font(.system(size: 22,weight: .bold))
                                .foregroundColor(.white)

                            Button {
                                quantity += 1
                            } label: {
                                Image(systemName: "plus")
                                    .font(.system(size: 17,weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }.padding(.horizontal,16)
                        .background(
                            Color.gray.opacity(0.2)
                                .frame(width: 112,height: 44)
                                .cornerRadius(100)
                        )
                        
                    }//vLeft
                }//hAll
                //.padding(.top, 50)
                .padding(.horizontal,16)
                .environment(\.layoutDirection, .rightToLeft)
                .foregroundColor(.white)

                Spacer().frame(height: 82)
                
                PrimaryButton(title: isBuy ? "اشتر" : "بع") {

                    if isBuy {
                        let cost = company.stock.currentPrice * Double(quantity)
                        
                        if walletState.balance >= cost {
                            _ = vm.buyStock(company: company, count: quantity)
                            onBalanceChanged(-cost)
                            onSuccess("كفو! السهم صار بمحفظتك")
                            dismiss()
                        } else {
                            onSuccess("فلوسك غير كافية")
                            dismiss()
                        }
                    } else {
                        if vm.sellStock(company: company, count: quantity) {
                            let revenue = company.stock.currentPrice * Double(quantity)
                            onBalanceChanged(revenue)
                            onSuccess("تم بيع السهم بنجاح")
                            dismiss()
                        } else {
                            onSuccess("ما عندك أسهم كافية للبيع")
                            dismiss()
                        }
                    }
                }

                Spacer()
                            }//vMain
            
            

            if showErrorPopup {

                Color.black.opacity(0.5)
                    .ignoresSafeArea()

                VStack(spacing: 20) {

                    Text("عملية خاطئة")
                        .font(.title2.bold())
                        .foregroundColor(.white)

                    Text(errorMessage)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)

                    HStack(spacing: 12) {

                        Button("إلغاء") {
                            showErrorPopup = false
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white.opacity(0.1))
                        .foregroundColor(.white)
                        .cornerRadius(25)

                        PrimaryButton(title: "حسنًا") {
                            showErrorPopup = false
                        }
                    }

                }
                .padding(24)
                .frame(width: 320)
                .background(Color.black)
                .cornerRadius(28)
            }
                        }
                    }
                }
    
