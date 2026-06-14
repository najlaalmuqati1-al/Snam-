//
//  MainView.swift
//  snam
//
//  Created by Faitmh ibrahim on 21/12/1447 AH.
//

import SwiftUI

// MARK: - FKStock Model (inlined in this file)
struct FKStock: Identifiable {
    let id = UUID()
    let name: String
    let sector: String
    let price: Double
    let changePercent: Double   // e.g. +1.23 or -0.87
    let chartPoints: [Double]   // mini sparkline values
    let logoImageName: String   // Asset name
}

// MARK: - Sample / Placeholder Data

/**
 
extension FKStock {
    static let sampleStocks: [FKStock] = [
        FKStock(
            name: "بيرن اكس",
            sector: "قطاع التقنية",
            price: 1234,
            changePercent: +1.23,
            chartPoints: [10, 14, 11, 16, 13, 18, 15, 20, 17, 22],
            logoImageName: "logo_bernx"
        ),
        FKStock(
            name: "الراجحي",
            sector: "قطاع المال",
            price: 1234,
            changePercent: +1.23,
            chartPoints: [12, 11, 14, 13, 16, 14, 18, 16, 20, 19],
            logoImageName: "logo_rajhi"
        ),
        FKStock(
            name: "ارامكو",
            sector: "قطاع الطاقة",
            price: 1234,
            changePercent: -1.23,
            chartPoints: [20, 18, 19, 15, 17, 14, 16, 12, 14, 11],
            logoImageName: "logo_aramco"
        ),
        FKStock(
            name: "سابك",
            sector: "قطاع الطاقة",
            price: 1234,
            changePercent: +1.23,
            chartPoints: [10, 12, 11, 15, 13, 17, 14, 19, 16, 21],
            logoImageName: "logo_sabic"
        ),
    ]
}

 */
// MARK: - Main View
struct MainView: View {
    @EnvironmentObject var walletState: WalletState

    @State private var showSettings = false
 //   @State private var stocks: [FKStock] = FKStock.sampleStocks
    @EnvironmentObject var marketVM: MarketViewModelNew

    private var ownedCompanies: [Company] {
          marketVM.marketData?.companies.filter {
              (marketVM.ownedShares[$0.id, default: 0]) > 0
          } ?? []
      }
    
    // Convenience
    private func svArabic(_ weight: String, size: CGFloat) -> Font {
        .custom("SVArabic-\(weight)", size: size, relativeTo: .body)
    }
    

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // ── Background ──────────────────────────────────────────
                Color(.systemBackground)
                    .ignoresSafeArea()
                    .overlay(
                        Image("Frame")
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                    )

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 32) {

                        // ── Top Header ──────────────────────────────────
                        headerBar
                        
                        // ── Wallet Card ─────────────────────────────────
                        walletCardSection
                            .padding(.top, 20)

                        // ── Stocks Section ──────────────────────────────
                        stocksSection
                            .padding(.top, 28)

                        // Space for tab bar
                        Spacer().frame(height: 100)
                    }
                }

                // ── Toast overlay (top) ────────────────────────────────
                if walletState.showWalletSavedToast {
                    walletSavedToast
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.top, 8)
                }
            }
            .navigationBarHidden(true)
            .environment(\.layoutDirection, .leftToRight)
            // Navigate to Settings when gear tapped
            .navigationDestination(isPresented: $showSettings) {
                SettingsView()
                    .environmentObject(walletState)
            }
            // Auto-hide toast after 5 seconds when it appears
            .onChange(of: walletState.showWalletSavedToast) { _, isShown in
                if isShown {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                            walletState.showWalletSavedToast = false
                        }
                    }
                }
            }
            // Listen for requests to dismiss back to MainView from nested screens
            .onChange(of: walletState.requestDismissToMain) { _, shouldDismiss in
                if shouldDismiss {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showSettings = false
                    }
                    // reset the flag
                    DispatchQueue.main.async {
                        walletState.requestDismissToMain = false
                    }
                }
            }
        }
    }

    // MARK: - Header Bar
    private var headerBar: some View {
        HStack(alignment: .center) {
            // Settings gear
            Button(action: { showSettings = true }) {
                
                ZStack{
                    Circle()
                        .frame(width: 44,height: 44)
                        .foregroundStyle(.black)
                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: 0, y: 0.1)
                        .shadow(color: Color.white.opacity(1), radius: 0.1, x: -0.1, y: -0.1)
                        .glassEffect()
                    
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(.white)
                }//z
            }//b

            Spacer()

            Text("محفظتك")
                .font(.system(size: 36,weight: .black))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
    }

    // MARK: - Wallet Card Section
    private var walletCardSection: some View {
        WalletCardView(
            theme: walletState.selectedTheme,
            holderName: walletState.holderName
        )
        .frame(height: 180)
        .padding(.horizontal, 24)
        .animation(.spring(response: 0.45, dampingFraction: 0.78), value: walletState.selectedThemeID)
        .animation(.easeInOut(duration: 0.25), value: walletState.holderName)
    }

    // MARK: - Stocks Section
    private var stocksSection: some View {
        VStack(alignment: .trailing, spacing: 0) {
            Text("أسهمك")
                .font(svArabic("Bold", size: 22))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

            Rectangle()
                .fill(Color.primary.opacity(0.12))
                .frame(height: 1)
                .padding(.horizontal, 24)

            if ownedCompanies.isEmpty {
                Text("ما عندك أسهم بعد، اشتري من المحاكي!")
                    .font(svArabic("Regular", size: 14))
                    .foregroundColor(.secondary)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity, alignment: .center)
            } else {
                VStack(spacing: 0) {
                    ForEach(ownedCompanies) { company in
                        CompanyRowView(company: company, shares: marketVM.ownedShares[company.id, default: 0])

                        if company.id != ownedCompanies.last?.id {
                            Rectangle()
                                .fill(Color.primary.opacity(0.1))
                                .frame(height: 1)
                                .padding(.horizontal, 24)
                        }
                    }
                }
            }
        }
    }

    // MARK: - Toast View
    private var walletSavedToast: some View {
        HStack(spacing: 10) {
            // Close X (optional dismiss)
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    walletState.showWalletSavedToast = false
                }
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.primary)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 28, height: 28)
                    .background(Color.secondary.opacity(0.15))
                    .clipShape(Circle())
            }

            Spacer(minLength: 10)

            Text("اعتمدنا الشكل الجديد!!!")
                .font(svArabic("Bold", size: 16))
                .foregroundColor(.primary)

            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 20, weight: .bold))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.primary.opacity(0.12), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 6)
    }
}

// MARK: - Stock Row (simple single trend line)
struct CompanyRowView: View {
    let company: Company
    let shares: Int

    private func svArabic(_ weight: String, size: CGFloat) -> Font {
        .custom("SVArabic-\(weight)", size: size, relativeTo: .body)
    }

    var body: some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(arabicNumber(Int(company.stock.currentPrice)))                    .font(svArabic("Bold", size: 17))
                    .foregroundColor(.primary)
                Text("\(arabicNumber(shares)) أسهم")                    .font(svArabic("Medium", size: 13))
                    .foregroundColor(.secondary)
            }
            .frame(width: 70, alignment: .leading)

            HStack(spacing: 10) {
                VStack(alignment: .trailing, spacing: 3) {
                    Text(company.fakeName)
                        .font(svArabic("Bold", size: 16))
                        .foregroundColor(.primary)
                    Text(sectorArabicNew(company.sector))
                        .font(svArabic("Regular", size: 12))
                        .foregroundColor(.secondary)
                }
                Text(
                    company.fakeName == "Najd Energy" ? "⚡️" :
                    company.fakeName == "Desert Bank" ? "🏦" :
                    company.fakeName == "Najd Telecom" ? "📡" :
                    company.fakeName == "Souq Arabia" ? "🛍️" :
                    company.fakeName == "NeoTech KSA" ? "💻" :
                    company.fakeName == "Palm Foods" ? "🌴" :
                    company.fakeName == "Golden Cement" ? "🏗️" :
                    company.fakeName == "Sky Airlines" ? "✈️" :
                    company.fakeName == "Future Health" ? "🏥" :
                    "🚚"
                )
                .font(.system(size: 24))
                .frame(width: 30, height: 30)
                
                .clipShape(Circle())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
    }
}

#Preview {
    MainView()
        .environmentObject(WalletState())
        .environmentObject(MarketViewModelNew())
}
