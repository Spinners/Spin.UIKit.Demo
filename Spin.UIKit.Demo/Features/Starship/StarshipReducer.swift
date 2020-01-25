//
//  StarshipReducer.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension StarshipFeature {
    static func reducer(state: StarshipFeature.State, event: StarshipFeature.Event) -> StarshipFeature.State {
        switch (state, event) {
        case (.loading, .load(let starship, let favorite)), (.enablingFavorite, .load(let starship, let favorite)):
            return .loaded(starship: starship, favorite: favorite)
        case (.loaded(let starship, _), .setFavorite(let favorite)):
            return .enablingFavorite(starship: starship, favorite: favorite)
        default:
            return state
        }
    }
}
