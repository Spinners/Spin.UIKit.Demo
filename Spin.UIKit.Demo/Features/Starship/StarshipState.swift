//
//  StarshipState.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension StarshipFeature {
    enum State {
        case loading(starship: Starship)
        case enablingFavorite(starship: Starship, favorite: Bool)
        case loaded(starship: Starship, favorite: Bool)
    }
}
