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

        container.register(ReactiveSwiftNavigationFlow.self) { resolver in
            return ReactiveSwiftNavigationFlow(resolver: resolver)
        }

        container.register(CombineNavigationFlow.self) { resolver in
            return CombineNavigationFlow(resolver: resolver)
        }

        container.register(RxSwiftNavigationFlow.self) { resolver in
            return RxSwiftNavigationFlow(resolver: resolver)
        }
    }
}
