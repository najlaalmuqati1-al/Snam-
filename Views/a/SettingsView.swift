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

    @State private var navigateToWalletAppearance = false
    @State private var showLanguagePicker = false

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
                // ── Navigation Header ────────────────────────────────
                navigationHeader

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
                                    )
                                )
                            ]
                        )

                        // ── General Section ──────────────────────────
                        settingsGroup(
                            title: "إعدادات عامة",
                            items: [
                                SettingsItem(
                                    icon: "globe",
                                    iconColor: .gray,
                                    title: "اللغة",
                                    destination: AnyView(LanguageSettingsHelperView())
                                ),
                                SettingsItem(
                                    icon: "sun.max.fill",
                                    iconColor: .gray,
                                    title: "شكل التطبيق",
                                    destination: AnyView(AppearanceSettingsHelperView())
                                ),
                                SettingsItem(
                                    icon: "shield.fill",
                                    iconColor: .gray,
                                    title: "الخصوصية والأمان",
                                    destination: AnyView(PrivacySecurityView())
                                ),
                            ]
                        )

                        Spacer().frame(height: 60)
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 26)
                }
            }
        }
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .leftToRight)
    }

    // MARK: - Navigation Header
    private var navigationHeader: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color.secondary.opacity(0.12))
                    .clipShape(Circle())
            }

            Spacer()

            Text("الإعدادات")
                .font(svArabic("Bold", size: 22))
                .foregroundColor(.primary)

            Spacer()

            // Balance spacer
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 22)
        .padding(.top, 18)
        .padding(.bottom, 10)
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
            Image(systemName: "chevron.left")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.secondary)

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

// MARK: - Language Settings Helper View
struct LanguageSettingsHelperView: View {
    @Environment(\.dismiss) private var dismiss

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
            VStack(spacing: 22) {
                header(title: "اللغة")
                Text("لتغيير لغة التطبيق، افتح إعدادات النظام، ثم ابحث عن تطبيق سنام واختر اللغة المفضّلة.")
                    .font(svArabic("Regular", size: 18))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                Button(action: openAppSettings) {
                    Text("فتح إعدادات التطبيق")
                        .font(svArabic("Bold", size: 18))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 26)

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .leftToRight)
    }

    private func header(title: String) -> some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color.secondary.opacity(0.12))
                    .clipShape(Circle())
            }
            Spacer()
            Text(title)
                .font(svArabic("Bold", size: 22))
                .foregroundColor(.primary)
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 22)
        .padding(.top, 18)
        .padding(.bottom, 10)
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - Appearance Settings Helper View
struct AppearanceSettingsHelperView: View {
    @Environment(\.dismiss) private var dismiss

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
            VStack(spacing: 22) {
                header(title: "شكل التطبيق")
                Text("لتغيير المظهر (فاتح/داكن) أو الاعتماد على مظهر النظام، افتح إعدادات التطبيق من إعدادات النظام.")
                    .font(svArabic("Regular", size: 18))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 28)

                Button(action: openAppSettings) {
                    Text("فتح إعدادات التطبيق")
                        .font(svArabic("Bold", size: 18))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 26)

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .leftToRight)
    }

    private func header(title: String) -> some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundColor(.primary)
                    .frame(width: 44, height: 44)
                    .background(Color.secondary.opacity(0.12))
                    .clipShape(Circle())
            }
            Spacer()
            Text(title)
                .font(svArabic("Bold", size: 22))
                .foregroundColor(.primary)
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }
        .padding(.horizontal, 22)
        .padding(.top, 18)
        .padding(.bottom, 10)
    }

    private func openAppSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

// MARK: - Privacy & Security Screen
struct PrivacySecurityView: View {
    @Environment(\.dismiss) private var dismiss

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
                // Header
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 44, height: 44)
                            .background(Color.secondary.opacity(0.12))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("الخصوصية والأمان")
                        .font(svArabic("Bold", size: 24))
                        .foregroundColor(.primary)

                    Spacer()

                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 22)
                .padding(.top, 18)
                .padding(.bottom, 10)

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

                        // فقرات بتعداد رقمي والرقم على اليسار
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
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .leftToRight)
        // يمكنك إزالة هذا السطر إذا أردت أن تتبع هذه الشاشة مظهر النظام تلقائياً
        //.preferredColorScheme(.dark)
    }

    // فقرة بتعداد رقمي والرقم في الجهة اليسار
    private func numberedSectionRow(number: Int, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 6) {
            // العمود النصي بمحاذاة يمين
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
