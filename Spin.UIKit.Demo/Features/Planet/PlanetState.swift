//
//  PlanetState.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension PlanetFeature {
    enum State {
        case loading(planet: Planet)
        case enablingFavorite(planet: Planet, favorite: Bool)
        case loaded(planet: Planet, favorite: Bool)
    }
}
