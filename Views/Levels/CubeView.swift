//
//  CubeView.swift
//  Snam
//
//  Created by Jojo on 03/06/2026.
//الخلفيه وحجم المكعب

import SwiftUI
import SceneKit

// MARK: - ContentView

struct ContentView: View {
    @StateObject private var vm = CubeViewModel()
    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
                .overlay(
                    Image("Frame")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                ) // ← هنا تقفل الـ overlay

            // زر "انتهيت" في الأسفل
            VStack {
                Spacer()
                if vm.showDoneButton {
                    PrimaryButton(title: "انتهيت", action: vm.didTapDone)
                        .padding(.bottom, 82)
                        .transition(.opacity)
                }
            }
            // المحتوى الرئيسي
            VStack(spacing: 0) {

                // Header
                ZStack {
                    Text("المستثمر الطموح")
                        .foregroundColor(.white)
                        .font(.system(size: 18, weight: .semibold))
                        .frame(maxWidth: .infinity, alignment: .center)
                    HStack {
                        Button(action: {}) {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.white)
                                .font(.system(size: 22, weight: .medium))
                                .frame(width: 17, height: 14)
                        }
                        .frame(width: 44, height: 44)
                        .background(Color.black.opacity(0.2))
                        .clipShape(Circle())
                        Spacer()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)// المسافج بين الستاتس والهيدر

                // المكعب
                
                    .padding(.top, 64)// المسافة بين الستاتس والهيدر

                    Spacer() // ← يدفع المكعب للمنتصف
                    .frame(maxHeight: 150) // نوعا ما بالنص

                    // المكعب
                    CubeView(faces: vm.faces, onFaceChanged: vm.faceChanged)
                        .frame(width: 325, height: 325)

                  //  Spacer() // ← يدفع المكعب للمنتصف
                // Hint
                
                ZStack {
                    
                    if vm.showHint {
                        HStack(spacing: 6) {
                            Image(systemName: "hand.tap") // مب نفسها بس اقرب وحده لقيتها
                            Text("حرك المكعب يمين و يسار")
                                .foregroundColor(.white.opacity(0.5))
                                .font(.system(size: 14))
                        }
                        .transition(.opacity)
                    }
                    
                }
                Spacer()
                .frame(height: 28)
                .padding(.top, 12)

                Spacer()
            }
        }
        .environment(\.layoutDirection, .rightToLeft)
        .animation(.easeInOut(duration: 0.3), value: vm.currentFace)
    }
}

// MARK: - CubeView

struct CubeView: UIViewRepresentable {

    let faces: [CubeFace]
    var onFaceChanged: (Int) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onFaceChanged: onFaceChanged)
    }

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView()
        view.backgroundColor = .clear
        view.allowsCameraControl = false
        view.clipsToBounds = false

        let scene = SCNScene()
        view.scene = scene

        // Camera
        let cameraNode = SCNNode()
        let camera = SCNCamera()
        camera.usesOrthographicProjection = true
        camera.orthographicScale = 1.3
        camera.zNear = 0.1
        camera.zFar = 100
        cameraNode.camera = camera
        cameraNode.position = SCNVector3(0, 0.6, 3)
        cameraNode.look(at: SCNVector3(0, 0, 0))

        scene.rootNode.addChildNode(cameraNode)

        // Light
        let light = SCNLight()
        light.type = .omni
        light.intensity = 1500
        let lightNode = SCNNode()
        lightNode.light = light
        lightNode.position = SCNVector3(5, 5, 5)
        scene.rootNode.addChildNode(lightNode)

        // Ambient
        let ambient = SCNLight()
        ambient.type = .ambient
        ambient.intensity = 600
        let ambientNode = SCNNode()
        ambientNode.light = ambient
        scene.rootNode.addChildNode(ambientNode)

        // Cube
        let cube = SCNBox(width: 2.2, height: 2.2, length: 2.2, chamferRadius: 0.12)
        let sideMaterials = faces.map { faceMaterial(face: $0) }
        let empty = emptyFaceMaterial()
        let topFace = emptyFaceMaterial()
        let bottomFace = faceMaterial(face: CubeFace(title: "عنوان", subtitle: "نص", icon: .empty))
        cube.materials = sideMaterials + [topFace, bottomFace]
        let cubeNode = SCNNode(geometry: cube)
        cubeNode.name = "cube"
        scene.rootNode.addChildNode(cubeNode)

        let pan = UIPanGestureRecognizer(target: context.coordinator,
                                         action: #selector(Coordinator.handlePan(_:)))
        view.addGestureRecognizer(pan)
        context.coordinator.cubeNode = cubeNode

        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {}

    // MARK: - Coordinator

    class Coordinator: NSObject {
        var cubeNode: SCNNode?
        var lastAngleY: Float = 0
        var onFaceChanged: (Int) -> Void

        init(onFaceChanged: @escaping (Int) -> Void) {
            self.onFaceChanged = onFaceChanged
        }

        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            guard let cube = cubeNode else { return }
            let translation = gesture.translation(in: gesture.view)
            if gesture.state == .changed {
                let angle = Float(translation.x) * 0.01
                cube.eulerAngles.y = lastAngleY + angle
                updateFaceLabel(angle: cube.eulerAngles.y)
            }
            if gesture.state == .ended {
                lastAngleY = cube.eulerAngles.y
            }
        }

        func updateFaceLabel(angle: Float) {
            let twoPi = Float.pi * 2
            var normalized = angle.truncatingRemainder(dividingBy: twoPi)
            if normalized < 0 { normalized += twoPi }
            let index = Int((normalized / (Float.pi / 2)).rounded()) % 4
            DispatchQueue.main.async { self.onFaceChanged(index) }
        }
    }

    // MARK: - Materials

    func faceMaterial(face: CubeFace) -> SCNMaterial {
        let material = SCNMaterial()
        let size = CGSize(width: 500, height: 500)
        let image = UIGraphicsImageRenderer(size: size).image { ctx in
            let cgCtx = ctx.cgContext
            let bounds = CGRect(origin: .zero, size: size)
            let radius: CGFloat = 38

            let path = UIBezierPath(roundedRect: bounds, cornerRadius: radius)
            UIColor(red:0.04,green:0.06,blue:0.12,alpha:1).setFill()
            path.fill()
            UIColor(white:0,alpha:0.2).setFill()
            path.fill()

            let shine = UIBezierPath(roundedRect: CGRect(x:1,y:1,width:498,height:498), cornerRadius: radius)
            UIColor(white:1,alpha:0.08).setStroke()
            shine.lineWidth = 2
            shine.stroke()
            path.addClip()

            let gradient = CGGradient(
                colorsSpace: CGColorSpaceCreateDeviceRGB(),
                colors: [UIColor(white:1,alpha:0.07).cgColor,
                         UIColor(white:1,alpha:0.0).cgColor] as CFArray,
                locations: [0, 0.5]
            )!
            cgCtx.drawLinearGradient(gradient,
                                     start: CGPoint(x:250,y:0),
                                     end: CGPoint(x:250,y:250), options: [])

            let titleStyle = NSMutableParagraphStyle()
            titleStyle.alignment = .center
            titleStyle.lineBreakMode = .byWordWrapping
            face.title.draw(in: CGRect(x: 40, y: 60, width: 420, height: 100), withAttributes: [
                .font: UIFont.boldSystemFont(ofSize: 30), // تم تصغير الخط من 42 إلى 34
                .foregroundColor: UIColor.white,
                .paragraphStyle: titleStyle
            ])

            // الجديد بعد تصغير الـ Rect الخاص بكل أيقونة:
            switch face.icon {
            case .pieChart:
//بحكم اختلاف الايكونز صار في اختلاف باحجامها
                drawPieChart(ctx: cgCtx, rect: CGRect(x: 140, y: 175, width: 240, height: 180))
            case .trendingUp:
                // صغرنا الأبعاد من (380, 210) إلى (280, 160)
                drawTrendingUp(ctx: cgCtx, rect: CGRect(x: 110, y: 170, width: 220, height: 150))
            case .trendingDown:
                // صغرنا الأبعاد من (380, 210) إلى (280, 160)
                drawTrendingDown(ctx: cgCtx, rect: CGRect(x: 110, y: 170, width: 220, height: 150))
            case .empty:
                break
            }

            let subStyle = NSMutableParagraphStyle()
            subStyle.alignment = .center
            face.subtitle.draw(in: CGRect(x:20,y:385,width:460,height:80), withAttributes: [
                .font: UIFont.systemFont(ofSize: 34),
                .foregroundColor: UIColor(white:1,alpha:0.55),
                .paragraphStyle: subStyle
            ])
        }
        material.diffuse.contents = image
        material.isDoubleSided = true
        return material
    }

    func emptyFaceMaterial() -> SCNMaterial {
        let material = SCNMaterial()
        let size = CGSize(width: 500, height: 500)
        let image = UIGraphicsImageRenderer(size: size).image { _ in
            let path = UIBezierPath(roundedRect: CGRect(origin:.zero,size:size), cornerRadius: 38)
            UIColor(red:0.04,green:0.06,blue:0.12,alpha:1).setFill()
            path.fill()
            let shine = UIBezierPath(roundedRect: CGRect(x:1,y:1,width:498,height:498), cornerRadius: 38)
            UIColor(white:1,alpha:0.08).setStroke()
            shine.lineWidth = 2
            shine.stroke()
        }
        material.diffuse.contents = image
        material.isDoubleSided = true
        return material
    }

    // MARK: - Drawing

    func drawPieChart(ctx: CGContext, rect: CGRect) {
        let cx = rect.midX, cy = rect.midY
        let r = min(rect.width, rect.height) * 0.46
        ctx.setFillColor(UIColor(red:0.50,green:0.57,blue:0.85,alpha:1).cgColor)
        ctx.fillEllipse(in: CGRect(x:cx-r,y:cy-r,width:r*2,height:r*2))
        ctx.setFillColor(UIColor(red:0.72,green:0.76,blue:0.96,alpha:1).cgColor)
        ctx.move(to: CGPoint(x:cx,y:cy))
        ctx.addArc(center:CGPoint(x:cx,y:cy),radius:r,
                   startAngle:-.pi/2,endAngle:.pi/3,clockwise:false)
        ctx.closePath(); ctx.fillPath()
        ctx.setStrokeColor(UIColor(red:0.04,green:0.06,blue:0.12,alpha:1).cgColor)
        ctx.setLineWidth(7)
        ctx.move(to:CGPoint(x:cx,y:cy)); ctx.addLine(to:CGPoint(x:cx,y:cy-r)); ctx.strokePath()
        ctx.move(to:CGPoint(x:cx,y:cy))
        ctx.addLine(to:CGPoint(x:cx+r*cos(.pi/3),y:cy+r*sin(.pi/3))); ctx.strokePath()
    }

    func drawTrendingUp(ctx: CGContext, rect: CGRect) {
        let c = UIColor(red:0.18,green:0.83,blue:0.38,alpha:1)
        ctx.setStrokeColor(c.cgColor); ctx.setFillColor(c.cgColor)
        ctx.setLineWidth(10); ctx.setLineCap(.round); ctx.setLineJoin(.round)
        let l=rect.minX+8, r=rect.maxX-8, b=rect.maxY, t=rect.minY+8
        ctx.move(to:CGPoint(x:l,y:t)); ctx.addLine(to:CGPoint(x:l,y:b))
        ctx.addLine(to:CGPoint(x:r,y:b)); ctx.strokePath()
        let pts:[CGPoint] = [
            CGPoint(x:l+10,y:b-25), CGPoint(x:l+70,y:b-75),
            CGPoint(x:l+130,y:b-55), CGPoint(x:l+200,y:b-140),
            CGPoint(x:r-28,y:t+15)
        ]
        ctx.move(to:pts[0]); pts.dropFirst().forEach { ctx.addLine(to:$0) }; ctx.strokePath()
        drawArrow(ctx:ctx, tip:CGPoint(x:r-8,y:t+4), angle:-.pi/4, color:c)
    }

    func drawTrendingDown(ctx: CGContext, rect: CGRect) {
        let c = UIColor(red:0.95,green:0.32,blue:0.32,alpha:1)
        ctx.setStrokeColor(c.cgColor); ctx.setFillColor(c.cgColor)
        ctx.setLineWidth(10); ctx.setLineCap(.round); ctx.setLineJoin(.round)
        let l=rect.minX+8, r=rect.maxX-8, b=rect.maxY, t=rect.minY+8
        ctx.move(to:CGPoint(x:l,y:t)); ctx.addLine(to:CGPoint(x:l,y:b))
        ctx.addLine(to:CGPoint(x:r,y:b)); ctx.strokePath()
        let pts:[CGPoint] = [
            CGPoint(x:l+10,y:t+25), CGPoint(x:l+70,y:t+70),
            CGPoint(x:l+130,y:t+52), CGPoint(x:l+200,y:t+135),
            CGPoint(x:r-28,y:b-22)
        ]
        ctx.move(to:pts[0]); pts.dropFirst().forEach { ctx.addLine(to:$0) }; ctx.strokePath()
        drawArrow(ctx:ctx, tip:CGPoint(x:r-8,y:b-8), angle:.pi/4, color:c)
    }

    func drawArrow(ctx: CGContext, tip: CGPoint, angle: CGFloat, color: UIColor) {
        ctx.setFillColor(color.cgColor)
        let len:CGFloat=28, w:CGFloat=18
        let p2=CGPoint(x:tip.x-len*cos(angle)-w*sin(angle),
                       y:tip.y-len*sin(angle)+w*cos(angle))
        let p3=CGPoint(x:tip.x-len*cos(angle)+w*sin(angle),
                       y:tip.y-len*sin(angle)-w*cos(angle))
        ctx.move(to:tip); ctx.addLine(to:p2); ctx.addLine(to:p3)
        ctx.closePath(); ctx.fillPath()
    }
}

#Preview { ContentView() }
