//
//  OnboardingStep.swift
//  Snam
//
//  Created by Najla Almuqati on 03/12/1447 AH.
//


//import SwiftUI
//
//// 1. هيكل البيانات للشاشات
//struct SanamStep: Identifiable {
//    let id = UUID()
//    let title: String
//    let description: String
//    let type: StepType
//    
//    enum StepType {
//        case cards
//        case coins
//    }
//}
//
//struct SanamOnboardingView: View {
//    @State private var currentStep = 0
//    
//    let steps = [
//        SanamStep(title: "أهلاً بك في سنام", description: "تطبيق يساعدك على تعلّم الاستثمار في الأسهم...", type: .cards),
//        SanamStep(title: "بطريقة تفاعلية", description: "أكمل مستوياتك لتحصل على أكبر قدر ممكن من المكافآت...", type: .coins)
//    ]
//    
//    var body: some View {
//        ZStack {
//            // الخلفية الثابتة مع الهالات النيلية خلف العناصر بالظبط
//            ZStack {
//                Color(red: 4/255, green: 7/255, blue: 15/255).ignoresSafeArea()
//                Circle()
//                    .fill(Color(red: 15/255, green: 37/255, blue: 90/255))
//                    .frame(width: 400, height: 400)
//                    .blur(radius: 100)
//                    .opacity(0.5)
//            }
//            
//            VStack {
//                // زر تخطي متموضع في جهة اليسار فوق بالملي
//                HStack {
//                    Spacer()
//                    if currentStep == 0 {
//                        Button("تخطي") {
//                            withAnimation { currentStep = 1 }
//                        }
//                        .foregroundColor(.white.opacity(0.6))
//                        .padding(.horizontal, 24)
//                    }
//                }
//                .padding(.top, 10)
//                
//                // محتوى الصفحات الثابتة
//                TabView(selection: $currentStep) {
//                    ForEach(0..<steps.count, id: \.self) { index in
//                        SanamContentView(step: steps[index])
//                            .tag(index)
//                    }
//                }
//                .tabViewStyle(.page(indexDisplayMode: .never))
//                
//                // نقاط التنقل (Indicators)
//                HStack(spacing: 8) {
//                    ForEach(0..<steps.count, id: \.self) { index in
//                        Circle()
//                            .fill(currentStep == index ? Color.blue : Color.white.opacity(0.3))
//                            .frame(width: 8, height: 8)
//                    }
//                }
//                .padding(.bottom, 20)
//                
//                // زر "ابدأ الآن" في الشاشة الأخيرة
//                if currentStep == 1 {
//                    Button(action: {}) {
//                        Text("ابدأ الآن")
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Capsule().stroke(Color.blue.opacity(0.5), lineWidth: 1))
//                            .padding(.horizontal, 40)
//                    }
//                }
//                Spacer().frame(height: 30)
//            }
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// عرض محتوى كل شاشة بتثبيت دقيق مطابق للتصميم
//struct SanamContentView: View {
//    let step: SanamStep
//    
//    var body: some View {
//        VStack(alignment: .trailing) { // يضمن محاذاة محتوى الحاوية لليمين
//            Spacer()
//            
//            // منطقة العرض الرسومي (البطاقات أو الهللات)
//            ZStack {
//                if step.type == .cards {
//                    // الشاشة 1: البطاقتين فوق بعض بنفس أبعاد وميلان الفيجما بالظبط
//                    ZStack {
//                        Image("right") // البطاقة الخلفية (المائلة للأعلى يمين)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 230)
//                            .rotationEffect(.degrees(-22))
//                            .offset(x: 25, y: -30)
//                        
//                        Image("left") // البطاقة الأمامية (المائلة للأسفل يسار)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 230)
//                            .rotationEffect(.degrees(-12))
//                            .offset(x: -15, y: 35)
//                    }
//                } else {
//                    // الشاشة 2: الـ 5 هللات مفرقة ومائلة باتجاهات مختلفة كأنها تطيح
//                    ZStack {
//                        // هللة 1 (اللي فوق)
//                        Image("1")
//                            .resizable().scaledToFit().frame(width: 75, height: 75)
//                            .rotationEffect(.degrees(-5))
//                            .offset(x: -5, y: -100)
//                        
//                        // هللة 2
//                        Image("2")
//                            .resizable().scaledToFit().frame(width: 70, height: 70)
//                            .rotationEffect(.degrees(15))
//                            .offset(x: -55, y: -30)
//                        
//                        // هللة 3
//                        Image("3")
//                            .resizable().scaledToFit().frame(width: 72, height: 72)
//                            .rotationEffect(.degrees(-20))
//                            .offset(x: 45, y: 20)
//                        
//                        // هللة 4
//                        Image("4")
//                            .resizable().scaledToFit().frame(width: 68, height: 68)
//                            .rotationEffect(.degrees(10))
//                            .offset(x: -35, y: 85)
//                        
//                        // هللة 5 (اللي تحت مائلة بقوة)
//                        Image("5")
//                            .resizable().scaledToFit().frame(width: 38, height: 65)
//                            .rotationEffect(.degrees(-35))
//                            .offset(x: 40, y: 145)
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .frame(height: 350)
//            
//            Spacer()
//            
//            // منطقة النصوص: تبدأ من اليمين بالملي
//            VStack(alignment: .leading, spacing: 15) {
//                Text(step.title)
//                    .font(.system(size: 28, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                Text(step.description)
//                    .font(.system(size: 16))
//                    .foregroundColor(.white.opacity(0.7))
//                    .multilineTextAlignment(.leading) // .leading مع الـ rightToLeft يعطيك بداية محاذاة من اليمين مية بالمية
//                    .lineSpacing(4)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding(.horizontal, 40)
//            .padding(.bottom, 70)
//        }
//    }
//}
//
//#Preview {
//    SanamOnboardingView()
//}

//import SwiftUI
//
//// 1. هيكل البيانات للشاشات
//struct SanamStep: Identifiable {
//    let id = UUID()
//    let title: String
//    let description: String
//    let type: StepType
//    
//    enum StepType {
//        case cards
//        case coins
//    }
//}
//
//struct SanamOnboardingView: View {
//    @State private var currentStep = 0
//    
//    let steps = [
//        SanamStep(title: "أهلاً بك في سنام", description: "تطبيق يساعدك على تعلّم الاستثمار في الأسهم...", type: .cards),
//        SanamStep(title: "بطريقة تفاعلية", description: "أكمل مستوياتك لتحصل على أكبر قدر ممكن من المكافآت...", type: .coins)
//    ]
//    
//    var body: some View {
//        ZStack {
//            // الخلفية الثابتة مع الهالات النيلية خلف العناصر بالظبط
//            ZStack {
//                Color(red: 4/255, green: 7/255, blue: 15/255).ignoresSafeArea()
//                Circle()
//                    .fill(Color(red: 15/255, green: 37/255, blue: 90/255))
//                    .frame(width: 400, height: 400)
//                    .blur(radius: 100)
//                    .opacity(0.5)
//            }
//            
//            VStack {
//                // زر تخطي متموضع في جهة اليسار فوق بالملي
//                HStack {
//                    Spacer()
//                    if currentStep == 0 {
//                        Button("تخطي") {
//                            withAnimation { currentStep = 1 }
//                        }
//                        .foregroundColor(.white.opacity(0.6))
//                        .padding(.horizontal, 24)
//                    }
//                }
//                .padding(.top, 10)
//                
//                // محتوى الصفحات الثابتة (تم تمرير التغيير هنا لمعرفة الصفحة النشطة)
//                TabView(selection: $currentStep) {
//                    ForEach(0..<steps.count, id: \.self) { index in
//                        SanamContentView(step: steps[index], isCurrent: currentStep == index)
//                            .tag(index)
//                    }
//                }
//                .tabViewStyle(.page(indexDisplayMode: .never))
//                
//                // نقاط التنقل (Indicators)
//                HStack(spacing: 8) {
//                    ForEach(0..<steps.count, id: \.self) { index in
//                        Circle()
//                            .fill(currentStep == index ? Color.blue : Color.white.opacity(0.3))
//                            .frame(width: 8, height: 8)
//                    }
//                }
//                .padding(.bottom, 20)
//                
//                // زر "ابدأ الآن" في الشاشة الأخيرة
//                if currentStep == 1 {
//                    Button(action: {}) {
//                        Text("ابدأ الآن")
//                            .fontWeight(.bold)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Capsule().stroke(Color.blue.opacity(0.5), lineWidth: 1))
//                            .padding(.horizontal, 40)
//                    }
//                }
//                Spacer().frame(height: 30)
//            }
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// عرض محتوى كل شاشة بتثبيت دقيق مطابق للتصميم
//struct SanamContentView: View {
//    let step: SanamStep
//    let isCurrent: Bool // لمعرفة إذا كانت الشاشة معروضة حالياً أم لا
//    
//    @State private var startAnimation = false
//    
//    var body: some View {
//        VStack(alignment: .trailing) { // يضمن محاذاة محتوى الحاوية لليمين
//            Spacer()
//            
//            // منطقة العرض الرسومي (البطاقات أو الهللات)
//            ZStack {
//                if step.type == .cards {
//                    // الشاشة 1: البطاقتين تلتقيان (واحدة يمين وواحدة يسار) وتستقران في وزنيتك الأصلية بالظبط
//                    ZStack {
//                        Image("right") // البطاقة الخلفية (المائلة للأعلى يمين)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 230)
//                            .rotationEffect(.degrees(-22))
//                            .offset(x: startAnimation ? 25 : 500, y: -30) // تدخل من اليمين
//                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: startAnimation)
//                        
//                        Image("left") // البطاقة الأمامية (المائلة للأسفل يسار)
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 230)
//                            .rotationEffect(.degrees(-12))
//                            .offset(x: startAnimation ? -15 : -500, y: 35) // تدخل من اليسار
//                            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: startAnimation)
//                    }
//                } else {
//                    // الشاشة 2: الـ 5 هللات مفرقة وتنزلق من الأعلى تدريجياً ورا بعض
//                    ZStack {
//                        // هللة 1 (اللي فوق)
//                        Image("1")
//                            .resizable().scaledToFit().frame(width: 75, height: 75)
//                            .rotationEffect(.degrees(-5))
//                            .offset(x: -5, y: startAnimation ? -100 : -600)
//                            .animation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.0), value: startAnimation)
//                        
//                        // هللة 2
//                        Image("2")
//                            .resizable().scaledToFit().frame(width: 70, height: 70)
//                            .rotationEffect(.degrees(15))
//                            .offset(x: -55, y: startAnimation ? -30 : -600)
//                            .animation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.12), value: startAnimation)
//                        
//                        // هللة 3
//                        Image("3")
//                            .resizable().scaledToFit().frame(width: 72, height: 72)
//                            .rotationEffect(.degrees(-20))
//                            .offset(x: 45, y: startAnimation ? 20 : -600)
//                            .animation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.24), value: startAnimation)
//                        
//                        // هللة 4
//                        Image("4")
//                            .resizable().scaledToFit().frame(width: 68, height: 68)
//                            .rotationEffect(.degrees(10))
//                            .offset(x: -35, y: startAnimation ? 85 : -600)
//                            .animation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.36), value: startAnimation)
//                        
//                        // هللة 5 (اللي تحت مائلة بقوة)
//                        Image("5")
//                            .resizable().scaledToFit().frame(width: 38, height: 65)
//                            .rotationEffect(.degrees(-35))
//                            .offset(x: 40, y: startAnimation ? 145 : -600)
//                            .animation(.spring(response: 0.7, dampingFraction: 0.75).delay(0.48), value: startAnimation)
//                    }
//                }
//            }
//            .frame(maxWidth: .infinity)
//            .frame(height: 350)
//            
//            Spacer()
//            
//            // منطقة النصوص: تبدأ من اليمين بالملي
//            VStack(alignment: .leading, spacing: 15) {
//                Text(step.title)
//                    .font(.system(size: 28, weight: .bold))
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                
//                Text(step.description)
//                    .font(.system(size: 16))
//                    .foregroundColor(.white.opacity(0.7))
//                    .multilineTextAlignment(.leading)
//                    .lineSpacing(4)
//                    .frame(maxWidth: .infinity, alignment: .leading)
//            }
//            .padding(.horizontal, 40)
//            .padding(.bottom, 70)
//        }
//        // الاستماع لحالة السوايب لتشغيل أو إعادة تصفير الأنيميشن
//        .onChange(of: isCurrent) { active in
//            if active {
//                startAnimation = true
//            } else {
//                startAnimation = false // تصفير لتكرار الحركات التفاعلية عند العودة للشاشة
//            }
//        }
//        .onAppear {
//            if isCurrent { startAnimation = true }
//        }
//    }
//}
//
//#Preview {
//    SanamOnboardingView()
//}

import SwiftUI

// 1. هيكل البيانات للشاشات
struct SanamStep: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let type: StepType
    
    enum StepType {
        case cards
        case coins
    }
}

struct SanamOnboardingView: View {
    @State private var currentStep = 0
    @State private var showMainTab = false // <--- للتبديل للصفحة الرئيسية

    let steps = [
        SanamStep(title: "هلا بك في سنام", description: "بنساعدك تدخل عالم الأسهم وتستثمر فلوسك صح...", type: .cards),
        SanamStep(title: " استمتع بالتعلم ", description: "بنعلمك بطريقة تشدك، وتخليك تستمتع بكل معلومة جديدة...", type: .coins)
    ]
    
    var body: some View {
        Group {
            if showMainTab {
                MainTabView() // الصفحة الرئيسية بدون back
            } else {
                ZStack {
                    // الخلفية
                    Color(red: 4/255, green: 7/255, blue: 15/255).ignoresSafeArea()
                    Circle()
                        .fill(Color(red: 15/255, green: 37/255, blue: 90/255))
                        .frame(width: 400, height: 400)
                        .blur(radius: 100)
                        .opacity(0.5)
                    
                    VStack {
                        // زر تخطي
                        HStack {
                            Spacer()
                            if currentStep == 0 {
                                Button("تخطي") {
                                    withAnimation {
                                        showMainTab = true
                                    }
                                }
                                .foregroundColor(.white.opacity(0.6))
                                .padding(.horizontal, 24)
                            }
                        }
                        .padding(.top, 10)
                        
                        // محتوى الصفحات
                        TabView(selection: $currentStep) {
                            ForEach(0..<steps.count, id: \.self) { index in
                                SanamContentView(step: steps[index], isCurrent: currentStep == index)
                                    .tag(index)
                            }
                        }
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        
                        // Indicators
                        HStack(spacing: 8) {
                            ForEach(0..<steps.count, id: \.self) { index in
                                Circle()
                                    .fill(currentStep == index ? Color.blue : Color.white.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                        .padding(.bottom, 20)
                        
                        // زر "ابدأ الآن" للشاشة الأخيرة
                        if currentStep == 1 {
                            PrimaryButton(title: "ابدأ الآن") {
                                withAnimation {
                                    showMainTab = true
                                }
                            }
                        }
                        Spacer().frame(height: 30)
                    }
                }
                .environment(\.layoutDirection, .rightToLeft)
            }
        }
    }
}

// المحتوى لكل شاشة
struct SanamContentView: View {
    let step: SanamStep
    let isCurrent: Bool
    
    @State private var startAnimation = false
    
    var body: some View {
        VStack(alignment: .trailing) {
            Spacer()
            
            // منطقة العرض الرسومي
            ZStack {
                if step.type == .cards {
                    ZStack {
                        Image("right")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 230)
                            .rotationEffect(.degrees(-22))
                            .offset(x: startAnimation ? 25 : 500, y: -30)
                            .animation(.spring(response: 1.2, dampingFraction: 0.85), value: startAnimation)
                        
                        Image("left")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 230)
                            .rotationEffect(.degrees(-12))
                            .offset(x: startAnimation ? -15 : -500, y: 35)
                            .animation(.spring(response: 1.2, dampingFraction: 0.85), value: startAnimation)
                    }
                } else {
                    ZStack {
                        Image("1").resizable().scaledToFit().frame(width: 75, height: 75)
                            .rotationEffect(.degrees(-5))
                            .offset(x: -5, y: startAnimation ? -100 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(0.0), value: startAnimation)
                        
                        Image("2").resizable().scaledToFit().frame(width: 70, height: 70)
                            .rotationEffect(.degrees(15))
                            .offset(x: -55, y: startAnimation ? -30 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(0.25), value: startAnimation)
                        
                        Image("3").resizable().scaledToFit().frame(width: 72, height: 72)
                            .rotationEffect(.degrees(-20))
                            .offset(x: 45, y: startAnimation ? 20 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(0.5), value: startAnimation)
                        
                        Image("4").resizable().scaledToFit().frame(width: 68, height: 68)
                            .rotationEffect(.degrees(10))
                            .offset(x: -35, y: startAnimation ? 85 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(0.75), value: startAnimation)
                        
                        Image("5").resizable().scaledToFit().frame(width: 38, height: 65)
                            .rotationEffect(.degrees(-35))
                            .offset(x: 40, y: startAnimation ? 145 : -600)
                            .animation(.spring(response: 1.4, dampingFraction: 0.75).delay(1.0), value: startAnimation)
                    }
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 350)
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 15) {
                Text(step.title)
                    .font(.system(size: 35, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(step.description)
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.leading)
                    .lineSpacing(4)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 70)
        }
        .onChange(of: isCurrent) { active in
            startAnimation = active
        }
        .onAppear {
            if isCurrent { startAnimation = true }
        }
    }
}

#Preview {
    SanamOnboardingView()
}
