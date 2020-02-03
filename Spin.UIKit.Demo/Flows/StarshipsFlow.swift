//
//  StarshipsFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-10-06.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import Swinject
import UIKit

final class StarshipsFlow: Flow {

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
        guard let step = step as? AppSteps else { return .none }

        switch step {
        case .starships:
            return self.navigateToStarships()
        case .starship(let starship):
            return self.navigateTo(starship: starship)
        default:
            return .none
        }
    }
}

extension StarshipsFlow {
    func navigateToStarships() -> FlowContributors {
        let viewController = self.resolver.resolve(StarshipsViewController.self)!
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }

    func navigateTo(starship: Starship) -> FlowContributors {
        let viewController = self.resolver.resolve(StarshipViewController.self, argument: starship)!
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
}
