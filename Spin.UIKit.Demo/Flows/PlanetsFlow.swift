//
//  PlanetsFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import Swinject
import UIKit

final class PlanetsFlow: Flow {

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
        case .planets:
            return self.navigateToPlanets()
        case .planet(let planet):
            return self.navigateTo(planet: planet)
        default:
            return .none
        }
    }
}

extension PlanetsFlow {
    func navigateToPlanets() -> FlowContributors {
        let viewController = self.resolver.resolve(PlanetsViewController.self)!
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }

    func navigateTo(planet: Planet) -> FlowContributors {
        let viewController = self.resolver.resolve(PlanetViewController.self, argument: planet)!
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
}
