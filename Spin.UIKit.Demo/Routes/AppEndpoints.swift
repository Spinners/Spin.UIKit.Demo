//
//  AppEndpoints.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct TrendingEndpoint: Endpoint {
    typealias RequestModel = TrendingRequest
    typealias ResponseModel = TrendingResponse

    let prefixPath = "/v1/gifs"
    let path: Path
    let httpMethod = HTTPMethod.get
    let parameterEncoding = ParameterEncoding.url
    let policy: Policy = AppPolicy.unauthenticated

    init(path: Path) {
        self.path = path
    }
}

struct GetByIdEndpoint: Endpoint {
    typealias RequestModel = GetByIdRequest
    typealias ResponseModel = GetByIdResponse

    let prefixPath = "/v1/gifs"
    let path: Path
    let httpMethod = HTTPMethod.get
    let parameterEncoding = ParameterEncoding.url
    let policy: Policy = AppPolicy.unauthenticated

    init(path: Path) {
        self.path = path
    }
}
