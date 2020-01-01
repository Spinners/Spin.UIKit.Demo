//
//  AppFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow
import Swinject
import UIKit

class AppFlow: Flow {

    private let resolver: Resolver

    private lazy var rootViewController: UITabBarController = {
        let viewController = UITabBarController()
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
        case .home:
            return self.navigateToHome()
        default:
            return .none
        }
    }
}

extension AppFlow {
    func navigateToHome() -> FlowContributors {

        let planetsFlow = self.resolver.resolve(PlanetsFlow.self)!
        let peoplesFlow = self.resolver.resolve(PeoplesFlow.self)!
        let starshipsFlow = self.resolver.resolve(StarshipsFlow.self)!

        Flows.whenReady(flow1: planetsFlow, flow2: peoplesFlow, flow3: starshipsFlow) { [weak self] (planetsRoot, peoplesRoot, starshipsRoot) in
            let tabBarItem1 = UITabBarItem(title: "Planets", image: UIImage(systemName: "mappin.and.ellipse"), selectedImage: nil)
            planetsRoot.tabBarItem = tabBarItem1
            planetsRoot.title = "Planets (Reactive)"
            
            let tabBarItem2 = UITabBarItem(title: "Peoples", image: UIImage(systemName: "person"), selectedImage: nil)
            peoplesRoot.tabBarItem = tabBarItem2
            peoplesRoot.title = "Peoples (Rx)"

            let tabBarItem3 = UITabBarItem(title: "Starships", image: UIImage(systemName: "airplane"), selectedImage: nil)
            starshipsRoot.tabBarItem = tabBarItem3
            starshipsRoot.title = "Starships (Combine)"

            self?.rootViewController.setViewControllers([planetsRoot, peoplesRoot, starshipsRoot], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: planetsFlow, withNextStepper: OneStepper(withSingleStep: AppSteps.planets)),
            .contribute(withNextPresentable: peoplesFlow, withNextStepper: OneStepper(withSingleStep: AppSteps.peoples)),
            .contribute(withNextPresentable: starshipsFlow, withNextStepper: OneStepper(withSingleStep: AppSteps.starships))])
    }
}
