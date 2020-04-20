//
//  TrendingRequest.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct TrendingRequest: Encodable {
    let apiKey: String
    let limit: Int
    let offset: Int

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
        case limit
        case offset
    }
}
