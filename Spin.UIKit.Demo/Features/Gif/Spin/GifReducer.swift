//
//  GifReducer.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension Gif {
    static func reducer(state: Gif.State, event: Gif.Event) -> Gif.State {
        switch (state, event) {
        case (.loading, .load(let gif, let favorite)), (.enablingFavorite, .load(let gif, let favorite)):
            return .loaded(gif: gif, favorite: favorite)
        case (.loaded(let gif, _), .setFavorite(let favorite)):
            return .enablingFavorite(gif: gif, favorite: favorite)
        case (_, .failLoad):
            return .failed
        default:
            return state
        }
    }
}
