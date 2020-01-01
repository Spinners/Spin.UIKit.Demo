//
//  String+URLComponents.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

import Alamofire
import Foundation

extension String {
    var path: String {
        guard let url = try? self.asURL() else { return "" }
        return "/"+url.lastPathComponent+"/?"+url.query!
    }
    
    var baseUrl: String {
        guard let url = try? self.asURL() else { return "" }
        guard let baseUrl = url.host else { return "" }
        return baseUrl.description
    }
}
