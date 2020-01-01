//
//  ServiceAssembly.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Swinject

final class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(FavoriteService.self, factory: { _ in
            return FavoriteService()
        })

        container.register(NetworkService.self) { _ in
            return ReactiveNetworkService()
        }

        container.register(String.self, name: "baseURL") { _  in
            return "swapi.co"
        }
    }
}
