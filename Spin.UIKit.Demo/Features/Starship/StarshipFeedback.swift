//
//  StarshipFeedback.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//
import Combine

enum StarshipFeature {
}

extension StarshipFeature {
    enum FeedbackFunctions {

        /////////////////////////////////////////////
        // Loads a Starship and its favorite property when the state is .loading
        /////////////////////////////////////////////
        static func load(loadFavoriteFunction: (String) -> Bool,
                         state: StarshipFeature.State) -> AnyPublisher<StarshipFeature.Event, Never> {
            guard case let .loading(starship) = state else { return Empty().eraseToAnyPublisher() }

            let isStarshipFavorite = loadFavoriteFunction(starship.url)
            return Just(.load(starship: starship, favorite: isStarshipFavorite)).eraseToAnyPublisher()
        }

        /////////////////////////////////////////////
        // Persist a favorite property when the state is .enablingFavorite
        /////////////////////////////////////////////
        static func persist(persistFavoriteFunction: (Bool, String) -> Void,
                            state: StarshipFeature.State) -> AnyPublisher<StarshipFeature.Event, Never> {
            guard case let .enablingFavorite(starship, favorite) = state else { return Empty().eraseToAnyPublisher() }
            
            persistFavoriteFunction(favorite, starship.url)
            return Just(.load(starship: starship, favorite: favorite)).eraseToAnyPublisher()
        }
    }
}
