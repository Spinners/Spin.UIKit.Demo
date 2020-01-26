//
//  PeopleEvent.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-24.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

extension PeopleFeature {
    enum Event {
        case load(people: People, favorite: Bool)
        case setFavorite(favorite: Bool)
    }
}
