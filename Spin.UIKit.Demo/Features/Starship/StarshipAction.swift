//
//  StarshipAction.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension StarshipFeature {
    enum Action {
        case load(starship: Starship, favorite: Bool)
        case setFavorite(favorite: Bool)
    }
}
