//
//  StarshipViewController.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import UIKit
import Combine
import Reusable

class StarshipViewController: UIViewController, StoryboardBased {

    @IBOutlet private weak var starshipNameLabel: UILabel!
    @IBOutlet private weak var starshipModelLabel: UILabel!
    @IBOutlet private weak var starshipClassLabel: UILabel!
    @IBOutlet private weak var starshipManufacturerLabel: UILabel!
    @IBOutlet private weak var starshipCostInCreditsLabel: UILabel!
    @IBOutlet private weak var starshipLenghtLabel: UILabel!
    @IBOutlet private weak var starshipCrewLabel: UILabel!
    @IBOutlet private weak var starshipFavoriteSwitch: UISwitch!
    @IBOutlet private weak var starshipFavoriteIsLoadingActivity: UIActivityIndicatorView!

    var disposeBag = [AnyCancellable]()

    let viewWillAppearSubject = PassthroughSubject<Void, Never>()
    private let favoriteSwitchSubject = PassthroughSubject<Bool, Never>()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearSubject.send(())
    }

    @IBAction func setFavorite(_ sender: UISwitch) {
        self.favoriteSwitchSubject.send(sender.isOn)
    }
}

/////////////////////////
// FEEDBACKS
/////////////////////////
extension StarshipViewController {
    func stateFeedback(state: StarshipFeature.State) {
        self.interpret(state: state)
    }

    func actionFeedback() -> AnyPublisher<StarshipFeature.Action, Never> {
        return self.favoriteSwitchSubject
            .map { StarshipFeature.Action.setFavorite(favorite: $0) }
            .eraseToAnyPublisher()
    }
}

extension StarshipViewController {
    func interpret(state: StarshipFeature.State) -> Void {

        switch state {
        case .loading(let starship):
            self.display(starship: starship)
            self.starshipFavoriteIsLoadingActivity.startAnimating()
            self.starshipFavoriteSwitch.isHidden = true
            self.starshipFavoriteSwitch.setOn(false, animated: true)
        case .loaded(let starship, let favorite):
            self.display(starship: starship)
            self.starshipFavoriteIsLoadingActivity.stopAnimating()
            self.starshipFavoriteSwitch.isHidden = false
            self.starshipFavoriteSwitch.setOn(favorite, animated: true)
        case .enablingFavorite(let starship, let favorite):
            self.display(starship: starship)
            self.starshipFavoriteIsLoadingActivity.startAnimating()
            self.starshipFavoriteSwitch.isHidden = true
            self.starshipFavoriteSwitch.setOn(favorite, animated: true)
        }
    }

    private func display(starship: Starship) {
        self.starshipNameLabel.text = starship.name
        self.starshipModelLabel.text = starship.model
        self.starshipClassLabel.text = starship.starshipClass
        self.starshipManufacturerLabel.text = starship.manufacturer
        self.starshipCostInCreditsLabel.text = starship.costInCredits
        self.starshipLenghtLabel.text = starship.length
        self.starshipCrewLabel.text = starship.crew
    }
}
