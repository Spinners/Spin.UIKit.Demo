//
//  PlanetReducer.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension PlanetFeature {
    static func reducer(state: PlanetFeature.State, action: PlanetFeature.Action) -> PlanetFeature.State {
        switch (state, action) {
        case (.loading, .load(let planet, let favorite)), (.enablingFavorite, .load(let planet, let favorite)):
            return .loaded(planet: planet, favorite: favorite)
        case (.loaded(let planet, _), .setFavorite(let favorite)):
            return .enablingFavorite(planet: planet, favorite: favorite)
        default:
            return state
        }
    }
}
