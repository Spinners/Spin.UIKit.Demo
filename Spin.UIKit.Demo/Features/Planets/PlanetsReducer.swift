//
//  PlanetsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension PlanetsFeature {
    static func reducer(state: PlanetsFeature.State, action: PlanetsFeature.Action) -> PlanetsFeature.State {
        switch (state, action) {
        case (_, .failLoad):
            return .failed
        case (_, .load):
            return .loading(page: nil)
        case (.loaded(_, let previousPage, _), .loadPrevious) where previousPage != nil:
            return .loading(page: previousPage)
        case (.loaded(_, _, let nextPage), .loadNext) where nextPage != nil:
            return .loading(page: nextPage)
        case (_, .succeedLoad(let planets, let previousPage, let nextPage)):
            return .loaded(data: planets, previousPage: previousPage, nextPage: nextPage)
        default:
            return state
        }
    }
}
