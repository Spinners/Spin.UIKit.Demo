//
//  ListResponse.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct ListResponse<Entity: Decodable>: Decodable {
    let count: Int
    let previous: String?
    let next: String?
    let results: [Entity]
}
