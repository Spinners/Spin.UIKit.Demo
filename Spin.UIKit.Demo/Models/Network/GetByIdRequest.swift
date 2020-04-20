//
//  GetByIdRequest.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-04-16.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct GetByIdRequest: Encodable {
    let apiKey: String

    enum CodingKeys: String, CodingKey {
        case apiKey = "api_key"
    }
}
