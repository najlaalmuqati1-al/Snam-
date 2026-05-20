import SwiftUI

// نموذج البيانات للشاشات
struct OnboardingStep {
    let id = UUID()
    let title: String
    let description: String
    let type: StepType
    
    enum StepType {
        case welcome       // الشاشة الأولى (البطاقات)
        case interactive   // الشاشة الثانية (العملات)
    }
}

struct OnboardingMainView: View {
    @State private var currentStep = 0
    
    let steps = [
        OnboardingStep(title: "أهلاً بك في سنام", description: "تطبيق يساعدك على تعلّم الاستثمار في الأسهم...", type: .welcome),
        OnboardingStep(title: "بطريقة تفاعلية", description: "أكمل مستوياتك لتحصل على أكبر قدر ممكن من المكافآت...", type: .interactive)
    ]
    
    var body: some View {
        ZStack {
            // 1️⃣ هنا مكان الـ الباكجراوند الثابتة (تفرش على كامل الشاشة خلف كل شيء)
            Image("main_background_with_glows") // اسم صورة الخلفية مع الهالات حقتك
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            // العناصر الواجهة فوق الخلفية
            VStack {
                // زر تخطي
                HStack {
                    if currentStep == 0 {
                        Button("تخطي") {
                            withAnimation { currentStep = 1 }
                        }
                        .foregroundColor(.white.opacity(0.6))
                        .font(.body)
                        .padding(.horizontal, 24)
                    }
                    Spacer()
                }
                .frame(height: 40)
                
                // الصفحات المتنقلة
                TabView(selection: $currentStep) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        StepContentView(step: steps[index], isCurrent: currentStep == index)
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // مؤشر الصفحات (النقاط)
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { index in
                        Circle()
                            .fill(currentStep == index ? Color.blue : Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 32)
                
                // زر "ابدأ الآن"
                if currentStep == steps.count - 1 {
                    Button(action: {
                        // ابدأ التطبيق
                    }) {
                        Text("ابدأ الآن")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .stroke(Color.blue.opacity(0.5), lineWidth: 1)
                                    .background(Color(red: 0.01, green: 0.02, blue: 0.1).opacity(0.8))
                            )
                    }
                    .padding(.horizontal, 32)
                    .padding(.bottom, 24)
                } else {
                    Spacer().frame(height: 75) // يحافظ على وزنية الشاشة
                }
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
    }
}

// عرض محتوى الصفحة والأنيميشن الخاص بالصور
struct StepContentView: View {
    let step: OnboardingStep
    let isCurrent: Bool
    
    @State private var animateElements = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // 2️⃣ هنا مكان الصور المتحركة (البطاقات والعملات)
            ZStack {
                if step.type == .welcome {
                    // صورة البطاقات: تدخل من اليمين
                    Image("welcome_cards") // اسم صورة البطاقات حقت الشاشة الأولى
                        .resizable()
                        .scaledToFit()
                        .frame(height: 260) // تحكم بالحجم اللي يناسبك
                        .offset(x: animateElements ? 0 : 350)
                        .opacity(animateElements ? 1 : 0)
                } else {
                    // صورة العملات: تدخل من اليسار
                    Image("interactive_coins") // اسم صورة العملات المتناثرة للشاشة الثانية
                        .resizable()
                        .scaledToFit()
                        .frame(height: 260) // تحكم بالحجم اللي يناسبك
                        .offset(x: animateElements ? 0 : -350)
                        .opacity(animateElements ? 1 : 0)
                }
            }
            .frame(height: 300) // الحاوية حقت الصور لضمان عدم تحرك النصوص
            
            Spacer()
            
            // النصوص
            VStack(spacing: 12) {
                Text(step.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Text(step.description)
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .lineSpacing(4)
            }
            .padding(.bottom, 20)
        }
        // تشغيل الأنيميشن عند التنقل
        .onChange(of: isCurrent) { newValue in
            if newValue {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.75, blendDuration: 0)) {
                    animateElements = true
                }
            } else {
                animateElements = false
            }
        }
        .onAppear {
            if isCurrent {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.75, blendDuration: 0)) {
                    animateElements = true
                }
            }
        }
    }
}

#Preview {
    OnboardingMainView()
}