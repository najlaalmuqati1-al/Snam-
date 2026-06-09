//
//  OnboardingContainerView.swift
//  Snam
//
//  Created by Najla Almuqati on 04/12/1447 AH.
//

//import SwiftUI
//import TipKit
//
//// MARK: - 1. المتحكم بحالة المستخدم
//struct OnboardingContainerView: View {
//    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
//    
//    var body: some View {
//        Group {
//            if hasCompletedOnboarding {
//                MarketListView()
//            } else {
//                OnboardingSequentialTutorialView(hasCompletedOnboarding: $hasCompletedOnboarding)
//            }
//        }
//        .task {
//            // تصفير الكاش للـ Tips دايماً عشان تطلع بالمحاكي
//            try? Tips.resetDatastore()
//            try? Tips.configure([
//                .displayFrequency(.immediate),
//                .datastoreLocation(.applicationDefault)
//            ])
//        }
//    }
//}
//
//// MARK: - 2. شاشة الشرح التسلسلي (تصميمك العربي الفخم)
//struct OnboardingSequentialTutorialView: View {
//    @Binding var hasCompletedOnboarding: Bool
//    @State private var currentStep = 1
//    
//    private let greenTrendTip = GreenStockTip()
//    private let redTrendTip = RedStockTip()
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            
//            VStack(spacing: 0) {
//                // الهيدر
//                HStack {
//                    Image(systemName: "line.3.horizontal")
//                        .font(.system(size: 18, weight: .medium))
//                        .foregroundColor(.white)
//                        .frame(width: 44, height: 44)
//                        .background(Color.white.opacity(0.08))
//                        .clipShape(Circle())
//                    
//                    Spacer()
//                    
//                    Text("المحاكي")
//                        .font(.system(size: 28, weight: .bold))
//                        .foregroundColor(.white)
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 16)
//                .padding(.bottom, 12)
//                
//                // قائمة الكروت الحقيقية عشان الـ Preview يلقط الـ Tips غصب
//                ScrollView {
//                    VStack(spacing: 14) {
//                        
//                        // 🟢 كرت السهم الأخضر (الخطوة 1)
//                        HStack(spacing: 14) {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("1234")
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.white)
//                                Text("+ 1.23%")
//                                    .font(.system(size: 13, weight: .medium))
//                                    .foregroundColor(.green)
//                            }
//                            .frame(width: 72, alignment: .leading)
//                            
//                            Image(systemName: "chart.line.uptrend.xyaxis")
//                                .foregroundColor(.green)
//                                .font(.title3)
//                                .frame(width: 80, height: 36)
//                            
//                            Spacer()
//                            
//                            VStack(alignment: .trailing, spacing: 3) {
//                                Text("أرامكو")
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.white)
//                                Text("1234")
//                                    .font(.system(size: 12))
//                                    .foregroundColor(.gray)
//                            }
//                            
//                            Circle()
//                                .fill(Color.green.opacity(0.2))
//                                .frame(width: 46, height: 46)
//                                .overlay(Text("🌴").font(.system(size: 22)))
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 14)
//                        .background(Color.white.opacity(0.03))
//                        .cornerRadius(16)
//                        .popoverTip(greenTrendTip, arrowEdge: .bottom) // 👈 فقاعة الأخضر طالعة هنا بالـ Preview أول ما تفتح
//                        .opacity(currentStep == 1 ? 1.0 : 0.3)
//                        
//                        // 🔴 كرت السهم الأحمر (الخطوة 2)
//                        HStack(spacing: 14) {
//                            VStack(alignment: .leading, spacing: 4) {
//                                Text("1234")
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.white)
//                                Text("- 1.23%")
//                                    .font(.system(size: 13, weight: .medium))
//                                    .foregroundColor(.red)
//                            }
//                            .frame(width: 72, alignment: .leading)
//                            
//                            Image(systemName: "chart.line.downtrend.xyaxis")
//                                .foregroundColor(.red)
//                                .font(.title3)
//                                .frame(width: 80, height: 36)
//                            
//                            Spacer()
//                            
//                            VStack(alignment: .trailing, spacing: 3) {
//                                Text("الراجحي")
//                                    .font(.system(size: 16, weight: .semibold))
//                                    .foregroundColor(.white)
//                                Text("1234")
//                                    .font(.system(size: 12))
//                                    .foregroundColor(.gray)
//                            }
//                            
//                            Circle()
//                                .fill(Color.blue.opacity(0.2))
//                                .frame(width: 46, height: 46)
//                                .overlay(Text("🏦").font(.system(size: 22)))
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 14)
//                        .background(Color.white.opacity(0.03))
//                        .cornerRadius(16)
//                        .popoverTip(redTrendTip, arrowEdge: .top) // 👈 فقاعة الأحمر
//                        .opacity(currentStep == 2 ? 1.0 : 0.3)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 20)
//                }
//                
//                Spacer()
//            }
//            .background(Color(red: 14/255, green: 14/255, blue: 16/255).ignoresSafeArea())
//            
//            // الأزرار التفاعلية بالأسفل
//            VStack {
//                if currentStep == 1 {
//                    Button {
//                        withAnimation(.spring()) {
//                            greenTrendTip.invalidate(reason: .actionPerformed)
//                            currentStep = 2
//                        }
//                    } label: {
//                        Text("التالي (فهمت الصعود) ➡️")
//                            .font(.system(size: 16, weight: .bold))
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 54)
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .padding(.horizontal, 20)
//                            .padding(.bottom, 24)
//                    }
//                } else {
//                    Button {
//                        withAnimation(.spring()) {
//                            redTrendTip.invalidate(reason: .actionPerformed)
//                            hasCompletedOnboarding = true
//                        }
//                    } label: {
//                        Text("فهمت كل شيء، ابدأ المحاكاة 🚀")
//                            .font(.system(size: 16, weight: .bold))
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 54)
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .padding(.horizontal, 20)
//                            .padding(.bottom, 24)
//                    }
//                }
//            }
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// MARK: - 3. تعريف نصوص الـ Tips
//struct GreenStockTip: Tip {
//    var title: Text { Text("افهم حركة السهم") .font(.system(size: 16, weight: .bold)) }
//    var message: Text? { Text("اذا كان السهم احضر ومرتفع\n= السهم يرتفع 📈").font(.system(size: 14)) }
//}
//
//struct StockTrendTip: Tip { // مضافة فقط لتجنب أي تعارض بملفاتك الأخرى
//    var title: Text { Text("") }
//}
//
//struct RedStockTip: Tip {
//    var title: Text { Text("افهم حركة السهم") .font(.system(size: 16, weight: .bold)) }
//    var message: Text? { Text("ذا كان السهم احمر ومنخفض\n= السهم ينخفض 📉").font(.system(size: 14)) }
//}
//
//// MARK: - 4. السحر هنا! البريفيو الخاص لتشغيل الـ TipKit في الكانفاس فوراً غصب عن النظام
//#Preview {
//    OnboardingContainerView()
//        .task {
//            // أمر إجباري من أبل لتشغيل وعرض الـ Tips داخل الـ Preview بدون محاكي
//            try? Tips.resetDatastore()
//            try? Tips.configure([
//                .displayFrequency(.immediate),
//                .datastoreLocation(.applicationDefault)
//            ])
//        }
//}
//#Preview {
//    OnboardingContainerView()
//}
//import SwiftUI
//
//// MARK: - 1. البوابة الرئيسية (تتحكم بظهور الشرح أو الدخول للمحاكي)
//struct OnboardingContainerView: View {
//    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
//    
//    var body: some View {
//        Group {
//            if hasCompletedOnboarding {
//                // يدخل على واجهتك الصدق
//                MarketListView()
//            } else {
//                // يعرض شاشة الشرح المضمونة بالبريفيو
//                CustomOnboardingTutorialView(hasCompletedOnboarding: $hasCompletedOnboarding)
//            }
//        }
//    }
//}
//
//// MARK: - 2. شاشة الشرح التفاعلية (تشتغل بالبريفيو فوراً 🚀)
//struct CustomOnboardingTutorialView: View {
//    @Binding var hasCompletedOnboarding: Bool
//    @State private var currentStep = 1 // 1 = شرح الأخضر، 2 = شرح الأحمر
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            
//            // خلفية المحاكي الفخمة (نفس تصميم واجهتك بالظبط)
//            VStack(spacing: 0) {
//                // الهيدر
//                HStack {
//                    Image(systemName: "line.3.horizontal")
//                        .font(.system(size: 18, weight: .medium))
//                        .foregroundColor(.white)
//                        .frame(width: 44, height: 44)
//                        .background(Color.white.opacity(0.08))
//                        .clipShape(Circle())
//                    
//                    Spacer()
//                    
//                    Text("المحاكي")
//                        .font(.system(size: 28, weight: .bold))
//                        .foregroundColor(.white)
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 16)
//                .padding(.bottom, 12)
//                
//                // القائمة حقت الكروت
//                ScrollView {
//                    VStack(spacing: 14) {
//                        
//                        // 🟢 كرت السهم الأخضر (أرامكو)
//                        VStack(spacing: 8) {
//                            HStack(spacing: 14) {
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text("1234")
//                                        .font(.system(size: 16, weight: .semibold))
//                                        .foregroundColor(.white)
//                                    Text("+ 1.23%")
//                                        .font(.system(size: 13, weight: .medium))
//                                        .foregroundColor(.green)
//                                }
//                                .frame(width: 72, alignment: .leading)
//                                
//                                Image(systemName: "chart.line.uptrend.xyaxis")
//                                    .foregroundColor(.green)
//                                    .font(.title3)
//                                    .frame(width: 80, height: 36)
//                                
//                                Spacer()
//                                
//                                VStack(alignment: .trailing, spacing: 3) {
//                                    Text("أرامكو")
//                                        .font(.system(size: 16, weight: .semibold))
//                                        .foregroundColor(.white)
//                                    Text("1234")
//                                        .font(.system(size: 12))
//                                        .foregroundColor(.gray)
//                                }
//                                
//                                Circle()
//                                    .fill(Color.green.opacity(0.2))
//                                    .frame(width: 46, height: 46)
//                                    .overlay(Text("🌴").font(.system(size: 22)))
//                            }
//                            
//                            // 1️⃣ الفقاعة البيضاء المخصصة للسهم الأخضر (تظهر في الخطوة 1)
//                            if currentStep == 1 {
//                                CustomPopoverView(
//                                    title: "افهم حركة السهم",
//                                    message: "اذا كان السهم احضر ومرتفع\n= السهم يرتفع 📈",
//                                    arrowAtTop: true
//                                )
//                                .transition(.scale.combined(with: .opacity))
//                            }
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 14)
//                        .background(Color.white.opacity(0.03))
//                        .cornerRadius(16)
//                        .opacity(currentStep == 1 ? 1.0 : 0.3) // تعتيم الكرت إذا خلص دوره
//                        
//                        // 🔴 كرت الراجحي (الأحمر)
//                        VStack(spacing: 8) {
//                            HStack(spacing: 14) {
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text("1234")
//                                        .font(.system(size: 16, weight: .semibold))
//                                        .foregroundColor(.white)
//                                    Text("- 1.23%")
//                                        .font(.system(size: 13, weight: .medium))
//                                        .foregroundColor(.red)
//                                }
//                                .frame(width: 72, alignment: .leading)
//                                
//                                Image(systemName: "chart.line.downtrend.xyaxis")
//                                    .foregroundColor(.red)
//                                    .font(.title3)
//                                    .frame(width: 80, height: 36)
//                                
//                                Spacer()
//                                
//                                VStack(alignment: .trailing, spacing: 3) {
//                                    Text("الراجحي")
//                                        .font(.system(size: 16, weight: .semibold))
//                                        .foregroundColor(.white)
//                                    Text("1234")
//                                        .font(.system(size: 12))
//                                        .foregroundColor(.gray)
//                                }
//                                
//                                Circle()
//                                    .fill(Color.blue.opacity(0.2))
//                                    .frame(width: 46, height: 46)
//                                    .overlay(Text("🏦").font(.system(size: 22)))
//                            }
//                            
//                            // 2️⃣ الفقاعة البيضاء المخصصة للسهم الأحمر (تظهر في الخطوة 2)
//                            if currentStep == 2 {
//                                CustomPopoverView(
//                                    title: "افهم حركة السهم",
//                                    message: "ذا كان السهم احمر ومنخفض\n= السهم ينخفض 📉",
//                                    arrowAtTop: true
//                                )
//                                .transition(.scale.combined(with: .opacity))
//                            }
//                        }
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 14)
//                        .background(Color.white.opacity(0.03))
//                        .cornerRadius(16)
//                        .opacity(currentStep == 2 ? 1.0 : 0.3)
//                    }
//                    .padding(.horizontal, 20)
//                    .padding(.top, 20)
//                }
//                
//                Spacer()
//            }
//            .background(Color(red: 14/255, green: 14/255, blue: 16/255).ignoresSafeArea())
//            
//            // MARK: أزرار التحكم بالخطوات (تحت الشاشة)
//            VStack {
//                if currentStep == 1 {
//                    Button {
//                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
//                            currentStep = 2 // ننتقل لشرح السهم الأحمر
//                        }
//                    } label: {
//                        Text("التالي (فهمت الصعود) ➡️")
//                            .font(.system(size: 16, weight: .bold))
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 54)
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .padding(.horizontal, 20)
//                            .padding(.bottom, 24)
//                            .shadow(color: Color.black.opacity(0.2), radius: 8, y: 4)
//                    }
//                } else {
//                    Button {
//                        withAnimation(.spring()) {
//                            hasCompletedOnboarding = true // ندخل على المحاكي الصدق
//                        }
//                    } label: {
//                        Text("فهمت كل شيء، ابدأ المحاكاة الصدق 🚀")
//                            .font(.system(size: 16, weight: .bold))
//                            .foregroundColor(.black)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 54)
//                            .background(Color.white)
//                            .cornerRadius(16)
//                            .padding(.horizontal, 20)
//                            .padding(.bottom, 24)
//                            .shadow(color: Color.black.opacity(0.2), radius: 8, y: 4)
//                    }
//                }
//            }
//        }
//        .environment(\.layoutDirection, .rightToLeft) // دعم كامل للغة العربية
//    }
//}
//
//// MARK: - 3. ويدجت الفقاعة البيضاء الأصلية (Native Popover Style)
//struct CustomPopoverView: View {
//    let title: String
//    let message: String
//    let arrowAtTop: Bool
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            if arrowAtTop {
//                // رسم السهم الصغير المتجه للأعلى ليشير للكرت
//                Image(systemName: "triangle.fill")
//                    .resizable()
//                    .frame(width: 14, height: 7)
//                    .foregroundColor(.white)
//                    .offset(x: -100, y: 2) // محاذاة السهم جهة اليسار عند المؤشرات
//            }
//            
//            // جسم الفقاعة البيضاء الفخم نفس تصاميمك
//            VStack(alignment: .trailing, spacing: 4) {
//                Text(title)
//                    .font(.system(size: 15, weight: .bold))
//                    .foregroundColor(.black)
//                
//                Text(message)
//                    .font(.system(size: 13, weight: .regular))
//                    .foregroundColor(.black.opacity(0.8))
//                    .multilineTextAlignment(.trailing)
//            }
//            .padding(.horizontal, 16)
//            .padding(.vertical, 12)
//            .frame(maxWidth: .infinity, alignment: .trailing)
//            .background(Color.white)
//            .cornerRadius(12)
//            .shadow(color: Color.black.opacity(0.15), radius: 8, y: 4)
//        }
//    }
//}
//
//// MARK: - 4. البريفيو المباشر (شغال ولحظي غصب عن الـ Xcode)
//#Preview {
//    CustomOnboardingTutorialView(hasCompletedOnboarding: .constant(false))
//}
