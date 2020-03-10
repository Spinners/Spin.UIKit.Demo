//
//  PeopleViewController.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Reusable
import Spin_RxSwift

class PeopleViewController: UIViewController, StoryboardBased {

    fileprivate var uiSpin: RxUISpin<PeopleFeature.State, PeopleFeature.Event>!
    private let disposeBag = DisposeBag()

    @IBOutlet private weak var peopleNameLabel: UILabel!
    @IBOutlet private weak var peopleGenderLabel: UILabel!
    @IBOutlet private weak var peopleEyeColorLabel: UILabel!
    @IBOutlet private weak var peopleSkinColorLabel: UILabel!
    @IBOutlet private weak var peopleMassLabel: UILabel!
    @IBOutlet private weak var peopleHeightLabel: UILabel!
    @IBOutlet private weak var peopleHairColorLabel: UILabel!
    @IBOutlet private weak var peopleFavoriteSwitch: UISwitch!
    @IBOutlet private weak var peopleFavoriteIsLoadingActivity: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.uiSpin.render(on: self) { $0.interpret(state:) }
        Observable
            .start(spin: self.uiSpin)
            .disposed(by: self.disposeBag)
    }

    @IBAction func changeFavorite(_ sender: UISwitch) {
        self.uiSpin.emit(.setFavorite(favorite: sender.isOn))
    }
}

extension PeopleViewController {
    func interpret(state: PeopleFeature.State) -> Void {

        switch state {
        case .loading(let people):
            self.display(people: people)
            self.peopleFavoriteIsLoadingActivity.startAnimating()
            self.peopleFavoriteSwitch.isHidden = true
            self.peopleFavoriteSwitch.setOn(false, animated: true)
        case .loaded(let people, let favorite):
            self.display(people: people)
            self.peopleFavoriteIsLoadingActivity.stopAnimating()
            self.peopleFavoriteSwitch.isHidden = false
            self.peopleFavoriteSwitch.setOn(favorite, animated: true)
        case .enablingFavorite(let people, let favorite):
            self.display(people: people)
            self.peopleFavoriteIsLoadingActivity.startAnimating()
            self.peopleFavoriteSwitch.isHidden = true
            self.peopleFavoriteSwitch.setOn(favorite, animated: true)
        }
    }

    private func display(people: People) {
        self.peopleNameLabel.text = people.name
        self.peopleGenderLabel.text = people.gender
        self.peopleEyeColorLabel.text = people.eyeColor
        self.peopleSkinColorLabel.text = people.skinColor
        self.peopleMassLabel.text = people.mass
        self.peopleHeightLabel.text = people.height
        self.peopleHairColorLabel.text = people.hairColor
    }
}

extension PeopleViewController {
    static func make(uiSpin: RxUISpin<PeopleFeature.State, PeopleFeature.Event>) -> PeopleViewController {
        let viewController = PeopleViewController.instantiate()
        viewController.uiSpin = uiSpin
        return viewController
    }
}
