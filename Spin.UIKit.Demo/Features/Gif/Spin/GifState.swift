//
//  GifState.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension Gif {
    enum State {
        case loading(id: String)
        case enablingFavorite(gif: GifDetail, favorite: Bool)
        case loaded(gif: GifDetail, favorite: Bool)
        case failed
    }
}
