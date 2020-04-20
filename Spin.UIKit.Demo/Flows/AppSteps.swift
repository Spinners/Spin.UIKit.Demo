//
//  AppSteps.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow

enum AppStep: Step {
    case home
}

enum GifStep: Step {
    case trending
    case gif(gif: GifOverview)
}
