//
//  FilmsReducer.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension PeoplesFeature {
    static func reducer(state: PeoplesFeature.State, action: PeoplesFeature.Action) -> PeoplesFeature.State {
        print("------- reducer peoples, state: \(state), action: \(action)")

        switch (state, action) {
        case (_, .failLoad):
            return .failed
        case (_, .load):
            return .loading(page: nil)
        case (.loaded(_, let previousPage, _), .loadPrevious) where previousPage != nil:
            return .loading(page: previousPage)
        case (.loaded(_, _, let nextPage), .loadNext) where nextPage != nil:
            return .loading(page: nextPage)
        case (_, .succeedLoad(let peoples, let previousPage, let nextPage)):
            return .loaded(data: peoples, previousPage: previousPage, nextPage: nextPage)
        default:
            return state
        }
    }
}
