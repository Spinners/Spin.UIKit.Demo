//
//  PlayerUIView.swift
//  Spin.SwiftUI.Demo
//
//  Created by Thibault Wittemberg on 2020-04-28.
//  Copyright © 2020 Spinners. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

class PlayerUIView: UIView {
    private let avPlayerLayer = AVPlayerLayer()
    private let startTime : CMTime = CMTimeMake(value: 10, timescale: 1)

    var url: String?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func playFromBeginning() {

        guard self.avPlayerLayer.player == nil else { return }

        if let urlString = self.url, let url = URL(string: urlString) {
            // Create the video player using the URL passed in.
            let player = AVPlayer(url: url)
            player.seek(to: startTime)
            player.volume = 0 // Will play audio if you don't set to zero
            player.play() // Set to play once created

            // Add the player to our Player Layer
            self.avPlayerLayer.player = player
            self.avPlayerLayer.videoGravity = .resizeAspectFill // Resizes content to fill whole video layer.
            self.avPlayerLayer.backgroundColor = UIColor.clear.cgColor
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(playerDidEnd(notification:)),
                                                   name: .AVPlayerItemDidPlayToEndTime,
                                                   object: player.currentItem)

            self.layer.addSublayer(avPlayerLayer)
        }
    }

    @objc func playerDidEnd(notification: Notification) {
        if let avPlayerItem = notification.object as? AVPlayerItem {
            avPlayerItem.seek(to: startTime, completionHandler: { [weak self] _ in
                self?.avPlayerLayer.player?.play()
            })
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        self.avPlayerLayer.frame = bounds
    }
}
