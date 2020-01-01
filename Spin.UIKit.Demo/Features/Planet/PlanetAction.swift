//
//  PlanetAction.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension PlanetFeature {
    enum Action {
        case load(planet: Planet, favorite: Bool)
        case setFavorite(favorite: Bool)
    }
}
