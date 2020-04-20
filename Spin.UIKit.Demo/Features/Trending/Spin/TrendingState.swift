//
//  TrendingState.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Trending {
    enum State {
        case idle
        case loading(page: Int = 0)
        case loaded(data: [(GifOverview, Bool)], currentPage: Int, previousPage: Int, nextPage: Int, totalPage: Int)
        case failed
        
        struct ViewItem {
            let title: String
            let isFavorite: Bool
        }

        var hasPreviousPage: Bool {
            switch self {
            case .loaded(_, _, let previousPage, let nextPage, _) where previousPage == 0 && nextPage == 1:
                return false
            default:
                return true
            }
        }

        var hasNextPage: Bool {
            switch self {
            case .loaded(_, _, _, let nextPage, let totalPage):
                return nextPage <= totalPage
            default:
                return false
            }
        }
    }
}
