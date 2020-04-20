//
//  GetByIdResponse.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-04-16.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct GetByIdResponse: Decodable {
    let data: GifDetail
    let meta: Meta
}
