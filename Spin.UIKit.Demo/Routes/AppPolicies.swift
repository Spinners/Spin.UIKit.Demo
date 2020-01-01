//
//  AppPolicies.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

/// The Application's policies
///
/// - unauthenticated: the endpoints do not need authentication to be accessed
public enum AppPolicy: String {
    case unauthenticated
}

// MARK: - AppPolicies default implementation of CustomStringConvertible
extension AppPolicy: Policy {
    public var description: String {
        return self.rawValue
    }
}
