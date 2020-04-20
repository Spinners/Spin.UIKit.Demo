//
//  GifEvent.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension Gif {
    enum Event {
        case load(gif: GifDetail, favorite: Bool)
        case setFavorite(favorite: Bool)
        case failLoad
    }
}
