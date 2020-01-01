//
//  Endpoint.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

/// The method used to fetch an Endpoint
///
/// - post: POST verb
/// - get: GET verb
/// - put: PUT verb
/// - delete: DELETE verb
enum HTTPMethod: String {
    case post = "POST"
    case get = "GET"
    case put = "PUT"
    case delete = "DELETE"
}

/// the encoding used to encode the parameters in the URL or in the Body
///
/// - json: json encoding (usually used for POST/PUT http methods)
/// - url: query string encoding (usually used for GET/DELETE http methods)
enum ParameterEncoding {
    case json
    case url
}

/// An Endpoint represents the information to access a precise Rest API resource.
/// The RequestModel associated to an Endpoint represents the data that can be passed
/// as query parameters or body parameters
/// The ResponseModel associated to an Endpoint is a shadow type that will allow
/// to infer in a type safe way the result of the query to this Endpoint.
protocol Endpoint {
    associatedtype RequestModel: Encodable
    associatedtype ResponseModel: Decodable

    /// the prefix path to access the Endpoint
    var prefixPath: String { get }

    /// the path to access the Endpoint
    var path: Path { get }

    /// the http method the network layer will have to use
    var httpMethod: HTTPMethod { get }

    /// the encoding used to encode parameters (could be JSONEncoding, URLEncoding)
    var parameterEncoding: ParameterEncoding { get }

    /// the access restriction associated to the endpoint
    var policy: Policy { get }

    /// the name of the endpoint
    static var name: String { get }
}

// MARK: - Extension to Endpoint defining default values for parameterEncoding and name
extension Endpoint {
    var parameterEncoding: ParameterEncoding {
        switch self.httpMethod {
        case .post, .put:
            return ParameterEncoding.json
        default:
            return ParameterEncoding.url
        }
    }

    static var name: String {
        return "\(self)"
    }
}

/// In case there is no need to have a RequestModel or a ResponseModel associated
/// with an Endpoint, we can use this "void" model
struct NoModel: Codable {}
