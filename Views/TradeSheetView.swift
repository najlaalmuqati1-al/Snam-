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

    @Environment(\.dismiss) var dismiss

    @State private var quantity = 1
    @State private var isBuy = true
    @State private var showSuccessToast = false
    @State private var toastMessage = ""

    @State private var showErrorPopup = false
    @State private var errorMessage = ""

    var body: some View {

        ZStack {

            Color.black
                .ignoresSafeArea()

            VStack(spacing: 24) {


                Capsule()
                    .fill(.gray.opacity(0.5))
                    .frame(width: 50,height: 5)
                    .padding(.top)

                Text("صفحة تداول")
                    .font(.headline)
                    .foregroundColor(.white)

                Text(String(format: "%.2f", company.stock.currentPrice))
                    .font(.system(size: 52, weight: .black))
                    .foregroundColor(.white)

                Text("سعر السهم")
                    .foregroundColor(.gray)

                Text("\(vm.ownedShares[company.id, default: 0]) سهم")
                    .foregroundColor(.white.opacity(0.7))

                HStack(spacing: 12) {

                    Button("بيع") {
                        isBuy = false
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(isBuy ? .clear : Color.white.opacity(0.15))
                    .cornerRadius(20)

                    Button("شراء") {
                        isBuy = true
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 40)
                    .background(isBuy ? Color.white.opacity(0.15) : .clear)
                    .cornerRadius(20)

                }
                .foregroundColor(.white)
                .padding(.horizontal)

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

                Button {

                    if isBuy {

                        if vm.buyStock(company: company, count: quantity) {

                            toastMessage = "تم شراء السهم بنجاح"
                            showSuccessToast = true

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                dismiss()
                            }

                        } else {

                            errorMessage = "ليس لديك رصيد كافٍ"
                            showErrorPopup = true
                        }

                    } else {

                        if vm.sellStock(company: company, count: quantity) {

                            toastMessage = "تم بيع السهم بنجاح"
                            showSuccessToast = true

                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                dismiss()
                            }

                        } else {

                            errorMessage = "لا تملك أسهماً كافية للبيع"
                            showErrorPopup = true
                        }
                    }

                } label: {

                    Text(isBuy ? "اشتر" : "بع")
                        .font(.headline.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(Color.blue)
                        .cornerRadius(28)

                }
                .padding(.horizontal)

                Spacer()
                            }

                            if showSuccessToast {
                                VStack {
                                    HStack {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)

                                        Text(toastMessage)
                                            .foregroundColor(.white)

                                        Spacer()
                                    }
                                    .padding()
                                    .background(Color.black.opacity(0.9))
                                    .cornerRadius(12)
                                    .padding()

                                    Spacer()
                                }
                            }

                            if showErrorPopup {

                                Color.black.opacity(0.4)
                                    .ignoresSafeArea()

                                VStack(spacing: 16) {

                                    Text("عملية خاطئة")
                                        .font(.headline)
                                        .bold()
                                        .foregroundColor(.white)

                                    Text(errorMessage)
                                        .foregroundColor(.white.opacity(0.7))
                                        .multilineTextAlignment(.center)

                                    Button("حسنًا") {
                                        showErrorPopup = false
                                    }
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .background(Color.blue)
                                    .cornerRadius(8)

                                }
                                .padding()
                                .frame(width: 280)
                                .background(Color.black)
                                .cornerRadius(16)
                            }
                        }
                    }
                }
    

