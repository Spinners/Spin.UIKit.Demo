//
//  PeopleReducer.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension PeopleFeature {
    static func reducer(state: PeopleFeature.State, action: PeopleFeature.Action) -> PeopleFeature.State {
        switch (state, action) {
        case (.loading, .load(let people, let favorite)), (.enablingFavorite, .load(let people, let favorite)):
            return .loaded(people: people, favorite: favorite)
        case (.loaded(let people, _), .setFavorite(let favorite)):
            return .enablingFavorite(people: people, favorite: favorite)
        default:
            return state
        }
    }
}
