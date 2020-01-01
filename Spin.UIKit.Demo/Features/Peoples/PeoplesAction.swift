//
//  FilmsAction.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

extension PeoplesFeature {
    enum Action {
        case load
        case loadPrevious
        case loadNext
        case succeedLoad(peoples: [(People, Bool)], previousPage: Int?, nextPage: Int?)
        case failLoad
    }
}
