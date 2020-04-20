//
//  ReactiveSwiftNavigationFlow.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import Swinject
import UIKit

final class ReactiveSwiftNavigationFlow: Flow {

    private let resolver: Resolver

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.navigationBar.prefersLargeTitles = true
        return viewController
    }()

    var root: Presentable {
        return self.rootViewController
    }

    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? GifStep else { return .none }
        
        switch step {
        case .trending:
            return self.navigateToTrending()
        case .gif(let gif):
            return self.navigateTo(gif: gif)
        }
    }
}

extension ReactiveSwiftNavigationFlow {
    func navigateToTrending() -> FlowContributors {
        let viewController = self.resolver.resolve(ReactiveSwiftTrendingViewController.self)!
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }

    func navigateTo(gif: GifOverview) -> FlowContributors {
        let viewController = self.resolver.resolve(ReactiveSwiftGifViewController.self, argument: gif)!
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
}
