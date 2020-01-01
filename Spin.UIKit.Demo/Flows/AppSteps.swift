//
//  AppSteps.swift
//  Spin.iOS.Sample
//
//  Created by Thibault Wittemberg on 2019-09-02.
//  Copyright © 2019 Spinners. All rights reserved.
//

import RxFlow

enum AppSteps: Step {
    case home
    case planets
    case planet(planet: Planet)
    case peoples
    case people(people: People)
    case starships
    case starship(starship: Starship)
    case films
}
