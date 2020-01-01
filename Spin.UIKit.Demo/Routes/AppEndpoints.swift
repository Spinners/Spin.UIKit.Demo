//
//  AppEndpoints.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct ListEndpoint<Entity: Decodable>: Endpoint {
    typealias RequestModel = ListRequest
    typealias ResponseModel = ListResponse<Entity>

    let prefixPath = "/api"
    let path: Path
    let httpMethod = HTTPMethod.get
    let parameterEncoding = ParameterEncoding.url
    let policy: Policy = AppPolicy.unauthenticated

    init(path: Path) {
        self.path = path
    }
}

struct EntityEndpoint<Entity: Decodable>: Endpoint {
    typealias RequestModel = NoModel
    typealias ResponseModel = Entity

    let prefixPath = "/api"
    let path: Path
    let httpMethod = HTTPMethod.get
    let parameterEncoding = ParameterEncoding.url
    let policy: Policy = AppPolicy.unauthenticated

    init(path: Path) {
        self.path = path
    }
}

