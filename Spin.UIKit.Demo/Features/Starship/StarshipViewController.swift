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
import Spin_Combine

class StarshipViewController: UIViewController, StoryboardBased {

    fileprivate var viewContext: CombineViewContext<StarshipFeature.State, StarshipFeature.Action>!

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

    private let viewWillAppearSubject = PassthroughSubject<Void, Never>()

    lazy var viewWillAppearPublisher: AnyPublisher<Void, Never> = {
        self.viewWillAppearSubject.first().eraseToAnyPublisher()
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewWillAppearSubject.send(())
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewContext.render(on: self) { $0.interpret(state:) }
    }

    @IBAction func changeFavorite(_ sender: UISwitch) {
        self.viewContext.perform(.setFavorite(favorite: sender.isOn))
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

extension StarshipViewController {
    static func make(context: CombineViewContext<StarshipFeature.State, StarshipFeature.Action>) -> StarshipViewController {
        let viewController = StarshipViewController.instantiate()
        viewController.viewContext = context
        return viewController
    }
}
