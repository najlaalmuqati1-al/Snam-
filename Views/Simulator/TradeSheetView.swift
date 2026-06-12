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

            VStack(spacing: 24) {


                Capsule()
                    .fill(.gray.opacity(0.5))
                    .frame(width: 50,height: 5)
                    .padding(.top)

                Text("صفحة تداول")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.top, 20)

                Text(String(format: "%.2f", company.stock.currentPrice))
                    .font(.system(size: 64, weight: .black))
                    .foregroundColor(.white)
                    .padding(.top, 35)

                Text("سنام")
                    .font(.system(size: 18))
                    .foregroundColor(.gray)

                

                HStack(alignment: .top) {

                    VStack(alignment: .trailing, spacing: 50) {

                        Text("الكمية التي تم تداولها مسبقاً")

                        Text("نوع العملية")

                        Text("الكمية المرادة")
                    }
                    .foregroundColor(.white)
                    .font(.title3)

                    Spacer()

                    VStack(spacing: 40) {

                        Text("\(vm.ownedShares[company.id, default: 0]) من أسهم")
                            .foregroundColor(.white)

                        HStack(spacing: 0) {

                            Button("بيع") {
                                isBuy = false
                            }
                            .frame(width: 95, height: 48)
                            .background(isBuy ? .clear : Color.white.opacity(0.15))

                            Button("شراء") {
                                isBuy = true
                            }
                            .frame(width: 90,height: 44)
                            .background(isBuy ? Color.white.opacity(0.15) : .clear)
                        }
                        .foregroundColor(.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(Color.white.opacity(0.15))
                        )
                        .clipShape(Capsule())

                        HStack(spacing: 30) {

                            Button {
                                if quantity > 1 {
                                    quantity -= 1
                                }
                            } label: {
                                Image(systemName: "minus")
                            }

                            Text("\(quantity)")
                                .font(.title2.bold())

                            Button {
                                quantity += 1
                            } label: {
                                Image(systemName: "plus")
                            }
                        }
                        .foregroundColor(.white)
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal,24)
                .environment(\.layoutDirection, .rightToLeft)
                .foregroundColor(.white)

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
                            }
            
            

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
    

