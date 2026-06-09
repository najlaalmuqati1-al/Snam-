//
//  WalletAppearanceView.swift
//  snam
//
//  Created by Faitmh ibrahim on 21/12/1447 AH.
//

import SwiftUI

// MARK: - Wallet Appearance View (Updated to use shared WalletState)
struct WalletAppearanceView: View {
    @Environment(\.dismiss) private var dismiss

    /// Passed from SettingsView — the single source of truth
    @ObservedObject var walletState: WalletState

    /// Local draft — only committed on checkmark tap
    @State private var draftName: String = ""
    @State private var draftThemeID: Int = 0
    @FocusState private var isNameFocused: Bool

    @State private var showUnsavedAlert: Bool = false

    private var hasChanges: Bool {
        draftName != walletState.holderName || draftThemeID != walletState.selectedThemeID
    }

    private var previewTheme: CardTheme {
        CardTheme.allThemes.first(where: { $0.id == draftThemeID }) ?? CardTheme.allThemes[0]
    }

    private func svArabic(_ weight: String, size: CGFloat) -> Font {
        .custom("SVArabic-\(weight)", size: size, relativeTo: .body)
    }

    var body: some View {
        ZStack {
            Color(hex: "0D0D1A").ignoresSafeArea()

            VStack(spacing: 0) {
                navigationHeader

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        currentWalletSection
                        nameSection
                        themeSelectorSection
                        Spacer().frame(height: 100)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .leftToRight)
        .onAppear {
            draftName    = walletState.holderName
            draftThemeID = walletState.selectedThemeID
        }
        // Apple-style system alert
        .alert("تبي تطلع بدون حفظ؟", isPresented: $showUnsavedAlert) {
            Button("تراجع", role: .cancel) {
                // just dismiss the alert
            }
            Button("اطلع", role: .destructive) {
                // Exit without saving → go back to MainView
                walletState.requestDismissToMain = true
            }
        } message: {
            Text("التعديلات اللي سويتها على المحفظة ما انحفظت، متأكد تبي تطلع؟")
        }
    }

    // MARK: - Navigation Header
    private var navigationHeader: some View {
        HStack(spacing: 12) {
            Button(action: {
                if hasChanges {
                    withAnimation(.easeInOut(duration: 0.2)) { showUnsavedAlert = true }
                } else {
                    // No changes → just go back to MainView as requested
                    walletState.requestDismissToMain = true
                }
            }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }

            Spacer(minLength: 12)

            Text("شكل محفظتك")
                .font(svArabic("Bold", size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)

            Spacer(minLength: 12)

            if hasChanges {
                Button(action: saveChangesAndClose) {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 36, height: 36)
                            .overlay(Circle().stroke(Color.white.opacity(0.25), lineWidth: 1))
                            .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 2)
                        Image(systemName: "checkmark")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .transition(.opacity .combined(with: .scale))
            } else {
                Color.clear.frame(width: 36, height: 36)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 12)
        .animation(.easeInOut(duration: 0.2), value: hasChanges)
    }

    // MARK: - Save → writes to shared WalletState (reflects instantly on MainView)
    private func saveChanges() {
        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
            walletState.holderName      = draftName.isEmpty ? walletState.holderName : draftName
            walletState.selectedThemeID = draftThemeID
        }
        isNameFocused = false
    }

    // Save + trigger toast + go back to MainView
    private func saveChangesAndClose() {
        saveChanges()
        withAnimation(.spring(response: 0.45, dampingFraction: 0.9)) {
            walletState.showWalletSavedToast = true
        }
        // Ask MainView to dismiss Settings stack → back to MainView
        walletState.requestDismissToMain = true
    }

    // MARK: - Preview Card
    private var currentWalletSection: some View {
        VStack(alignment: .trailing, spacing: 16) {
            Text("محفظتك الحاليه")
                .font(svArabic("Bold", size: 22))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 24)
                .padding(.top, 24)

            WalletCardView(
                theme: previewTheme,
                holderName: draftName.isEmpty ? " " : draftName
            )
            .padding(.horizontal, 24)
            .animation(.spring(response: 0.45, dampingFraction: 0.75), value: draftThemeID)
            .animation(.easeInOut(duration: 0.2), value: draftName)
        }
    }

    // MARK: - Name Field
    private var nameSection: some View {
        VStack(alignment: .trailing, spacing: 10) {
            Text("اسمك")
                .font(svArabic("Medium", size: 15))
                .foregroundColor(.white.opacity(0.85))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 12)

            TextField("", text: $draftName)
                .font(svArabic("Regular", size: 16))
                .foregroundColor(.white)
                .multilineTextAlignment(.trailing)
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.clear)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(
                                    isNameFocused
                                    ? LinearGradient(
                                        colors: [Color.white.opacity(0.45), Color.white.opacity(0.20)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing)
                                    : LinearGradient(
                                        colors: [Color.white.opacity(0.25), Color.white.opacity(0.10)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing),
                                    lineWidth: 1.0
                                )
                        )
                        .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 2)
                )
                .focused($isNameFocused)
                .submitLabel(.done)
                .onSubmit { isNameFocused = false }
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
    }

    // MARK: - Theme Selector
    private var themeSelectorSection: some View {
        VStack(alignment: .center, spacing: 20) {
            Text("اختر شكل المحفظة اللي ودك فيه")
                .font(svArabic("Bold", size: 18))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 24)
                .padding(.top, 24)

            VStack(spacing: 20) {
                ForEach(CardTheme.allThemes) { theme in
                    ThemeOptionRow(
                        theme: theme,
                        holderName: draftName.isEmpty ? " " : draftName,
                        isSelected: theme.id == draftThemeID
                    ) {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                            draftThemeID = theme.id
                        }
                    }
                    .padding(.horizontal, 24)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.bottom, 8)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        WalletAppearanceView(walletState: WalletState())
    }
}
