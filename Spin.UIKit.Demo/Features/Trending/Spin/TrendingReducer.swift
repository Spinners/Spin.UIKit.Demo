//
//  TrendingReducer.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Trending {
    static func reducer(state: Trending.State, event: Trending.Event) -> Trending.State {
        switch (state, event) {
        case (_, .failLoad):
            return .failed
        case (.idle, .load):
            return .loading(page: 0)
        case (.loaded(_, let currentPage, _, _, _), .load):
            return .loading(page: currentPage)
        case (.loaded(_, _, let previousPage, _, _), .loadPrevious) where state.hasPreviousPage:
            return .loading(page: previousPage)
        case (.loaded(_, _, _, let nextPage, _), .loadNext) where state.hasNextPage:
            return .loading(page: nextPage)
        case (_, .succeedLoad(let gif, let currentPage, let previousPage, let nextPage, let totalPage)):
            return .loaded(data: gif, currentPage: currentPage, previousPage: previousPage, nextPage: nextPage, totalPage: totalPage)
        default:
            return state
        }
    }
}
