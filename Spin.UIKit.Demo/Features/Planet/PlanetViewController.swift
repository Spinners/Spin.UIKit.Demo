//
//  PlanetViewController.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveCocoa
import ReactiveSwift
import Reusable
import Spin_ReactiveSwift
import UIKit

class PlanetViewController: UIViewController, StoryboardBased {

    fileprivate var viewContext: ReactiveViewContext<PlanetFeature.State, PlanetFeature.Action>!

    @IBOutlet private weak var planetNameLabel: UILabel!
    @IBOutlet private weak var planetDiameterLabel: UILabel!
    @IBOutlet private weak var planetPopulationLabel: UILabel!
    @IBOutlet private weak var planetGravityLabel: UILabel!
    @IBOutlet private weak var planetOrbitalPeriodLabel: UILabel!
    @IBOutlet private weak var planetRotationPeriodLabel: UILabel!
    @IBOutlet private weak var planetClimateLabel: UILabel!
    @IBOutlet private weak var planetFavoriteSwitch: UISwitch!
    @IBOutlet private weak var planetFavoriteIsLoadingActivity: UIActivityIndicatorView!

    let disposeBag = CompositeDisposable()

    deinit {
        disposeBag.dispose()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewContext.render(on: self) { $0.interpret(state:) }
    }

    @IBAction func changeFavorite(_ sender: UISwitch) {
        self.viewContext.perform(.setFavorite(favorite: sender.isOn))
    }
}

extension PlanetViewController {
    func interpret(state: PlanetFeature.State) -> Void {

        switch state {
        case .loading(let planet):
            self.display(planet: planet)
            self.planetFavoriteIsLoadingActivity.startAnimating()
            self.planetFavoriteSwitch.isHidden = true
            self.planetFavoriteSwitch.setOn(false, animated: true)
        case .loaded(let planet, let favorite):
            self.display(planet: planet)
            self.planetFavoriteIsLoadingActivity.stopAnimating()
            self.planetFavoriteSwitch.isHidden = false
            self.planetFavoriteSwitch.setOn(favorite, animated: true)
        case .enablingFavorite(let planet, let favorite):
            self.display(planet: planet)
            self.planetFavoriteIsLoadingActivity.startAnimating()
            self.planetFavoriteSwitch.isHidden = true
            self.planetFavoriteSwitch.setOn(favorite, animated: true)
        }
    }

    private func display(planet: Planet) {
        self.planetNameLabel.text = planet.name
        self.planetDiameterLabel.text = planet.diameter
        self.planetPopulationLabel.text = planet.population
        self.planetGravityLabel.text = planet.gravity
        self.planetOrbitalPeriodLabel.text = planet.orbitalPeriod
        self.planetRotationPeriodLabel.text = planet.rotationPeriod
        self.planetClimateLabel.text = planet.climate
    }
}

extension PlanetViewController {
    static func make(context: ReactiveViewContext<PlanetFeature.State, PlanetFeature.Action>) -> PlanetViewController {
        let viewController = PlanetViewController.instantiate()
        viewController.viewContext = context
        return viewController
    }
}
