//
//  PeopleState.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension PeopleFeature {
    enum State {
        case loading(people: People)
        case enablingFavorite(people: People, favorite: Bool)
        case loaded(people: People, favorite: Bool)
    }
}
