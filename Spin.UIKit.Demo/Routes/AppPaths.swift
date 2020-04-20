//
//  AppPaths.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

public enum VersatilePath {
    case path(path: String)
}

public enum GiphyPath {
    case trending
    case getById(id: String)
}

extension GiphyPath: Path {
    public var description: String {
        switch self {
        case .trending:
            return "/trending"
        case .getById(let id):
            return "/\(id)"
        }
    }
}
