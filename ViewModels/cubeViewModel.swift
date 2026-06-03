//
//  cubeViewModel.swift
//  Snam
//
//  Created by Jojo on 03/06/2026.
//
import SwiftUI
import Combine  // ← هذا كان ناقص

final class CubeViewModel: ObservableObject {

    @Published private(set) var currentFace: Int = 0

    let model = CubeModel()

    var showHint: Bool       { currentFace == 0 }
    var showDoneButton: Bool { currentFace == 3 }
    var faces: [CubeFace]    { model.faces }

    func faceChanged(to index: Int) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentFace = index
        }
    }

    func didTapDone() {
        // navigation logic هنا
    }
}
