//
//  FilmsState.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension PlanetsFeature {
    enum State {
        case idle
        case loading(page: Int? = nil)
        case loaded(data: [(Planet, Bool)], currentPage: Int?, previousPage: Int?, nextPage: Int?)
        case failed
        
        struct ViewItem {
            let title: String
            let isFavorite: Bool
        }
    }
}
