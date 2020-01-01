//
//  PeopleFlow.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-14.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxCocoa
import RxFlow
import RxSwift
import Swinject
import UIKit

final class PeoplesFlow: Flow {

    private let resolver: Resolver

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
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
        case .peoples:
            return self.navigateToPeoples()
        case .people(let people):
            return self.navigateTo(people: people)
        default:
            return .none
        }
    }
}

extension PeoplesFlow {
    func navigateToPeoples() -> FlowContributors {
        let viewController = self.resolver.resolve(PeoplesViewController.self)!
        self.rootViewController.pushViewController(viewController, animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }

    func navigateTo(people: People) -> FlowContributors {
        let viewController = self.resolver.resolve(PeopleViewController.self, argument: people)!
        self.rootViewController.pushViewController(viewController, animated: true)
        return .none
    }
}
