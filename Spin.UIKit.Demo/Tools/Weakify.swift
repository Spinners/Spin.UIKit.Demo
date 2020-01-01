//
//  Weakify.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

func weakify<T: AnyObject, Input, Output>(_ source: T, nilValue: Output, function: @escaping (T, Input) -> Output) -> (Input) -> Output {
    return { [weak source] input -> Output in
        guard let source = source else {
            return nilValue
        }
        return function(source, input)
    }
}

func weakify<T: AnyObject, Input>(_ source: T, function: @escaping (T, Input) -> Void) -> (Input) -> Void {
    return { [weak source] input -> Void in
        guard let source = source else {
            return
        }
        return function(source, input)
    }
}

func weakify<T: AnyObject, Output>(_ source: T, nilValue: Output, function: @escaping (T) -> Output) -> () -> Output {
    return { [weak source] () -> Output in
        guard let source = source else {
            return nilValue
        }
        return function(source)
    }
}
