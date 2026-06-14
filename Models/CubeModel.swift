//
//  CubeModel.swift
//  Snam
//
//  Created by Jojo on 03/06/2026.

import Foundation

enum CubeIcon {
    case pieChart
    case trendingUp
    case trendingDown
    case cubeIcon
    case empty
}

struct CubeFace {
    let title: String
    let subtitle: String
    let icon: CubeIcon
}

struct CubeModel {
    let faces: [CubeFace] = [
        CubeFace(title: "وش يعنى انك تشتري",
                 subtitle: "انك صرت شريك من الشركة",
                 icon: .pieChart),
        CubeFace(title: "",          
                       subtitle: "",
                       icon: .cubeIcon),
        CubeFace(title: "شريك معها",
                 subtitle: "في الخسارة",
                 icon: .trendingDown),
        CubeFace(title: "شريك معها",
                 subtitle: "في الربح",
                 icon: .trendingUp),
    ]
}
