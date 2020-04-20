//
//  Meta.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-04-16.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct Meta: Decodable {
    let msg: String
    let status: Int
    let responseId: String

    enum CodingKeys: String, CodingKey {
        case responseId = "response_id"
        case status
        case msg
    }
}
