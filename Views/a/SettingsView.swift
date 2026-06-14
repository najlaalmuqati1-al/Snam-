//
//  SettingsView.swift
//  snam
//
//  Created by Faitmh ibrahim on 21/12/1447 AH.
//

import SwiftUI

// MARK: - Settings View
struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var walletState: WalletState

    private func svArabic(_ weight: String, size: CGFloat) -> Font {
        .custom("SVArabic-\(weight)", size: size, relativeTo: .body)
    }

    var body: some View {
        ZStack {
            // Background → system background + overlay image
            Color(.systemBackground)
                .ignoresSafeArea()
                .overlay(
                    Image("Frame")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )

            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .trailing, spacing: 34) {

                        // ── Wallet Section ───────────────────────────
                        settingsGroup(
                            title: "المحفظة",
                            items: [
                                SettingsItem(
                                    icon: "paintbrush.fill",
                                    iconColor: .gray,
                                    title: "شكل محفظتك",
                                    destination: AnyView(
                                        WalletAppearanceView(walletState: walletState)
                                            .environmentObject(walletState)
                                    )
                                )
                            ]
                        )

                        // ── General Section (appearance dropdown + privacy link) ─────────
                        generalGroup

                        Spacer().frame(height: 60)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 26)
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .navigationTitle("الإعدادات")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - General Group (contains appearance dropdown + privacy link)
    private var generalGroup: some View {
        VStack(alignment: .trailing, spacing: 12) {
            Text("إعدادات عامة")
                .font(svArabic("Bold", size: 24))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 8)

            VStack(spacing: 0) {
                // 1) Appearance row (dropdown)
                appearanceRow

                // Divider
                Rectangle()
                    .fill(Color.primary.opacity(0.1))
                    .frame(height: 1)
                    .padding(.leading, 18)

                // 2) Privacy & Security row (NavigationLink)
                NavigationLink {
                    PrivacySecurityView()
                        .environmentObject(walletState)
                } label: {
                    HStack(spacing: 16) {
                        Spacer()

                        Text("الخصوصية والأمان")
                            .font(svArabic("Medium", size: 18))
                            .foregroundColor(.primary)

                        Image(systemName: "shield.fill")
                            .font(.system(size: 22, weight: .medium))
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 18)
                    .padding(.vertical, 18)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.secondary.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.primary.opacity(0.25), lineWidth: 1.0)
                    )
            )
        }
    }

    // MARK: - Appearance Row with dropdown menu
    private var appearanceRow: some View {
        HStack(spacing: 16) {
            Spacer()

            Menu {
                // خيارات المظهر (يتبع النظام/فاتح/داكن)
                ForEach(AppAppearance.allCases) { option in
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            walletState.appAppearance = option
                        }
                    } label: {
                        HStack {
                            if walletState.appAppearance == option {
                                Image(systemName: "checkmark")
                            }
                            Text(option.title)
                        }
                    }
                }
            } label: {
                HStack(spacing: 8) {
                    Text("شكل التطبيق")
                        .font(svArabic("Medium", size: 18))
                        .foregroundColor(.primary)
                    Text("(\(walletState.appAppearance.title))")
                        .font(svArabic("Regular", size: 16))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }

            Image(systemName: "sun.max.fill")
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .contentShape(Rectangle())
    }

    // MARK: - Settings Group Builder
    @ViewBuilder
    private func settingsGroup(title: String, items: [SettingsItem]) -> some View {
        VStack(alignment: .trailing, spacing: 12) {
            // Section Title
            Text(title)
                .font(svArabic("Bold", size: 24))
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 8)

            // Group Card
            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    NavigationLink(destination: items[index].destination) {
                        settingsRow(item: items[index])
                    }
                    .buttonStyle(PlainButtonStyle())

                    if index < items.count - 1 {
                        Rectangle()
                            .fill(Color.primary.opacity(0.1))
                            .frame(height: 1)
                            .padding(.leading, 18)
                    }
                }
            }
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.secondary.opacity(0.06))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(Color.primary.opacity(0.25), lineWidth: 1.0)
                    )
            )
        }
    }

    // MARK: - Settings Row
    @ViewBuilder
    private func settingsRow(item: SettingsItem) -> some View {
        HStack(spacing: 16) {
            Spacer()

            Text(item.title)
                .font(svArabic("Medium", size: 18))
                .foregroundColor(.primary)

            Image(systemName: item.icon)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 18)
        .contentShape(Rectangle())
    }
}

// MARK: - Settings Item Model
struct SettingsItem {
    let icon: String
    let iconColor: Color
    let title: String
    let destination: AnyView
}

// MARK: - Privacy & Security Screen
struct PrivacySecurityView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var walletState: WalletState

    private func svArabic(_ weight: String, size: CGFloat) -> Font {
        .custom("SVArabic-\(weight)", size: size, relativeTo: .body)
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .overlay(
                    Image("Frame")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                )

            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .trailing, spacing: 28) {
                        // Title block
                        VStack(alignment: .trailing, spacing: 16) {
                            Text("سياسة الخصوصية والأمان")
                                .font(svArabic("Bold", size: 36))
                                .foregroundColor(.primary)
                                .multilineTextAlignment(.trailing)

                            Text("نحن نهتم بأن خصوصيتك هي داخل اهتمامنا. لقد صممنا هذه التجربة التصميمة لكي تكون مساحة خالية من التتبع، حيث نحترم بياناتك ونحافظ على أمانها. توضح هذه السياسة كيف نتعامل مع بياناتك داخل التطبيق بشكل مبسط.")
                                .font(svArabic("Regular", size: 18))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.trailing)
                                .lineSpacing(6)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 26)
                        .padding(.top, 14)

                        // فقرات بتعداد رقمي
                        VStack(alignment: .trailing, spacing: 26) {
                            numberedSectionRow(
                                number: 1,
                                title: "تطبيق سنام مبني على مبدأ الخصوصية أولاً.",
                                subtitle: "لا نقوم بجمع أي بيانات شخصية حساسة مثل الاسم، عنوان، أو رقم الهاتف. يتم استخدام بيانات استخدام عامة لتحسين التجربة فقط."
                            )
                            numberedSectionRow(
                                number: 2,
                                title: "التحليلات على الجهاز",
                                subtitle: "أغلب التحليلات تتم محلياً على جهازك دون إرسال البيانات لخوادم خارجية. في حال الحاجة، يتم إخفاء هوية البيانات بالكامل."
                            )
                            numberedSectionRow(
                                number: 3,
                                title: "حفظ آمن",
                                subtitle: "تُحفظ معلومات محفظتك محلياً وبشكل مشفر. يمكنك حذفها في أي وقت من الإعدادات."
                            )
                            numberedSectionRow(
                                number: 4,
                                title: "الصلاحيات",
                                subtitle: "لا نطلب صلاحيات غير لازمة. في حال طلب صلاحية، سنوضح سبب الحاجة لها وكيفية استخدامها."
                            )
                        }
                        .padding(.horizontal, 26)

                        Spacer().frame(height: 28)
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .environment(\.layoutDirection, .leftToRight)
    }

    private func numberedSectionRow(number: Int, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            VStack(alignment: .trailing, spacing: 6) {
                HStack(spacing: 8) {
                    Text(title)
                        .font(svArabic("Bold", size: 22))
                        .foregroundColor(.primary)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    Text("")
                        .font(svArabic("Bold", size: 22))
                        .foregroundColor(.primary.opacity(0.95))
                        .padding(.top, 0)
                }

                Text(subtitle)
                    .font(svArabic("Regular", size: 18))
                    .foregroundColor(.secondary)
                    .lineSpacing(6)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Spacer(minLength: 10)

            Text("\(number)")
                .font(svArabic("Bold", size: 24))
                .foregroundColor(.primary.opacity(0.95))
                .padding(.top, 4)
                .frame(minWidth: 28, alignment: .leading)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}

// MARK: - Preview
#Preview {
    NavigationStack {
        SettingsView()
            .environmentObject(WalletState())
    }
}
