//
//  PlanetsEvent.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension PlanetsFeature {
    enum Event {
        case load
        case loadPrevious
        case loadNext
        case succeedLoad(planets: [(Planet, Bool)], currentPage: Int?, previousPage: Int?, nextPage: Int?)
        case failLoad
    }
}
