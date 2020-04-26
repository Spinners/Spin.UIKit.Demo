//
//  PlanetViewController.swift
//  FeedbackLoopDemo
//
//  Created by Thibault Wittemberg on 2019-11-20.
//  Copyright © 2019 WarpFactor. All rights reserved.
//

import Combine
import Player
import Reusable
import SpinCombine
import UIKit

class CombineGifViewController: UIViewController, StoryboardBased {

    fileprivate var uiSpin: UISpin<Gif.State, Gif.Event>!

    @IBOutlet private weak var gifTypeLabel: UILabel!
    @IBOutlet private weak var gifRatingLabel: UILabel!
    @IBOutlet private weak var gifUserLabel: UILabel!
    @IBOutlet private weak var gifFavoriteSwitch: UISwitch!
    @IBOutlet private weak var gifFavoriteIsLoadingActivity: UIActivityIndicatorView!
    @IBOutlet private weak var playerView: UIView!
    @IBOutlet private weak var failedLabel: UILabel!

    private lazy var gifPlayer: Player = {
        let player = Player()
        player.playbackLoops = true
        return player
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // embed the Gif player in the View hierarchy
        self.gifPlayer.playbackDelegate = self
        self.gifPlayer.view.frame = self.playerView.bounds

        self.addChild(self.gifPlayer)
        self.playerView.addSubview(self.gifPlayer.view)
        self.gifPlayer.didMove(toParent: self)

        self.uiSpin.render(on: self) { $0.interpret(state:) }
        self.uiSpin.start()
    }

    @IBAction func changeFavorite(_ sender: UISwitch) {
        self.uiSpin.emit(.setFavorite(favorite: sender.isOn))
    }
}

extension CombineGifViewController: PlayerPlaybackDelegate {
    func playerCurrentTimeDidChange(_ player: Player) {}
    func playerPlaybackWillStartFromBeginning(_ player: Player) {}
    func playerPlaybackWillLoop(_ player: Player) {}
    func playerPlaybackDidLoop(_ player: Player) {}
    
    func playerPlaybackDidEnd(_ player: Player) {
        player.playFromBeginning()
    }
}

extension CombineGifViewController {
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
        if self.gifPlayer.url == nil {
            self.gifPlayer.url = URL(string: gif.images.fixedHeightData.mp4)!
            self.gifPlayer.playFromBeginning()
        }
    }
}

extension CombineGifViewController {
    static func make(uiSpin: UISpin<Gif.State, Gif.Event>) -> CombineGifViewController {
        let viewController = CombineGifViewController.instantiate()
        viewController.uiSpin = uiSpin
        return viewController
    }
}
