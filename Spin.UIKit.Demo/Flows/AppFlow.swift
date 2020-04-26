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
        guard let step = step as? AppStep else { return .none }
        
        switch step {
        case .home:
            return self.navigateToHome()
        }
    }
}

extension AppFlow {
    func navigateToHome() -> FlowContributors {

        let flow1 = self.resolver.resolve(ReactiveSwiftNavigationFlow.self)!
        let flow2 = self.resolver.resolve(CombineNavigationFlow.self)!
        let flow3 = self.resolver.resolve(RxSwiftNavigationFlow.self)!

        Flows.whenReady(flow1: flow1, flow2: flow2, flow3: flow3) { [weak self] (root1, root2, root3) in
            let tabBarItem1 = UITabBarItem(title: "Trending (ReactiveSwift)", image: UIImage(systemName: "speedometer"), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root1.title = "Trending (ReactiveSwift)"
            
            let tabBarItem2 = UITabBarItem(title: "Trending (Combine)", image: UIImage(systemName: "speedometer"), selectedImage: nil)
            root2.tabBarItem = tabBarItem2
            root2.title = "Trending (Combine)"

            let tabBarItem3 = UITabBarItem(title: "Trending (RxSwift)", image: UIImage(systemName: "speedometer"), selectedImage: nil)
            root3.tabBarItem = tabBarItem3
            root3.title = "Trending (RxSwift)"

            self?.rootViewController.setViewControllers([root1, root2, root3], animated: false)
        }

        return .multiple(flowContributors: [
            .contribute(withNextPresentable: flow1, withNextStepper: OneStepper(withSingleStep: GifStep.trending)),
            .contribute(withNextPresentable: flow2, withNextStepper: OneStepper(withSingleStep: GifStep.trending)),
            .contribute(withNextPresentable: flow3, withNextStepper: OneStepper(withSingleStep: GifStep.trending))])
    }
}
