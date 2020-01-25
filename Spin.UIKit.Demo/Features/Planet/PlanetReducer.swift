//
//  PlanetReducer.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension PlanetFeature {
    static func reducer(state: PlanetFeature.State, event: PlanetFeature.Event) -> PlanetFeature.State {
        switch (state, event) {
        case (.loading, .load(let planet, let favorite)), (.enablingFavorite, .load(let planet, let favorite)):
            return .loaded(planet: planet, favorite: favorite)
        case (.loaded(let planet, _), .setFavorite(let favorite)):
            return .enablingFavorite(planet: planet, favorite: favorite)
        default:
            return state
        }
    }
}
