//
//  Images.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-04-19.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct Images: Decodable {
    let fixedHeightData: ImageData

    enum CodingKeys: String, CodingKey {
        case fixedHeightData = "fixed_height"
    }
}

struct ImageData: Decodable {
    let url: String
    let mp4: String
}
