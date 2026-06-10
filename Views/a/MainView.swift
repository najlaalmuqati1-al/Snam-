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
    let changePercent: Double
    let chartPoints: [Double]
    let logoImageName: String
}

// MARK: - Sample / Placeholder Data
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

// MARK: - Main View
struct MainView: View {
    @EnvironmentObject var walletState: WalletState

    @State private var showSettings = false
    @State private var stocks: [FKStock] = FKStock.sampleStocks

    private func svArabic(_ weight: String, size: CGFloat) -> Font {
        .custom("SVArabic-\(weight)", size: size, relativeTo: .body)
    }

    var body: some View {
        // ← حذفنا NavigationStack من هنا
        ZStack(alignment: .top) {

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    headerBar
                    walletCardSection
                        .padding(.top, 20)
                    stocksSection
                        .padding(.top, 28)
                    Spacer().frame(height: 100)
                }
            }

            if walletState.showWalletSavedToast {
                walletSavedToast
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 8)
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .navigationDestination(isPresented: $showSettings) { // يحتاج تعديل الخلفيه نفس اللي هنا
               SettingsView()
                   .environmentObject(walletState)
           }
        .onChange(of: walletState.showWalletSavedToast) { _, isShown in
            if isShown {
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.9)) {
                        walletState.showWalletSavedToast = false
                    }
                }
            }
        }
    }

    // MARK: - Header Bar
    private var headerBar: some View {
        HStack(alignment: .center) {
            Button(action: { showSettings = true }) {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(.white.opacity(0.75))
                    .padding(10)
                    .background(Color.white.opacity(0.07))
                    .clipShape(Circle())
            }
            Spacer()
            Text("محفظتك")
                .font(svArabic("Bold", size: 26))
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
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
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .padding(.bottom, 16)

            Rectangle()
                .fill(Color.white.opacity(0.07))
                .frame(height: 1)
                .padding(.horizontal, 24)

            VStack(spacing: 0) {
                ForEach(stocks) { stock in
                    StockRowView(stock: stock)
                    if stock.id != stocks.last?.id {
                        Rectangle()
                            .fill(Color.white.opacity(0.06))
                            .frame(height: 1)
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }

    // MARK: - Toast View
    private var walletSavedToast: some View {
        HStack(spacing: 10) {
            Button(action: {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.9)) {
                    walletState.showWalletSavedToast = false
                }
            }) {
                Image(systemName: "xmark")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                    .frame(width: 28, height: 28)
                    .background(Color.white.opacity(0.12))
                    .clipShape(Circle())
            }
            Spacer(minLength: 10)
            Text("اعتمدنا الشكل الجديد!!!")
                .font(svArabic("Bold", size: 16))
                .foregroundColor(.white)
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
                .font(.system(size: 20, weight: .bold))
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.black.opacity(0.85))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
                )
        )
        .padding(.horizontal, 16)
        .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 6)
    }
}

// MARK: - Stock Row
struct StockRowView: View {
    let stock: FKStock

    private func svArabic(_ weight: String, size: CGFloat) -> Font {
        .custom("SVArabic-\(weight)", size: size, relativeTo: .body)
    }

    private var isPositive: Bool { stock.changePercent >= 0 }
    private var changeColor: Color { isPositive ? Color(hex: "22C55E") : Color(hex: "EF4444") }

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 3) {
                Text("\(Int(stock.price))")
                    .font(svArabic("Bold", size: 17))
                    .foregroundColor(.white)
                Text("\(isPositive ? "+" : "")\(String(format: "%.2f", stock.changePercent))%")
                    .font(svArabic("Medium", size: 13))
                    .foregroundColor(changeColor)
            }
            .frame(width: 70, alignment: .leading)

            SimpleTrendLineView(isUp: isPositive, color: changeColor)
                .frame(width: 80, height: 36)

            Spacer()

            HStack(spacing: 10) {
                VStack(alignment: .trailing, spacing: 3) {
                    Text(stock.name)
                        .font(svArabic("Bold", size: 16))
                        .foregroundColor(.white)
                    Text(stock.sector)
                        .font(svArabic("Regular", size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 44, height: 44)
                    Image(stock.logoImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .clipShape(Circle())
                }
            }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
    }
}

// MARK: - Simple single up/down line
struct SimpleTrendLineView: View {
    let isUp: Bool
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let start = CGPoint(x: 0, y: isUp ? h * 0.80 : h * 0.20)
            let end   = CGPoint(x: w, y: isUp ? h * 0.20 : h * 0.80)

            let linePath: Path = {
                var p = Path()
                p.move(to: start)
                p.addLine(to: end)
                return p
            }()

            let fillPath: Path = {
                var p = linePath
                p.addLine(to: CGPoint(x: end.x, y: h))
                p.addLine(to: CGPoint(x: start.x, y: h))
                p.closeSubpath()
                return p
            }()

            ZStack {
                fillPath
                    .fill(
                        LinearGradient(
                            colors: [color.opacity(0.20), color.opacity(0.02)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(0.7)
                linePath
                    .stroke(color.opacity(0.9), style: StrokeStyle(lineWidth: 2.0, lineCap: .round))
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(WalletState())
}
