//
//  Pagination.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-04-16.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct Pagination: Decodable {
    let count: Int
    let offset: Int
    let totalCount: Int

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case offset
        case count
    }
}
