//
//  PlanetViewController.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Reusable
import SpinReactiveSwift
import UIKit

class ReactiveSwiftGifViewController: UIViewController, StoryboardBased {

    fileprivate var uiSpin: UISpin<Gif.State, Gif.Event>!

    @IBOutlet private weak var gifTypeLabel: UILabel!
    @IBOutlet private weak var gifRatingLabel: UILabel!
    @IBOutlet private weak var gifUserLabel: UILabel!
    @IBOutlet private weak var gifFavoriteSwitch: UISwitch!
    @IBOutlet private weak var gifFavoriteIsLoadingActivity: UIActivityIndicatorView!
    @IBOutlet private weak var playerView: PlayerUIView!
    @IBOutlet private weak var failedLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.uiSpin.render(on: self) { $0.interpret(state:) }
        self.uiSpin.start()
    }

    @IBAction func changeFavorite(_ sender: UISwitch) {
        self.uiSpin.emit(.setFavorite(favorite: sender.isOn))
    }
}

extension ReactiveSwiftGifViewController {
    func interpret(state: Gif.State) -> Void {

        switch state {
        case .loading:
            self.gifFavoriteIsLoadingActivity.startAnimating()
            self.gifTypeLabel.isHidden = true
            self.gifRatingLabel.isHidden = true
            self.gifUserLabel.isHidden = true
            self.playerView.isHidden = true
            self.gifFavoriteSwitch.isHidden = true
            self.gifFavoriteSwitch.setOn(false, animated: true)
            self.failedLabel.text = ""
            self.failedLabel.isHidden = true
        case .loaded(let gif, let favorite):
            self.display(gif: gif)
            self.gifFavoriteIsLoadingActivity.stopAnimating()
            self.playerView.isHidden = false
            self.gifFavoriteSwitch.isHidden = false
            self.gifFavoriteSwitch.setOn(favorite, animated: true)
            self.failedLabel.text = ""
            self.failedLabel.isHidden = true
        case .enablingFavorite(let gif, let favorite):
            self.display(gif: gif)
            self.gifFavoriteIsLoadingActivity.startAnimating()
            self.playerView.isHidden = false
            self.gifFavoriteSwitch.isHidden = true
            self.gifFavoriteSwitch.setOn(favorite, animated: true)
            self.failedLabel.text = ""
            self.failedLabel.isHidden = true
        case .failed:
            self.gifTypeLabel.isHidden = true
            self.gifRatingLabel.isHidden = true
            self.gifUserLabel.isHidden = true
            self.playerView.isHidden = true
            self.failedLabel.text = "Error while loading the Gif"
            self.failedLabel.isHidden = false
        }
    }

    private func display(gif: GifDetail) {
        self.navigationItem.title = gif.title
        self.gifTypeLabel.text = gif.type
        self.gifRatingLabel.text = gif.rating
        self.gifUserLabel.text = gif.username
        self.gifTypeLabel.isHidden = false
        self.gifRatingLabel.isHidden = false
        self.gifUserLabel.isHidden = false
        self.playerView.url = gif.images.fixedHeightData.mp4
        self.playerView.playFromBeginning()
    }
}

extension ReactiveSwiftGifViewController {
    static func make(uiSpin: UISpin<Gif.State, Gif.Event>) -> ReactiveSwiftGifViewController {
        let viewController = ReactiveSwiftGifViewController.instantiate()
        viewController.uiSpin = uiSpin
        return viewController
    }
}
