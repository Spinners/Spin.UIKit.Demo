//
//  PeopleFeedback.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//
import RxSwift

enum PeopleFeature {
}

extension PeopleFeature {
    enum FeedbackFunctions {
        
        /////////////////////////////////////////////
        // Loads a people and its favorite property when the state is .loading
        /////////////////////////////////////////////
        static func load(loadFavoriteFunction: (String) -> Bool,
                         state: PeopleFeature.State) -> Observable<PeopleFeature.Event> {
            guard case let .loading(people) = state else { return .empty() }
            
            let isPeopleFavorite = loadFavoriteFunction(people.url)
            return .just(.load(people: people, favorite: isPeopleFavorite))
        }
        
        /////////////////////////////////////////////
        // Persist a favorite property when the state is .enablingFavorite
        /////////////////////////////////////////////
        static func persist(persistFavoriteFunction: (Bool, String) -> Void,
                            state: PeopleFeature.State) -> Observable<PeopleFeature.Event> {
            guard case let .enablingFavorite(people, favorite) = state else { return .empty() }
            
            persistFavoriteFunction(favorite, people.url)
            return .just(.load(people: people, favorite: favorite))
        }
    }
}
