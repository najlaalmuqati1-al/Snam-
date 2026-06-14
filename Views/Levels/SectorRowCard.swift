////
////  SectorRowCard.swift
////  Snam
////
////  Created by Assistant on 13/06/2026.
////
//
//import SwiftUI
//
//struct SectorRowCard: View {
//    @Binding var sector: PortfolioSector
//    @ObservedObject var vm: PortfolioViewModel
//    let isExpanded: Bool
//
//    var body: some View {
//        VStack(spacing: 0) {
//            header
//                .contentShape(Rectangle())
//                .onTapGesture {
//                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
//                        vm.toggleExpand(sector.id)
//                    }
//                }
//
//            if isExpanded {
//                controls
//                    .transition(.opacity.combined(with: .move(edge: .top)))
//            }
//        }
//        .padding(14)
//        .frame(maxWidth: .infinity)
//        .background(
//            RoundedRectangle(cornerRadius: 16)
//                .fill(Color.black.opacity(0.15))
//                .overlay(
//                    RoundedRectangle(cornerRadius: 16)
//                        .stroke(Color.white.opacity(0.12), lineWidth: 1)
//                )
//        )
//    }
//
//    private var header: some View {
//        HStack(spacing: 12) {
//            Image(systemName: sector.icon)
//                .font(.system(size: 18, weight: .semibold))
//                .foregroundColor(.white)
//
//            VStack(alignment: .leading, spacing: 4) {
//                Text(sector.name)
//                    .font(.system(size: 16, weight: .semibold))
//                    .foregroundColor(.white)
//
//                HStack(spacing: 6) {
//                    Text("تخصيص:")
//                        .font(.system(size: 12))
//                        .foregroundColor(.white.opacity(0.6))
//                    Text(arabicNumber(sector.allocation))
//                        .font(.system(size: 14, weight: .semibold))
//                        .foregroundColor(.white)
//                }
//                .environment(\.layoutDirection, .rightToLeft)
//            }
//
//            Spacer()
//
//            Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
//                .font(.system(size: 14, weight: .semibold))
//                .foregroundColor(.white.opacity(0.7))
//        }
//        .environment(\.layoutDirection, .rightToLeft)
//    }
//
//    private var controls: some View {
//        VStack(spacing: 12) {
//            // Slider-like stepper row
//            HStack(spacing: 12) {
//                Button {
//                    vm.decrement(id: sector.id)
//                } label: {
//                    Image(systemName: "minus")
//                        .font(.system(size: 14, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(width: 36, height: 36)
//                        .background(Circle().fill(Color.white.opacity(0.08)))
//                }
//                .disabled(sector.allocation <= 0)
//                .opacity(sector.allocation > 0 ? 1 : 0.5)
//
//                VStack(alignment: .leading, spacing: 6) {
//                    Text("المبلغ المخصص")
//                        .font(.system(size: 12))
//                        .foregroundColor(.white.opacity(0.6))
//
//                    Text(arabicNumber(sector.allocation))
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundColor(.white)
//                }
//
//                Spacer()
//
//                Button {
//                    vm.increment(id: sector.id)
//                } label: {
//                    Image(systemName: "plus")
//                        .font(.system(size: 14, weight: .bold))
//                        .foregroundColor(.white)
//                        .frame(width: 36, height: 36)
//                        .background(Circle().fill(Color.white.opacity(0.08)))
//                }
//                .disabled(vm.remaining <= 0)
//                .opacity(vm.remaining > 0 ? 1 : 0.5)
//            }
//
//            // Manual entry field
//            HStack(spacing: 12) {
//                Text("تعديل يدوي")
//                    .font(.system(size: 12))
//                    .foregroundColor(.white.opacity(0.6))
//
//                Spacer()
//
//                // Simple numeric field binding to allocation
//                Stepper(value: Binding(
//                    get: { sector.allocation },
//                    set: { newValue in
//                        vm.updateAllocation(id: sector.id, value: newValue)
//                    }
//                ), in: 0...(sector.allocation + vm.remaining)) {
//                    Text(arabicNumber(sector.allocation))
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(.white)
//                }
//                .labelsHidden()
//            }
//            .environment(\.layoutDirection, .rightToLeft)
//
//            // Remaining hint
//            HStack(spacing: 6) {
//                Image(systemName: "info.circle")
//                    .font(.system(size: 12))
//                    .foregroundColor(.white.opacity(0.55))
//                Text("المتبقي: \(arabicNumber(vm.remaining))")
//                    .font(.system(size: 12))
//                    .foregroundColor(.white.opacity(0.55))
//                Spacer()
//            }
//        }
//        .padding(.top, 12)
//    }
//}
//
//#Preview {
//    StatefulPreviewWrapper(
//        PortfolioSector(name: "التقنية", icon: "cpu", allocation: 0)
//    ) { binding in
//        SectorRowCard(sector: binding, vm: PortfolioViewModel(), isExpanded: true)
//            .padding()
//            .background(Color(.systemBackground))
//            .environment(\.layoutDirection, .rightToLeft)
//    }
//}
//
//// Helper to allow Binding previews
//struct StatefulPreviewWrapper<Value, Content: View>: View {
//    @State var value: Value
//    var content: (Binding<Value>) -> Content
//
//    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
//        _value = State(initialValue: value)
//        self.content = content
//    }
//
//    var body: some View {
//        content($value)
//    }
//}
