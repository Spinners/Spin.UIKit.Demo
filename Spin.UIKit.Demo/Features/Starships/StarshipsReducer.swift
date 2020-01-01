//
//  PlanetsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension StarshipsFeature {
    static func reducer(state: StarshipsFeature.State, action: StarshipsFeature.Action) -> StarshipsFeature.State {

        let result: StarshipsFeature.State

        switch (state, action) {
        case (_, .failLoad):
            result = .failed
        case (_, .load):
            result = .loading(page: nil)
        case (.loaded(_, let previousPage, _), .loadPrevious) where previousPage != nil:
            result = .loading(page: previousPage)
        case (.loaded(_, _, let nextPage), .loadNext) where nextPage != nil:
            result = .loading(page: nextPage)
        case (_, .succeedLoad(let starships, let previousPage, let nextPage)):
            result = .loaded(data: starships, previousPage: previousPage, nextPage: nextPage)
        default:
            result = state
        }

        print("<REDUCER> state: \(state), action: \(action), result state: \(result)")

        return result
    }
}
