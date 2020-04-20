//
//  Spin_UIKit_DemoTests.swift
//  Spin.UIKit.DemoTests
//
//  Created by Thibault Wittemberg on 2020-04-19.
//  Copyright © 2020 Spinners. All rights reserved.
//

@testable import Spin_UIKit_Demo
import XCTest

final class Spin_UIKit_DemoTests: XCTestCase {

    func testExample() throws {
        let (previousPage, nextPage, numberOfPages) = Trending.Entity.pagesFrom(pagination: Pagination(count: 10,
                                                                                                       offset: 10,
                                                                                                       totalCount: 100),
                                                                                pageSize: 10)

        print(previousPage)
        print(nextPage)
        print(numberOfPages)

    }
}
