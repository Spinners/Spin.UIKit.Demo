//
//  Observable+merge.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

import RxSwift

extension Observable {
    static func merge<A>(functions: (Observable<A>) -> Observable<Element>...) -> (Observable<A>) -> Observable<Element> {
        return { (a: Observable<A>) -> Observable<Element> in
            let results: [Observable<Element>] = functions.map { $0(a) }
            return Observable<Element>.merge(results)
        }
    }
}
