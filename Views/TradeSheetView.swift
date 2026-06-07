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
                    .background(Color.black.opacity(0.95))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.08))
                    )
                    .cornerRadius(16)
                    .padding(.horizontal, 20)

                    Spacer()
                }
                .padding(.top, -40)
                .zIndex(999)
            }

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

                HStack(alignment: .top) {

                    VStack(alignment: .trailing, spacing: 40) {

                        Text("الكمية التي تم تداولها مسبقاً")

                        Text("نوع العملية")

                        Text("الكمية المرادة")
                    }
                    .foregroundColor(.white)
                    .font(.title3)

                    Spacer()

                    VStack(spacing: 28) {

                        Text("\(vm.ownedShares[company.id, default: 0]) من أسهم")
                            .foregroundColor(.white)

                        HStack(spacing: 0) {

                            Button("بيع") {
                                isBuy = false
                            }
                            .frame(width: 90,height: 44)
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
                .padding(.horizontal,24)
                .environment(\.layoutDirection, .rightToLeft)
                .foregroundColor(.white)

                PrimaryButton(title: isBuy ? "اشتر" : "بع") {

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
                }
                .padding(.horizontal)

                Spacer()
                            }
            if showSuccessToast {

                VStack {

                    HStack {

                        Button {
                            showSuccessToast = false
                        } label: {
                            Image(systemName: "xmark")
                                .foregroundColor(.white)
                                .font(.title3)
                        }

                        Spacer()

                        Text(toastMessage)
                            .foregroundColor(.white)
                            .font(.headline)

                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                            .font(.title2)

                    }
                    .padding()
                    .background(Color(red: 0.12, green: 0.12, blue: 0.12))
                    .cornerRadius(16)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    Spacer()
                }
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
    

