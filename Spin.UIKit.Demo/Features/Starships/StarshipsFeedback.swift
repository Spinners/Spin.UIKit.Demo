//
//  StarshipsFeedback.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-17.
//  Copyright © 2019 WarpFactor. All rights reserved.
//
import Combine

enum StarshipsFeature {
}

extension StarshipsFeature {
    enum FeedbackFunctions {

        static func loadPage(loadEntityFunction: (Int?) -> AnyPublisher<([(Starship, Bool)], Int?, Int?), NetworkError>,
                             state: StarshipsFeature.State) -> AnyPublisher<StarshipsFeature.Event, Never> {
            guard case let .loading(page) = state else { return Empty().eraseToAnyPublisher() }

            return loadEntityFunction(page)
                .map { StarshipsFeature.Event.succeedLoad(starships: $0.0,
                                                          currentPage: page,
                                                          previousPage: $0.1,
                                                          nextPage: $0.2) }
                .replaceError(with: StarshipsFeature.Event.failLoad)
                .eraseToAnyPublisher()
        }
    }
}
