//
//  PlanetViewController.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import ReactiveSwift
import Reusable
import Spin_ReactiveSwift
import UIKit

class PlanetViewController: UIViewController, StoryboardBased {

    fileprivate var uiSpin: ReactiveUISpin<PlanetFeature.State, PlanetFeature.Event>!
    private let disposeBag = CompositeDisposable()

    @IBOutlet private weak var planetNameLabel: UILabel!
    @IBOutlet private weak var planetDiameterLabel: UILabel!
    @IBOutlet private weak var planetPopulationLabel: UILabel!
    @IBOutlet private weak var planetGravityLabel: UILabel!
    @IBOutlet private weak var planetOrbitalPeriodLabel: UILabel!
    @IBOutlet private weak var planetRotationPeriodLabel: UILabel!
    @IBOutlet private weak var planetClimateLabel: UILabel!
    @IBOutlet private weak var planetFavoriteSwitch: UISwitch!
    @IBOutlet private weak var planetFavoriteIsLoadingActivity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiSpin.render(on: self) { $0.interpret(state:) }
        SignalProducer
            .start(spin: self.uiSpin)
            .disposed(by: self.disposeBag)
    }

    @IBAction func changeFavorite(_ sender: UISwitch) {
        self.uiSpin.emit(.setFavorite(favorite: sender.isOn))
    }

    deinit {
        self.disposeBag.dispose()
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
    static func make(uiSpin: ReactiveUISpin<PlanetFeature.State, PlanetFeature.Event>) -> PlanetViewController {
        let viewController = PlanetViewController.instantiate()
        viewController.uiSpin = uiSpin
        return viewController
    }
}
