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
        container.register(FavoriteService.self) { _ in
            return FavoriteService()
        }.inObjectScope(.transient)

        container.register(NetworkService.self) { _ in
            return ReactiveNetworkService()
        }

        container.register(String.self, name: "baseURL") { _  in
            return "api.giphy.com"
        }

        container.register(String.self, name: "apiKey") { _  in
            return "f4HXQOslkXuDXgFlZQATpWXc8FtjhuUR"
        }
    }
}
