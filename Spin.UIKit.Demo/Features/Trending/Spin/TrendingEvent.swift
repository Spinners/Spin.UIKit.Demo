//
//  TrendingEvent.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension Trending {
    enum Event {
        case load
        case loadPrevious
        case loadNext
        case succeedLoad(gif: [(GifOverview, Bool)], currentPage: Int, previousPage: Int, nextPage: Int, totalPage: Int)
        case failLoad
    }
}
