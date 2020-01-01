//
//  FavoriteService.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Foundation

class FavoriteService {
    private var storage = [String: Bool]()

    init() {}

    func set(favorite: Bool, for resource: String) {
        sleep(1)
        UserDefaults.standard.set(favorite, forKey: resource)
    }

    func isFavorite(for resource: String) -> Bool {
        return UserDefaults.standard.bool(forKey: resource)
    }
}
