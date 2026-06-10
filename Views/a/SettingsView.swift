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
                    VStack(alignment: .trailing, spacing: 28) {

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

                        Spacer().frame(height: 40)
                    }
                    .padding(.top, 20)
                    .padding(.horizontal, 24)
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
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }

            Spacer()

            Text("الإعدادات")
                .font(svArabic("Bold", size: 18))
                .foregroundColor(.white)

            Spacer()

            // Balance spacer
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Settings Group Builder
    @ViewBuilder
    private func settingsGroup(title: String, items: [SettingsItem]) -> some View {
        VStack(alignment: .trailing, spacing: 0) {
            // Section Title
            Text(title)
                .font(svArabic("Bold", size: 20))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.bottom, 12)

            // Group Card
            VStack(spacing: 0) {
                ForEach(items.indices, id: \.self) { index in
                    NavigationLink(destination: items[index].destination) {
                        settingsRow(item: items[index])
                    }
                    .buttonStyle(PlainButtonStyle())

                    if index < items.count - 1 {
                        Rectangle()
                            .fill(Color.white.opacity(0.07))
                            .frame(height: 1)
                            .padding(.leading, 16)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .stroke(Color.gray.opacity(0.35), lineWidth: 1)
                    )
            )
        }
    }

    // MARK: - Settings Row
    @ViewBuilder
    private func settingsRow(item: SettingsItem) -> some View {
        HStack(spacing: 14) {
            Image(systemName: "chevron.left")
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white.opacity(0.3))

            Spacer()

            Text(item.title)
                .font(svArabic("Medium", size: 16))
                .foregroundColor(.white)

            Image(systemName: item.icon)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
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
            VStack(spacing: 18) {
                header(title: "اللغة")
                Text("لتغيير لغة التطبيق، افتح إعدادات النظام، ثم ابحث عن تطبيق سنام واختر اللغة المفضّلة.")
                    .font(svArabic("Regular", size: 16))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Button(action: openAppSettings) {
                    Text("فتح إعدادات التطبيق")
                        .font(svArabic("Bold", size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 24)

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
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
            Spacer()
            Text(title)
                .font(svArabic("Bold", size: 18))
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
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
            VStack(spacing: 18) {
                header(title: "شكل التطبيق")
                Text("لتغيير المظهر (فاتح/داكن) أو الاعتماد على مظهر النظام، افتح إعدادات التطبيق من إعدادات النظام.")
                    .font(svArabic("Regular", size: 16))
                    .foregroundColor(.white.opacity(0.85))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)

                Button(action: openAppSettings) {
                    Text("فتح إعدادات التطبيق")
                        .font(svArabic("Bold", size: 16))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.white)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 24)

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
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .clipShape(Circle())
            }
            Spacer()
            Text(title)
                .font(svArabic("Bold", size: 18))
                .foregroundColor(.white)
            Spacer()
            Color.clear.frame(width: 40, height: 40)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
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
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(10)
                            .background(Color.white.opacity(0.08))
                            .clipShape(Circle())
                    }

                    Spacer()

                    Text("الخصوصية والأمان")
                        .font(svArabic("Bold", size: 20))
                        .foregroundColor(.white)

                    Spacer()

                    Color.clear.frame(width: 40, height: 40)
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 8)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .trailing, spacing: 24) {
                        // Title block
                        VStack(alignment: .trailing, spacing: 14) {
                            Text("سياسة الخصوصية والأمان")
                                .font(svArabic("Bold", size: 34))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.trailing)

                            Text("نحن نهتم بأن خصوصيتك هي داخل اهتمامنا. لقد صممنا هذه التجربة التصميمة لكي تكون مساحة خالية من التتبع، حيث نحترم بياناتك ونحافظ على أمانها. توضح هذه السياسة كيف نتعامل مع بياناتك داخل التطبيق بشكل مبسط.")
                                .font(svArabic("Regular", size: 17))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.trailing)
                                .lineSpacing(5)
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.horizontal, 24)
                        .padding(.top, 12)

                        // فقرات بتعداد رقمي والرقم على اليسار
                        VStack(alignment: .trailing, spacing: 22) {
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
                        .padding(.horizontal, 24)

                        Spacer().frame(height: 24)
                    }
                    .padding(.bottom, 28)
                }
            }
        }
        .navigationBarHidden(true)
        .environment(\.layoutDirection, .leftToRight)
        .preferredColorScheme(.dark)
    }

    // فقرة بتعداد رقمي والرقم في الجهة اليسار
    private func numberedSectionRow(number: Int, title: String, subtitle: String) -> some View {
        HStack(alignment: .top, spacing: 2) {
            // العمود النصي بمحاذاة يمين
            VStack(alignment: .trailing, spacing: 2) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(svArabic("Bold", size: 20))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.trailing)
                        .frame(maxWidth: .infinity, alignment: .trailing)

                    Text("") // نقطة يمكن وضعها هنا إذا رغبت
                        .font(svArabic("Bold", size: 22))
                        .foregroundColor(.white.opacity(0.95))
                        .padding(.top, 0)
                }

                Text(subtitle)
                    .font(svArabic("Regular", size: 17))
                    .foregroundColor(.white.opacity(0.82))
                    .lineSpacing(5)
                    .multilineTextAlignment(.trailing)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)

            Spacer(minLength: 8)

            Text("\(number)")
                .font(svArabic("Bold", size: 22))
                .foregroundColor(.white.opacity(0.95))
                .padding(.top, 2)
                .frame(minWidth: 24, alignment: .leading)
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
