//
//  GifDetail.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-04-16.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct GifDetail: Decodable {
    let type: String
    let id: String
    let title: String
    let url: String
    let username: String
    let rating: String
    let images: Images
}
