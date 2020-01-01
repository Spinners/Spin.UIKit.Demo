//
//  FlowAssembly.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-12-19.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Swinject

final class FlowAssembly: Assembly {
    func assemble(container: Container) {
        container.register(AppFlow.self) { resolver in
            return AppFlow(resolver: resolver)
        }

        container.register(PlanetsFlow.self) { resolver in
            return PlanetsFlow(resolver: resolver)
        }

        container.register(PeoplesFlow.self) { resolver in
            return PeoplesFlow(resolver: resolver)
        }

        container.register(StarshipsFlow.self) { resolver in
            return StarshipsFlow(resolver: resolver)
        }
    }
}
