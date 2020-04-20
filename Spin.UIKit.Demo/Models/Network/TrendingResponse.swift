//
//  TrendingResponse.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct TrendingResponse: Decodable {
    let data: [GifOverview]
    let pagination: Pagination
    let meta: Meta
}
