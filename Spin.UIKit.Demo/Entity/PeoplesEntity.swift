//
//  Peoples.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxSwift

extension Peoples {
    enum Entity {

        static func load(loadApisFunction: (Int?) -> Single<ListResponse<People>>,
                         isFavoriteFunction: @escaping (String) -> Bool,
                         page: Int?) -> Single<([(People, Bool)], Int?, Int?)> {
            return loadApisFunction(page).map { listResponse -> ([(People, Bool)], Int?, Int?) in
                let previousPage = listResponse.previous?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let nextPage = listResponse.next?.split(separator: "=").last.map { String($0) }.flatMap { Int($0) }
                let peoplesAndFavorite = listResponse.results.map { ($0, isFavoriteFunction($0.url)) }
                return (peoplesAndFavorite, previousPage, nextPage)
            }
        }
    }
}
