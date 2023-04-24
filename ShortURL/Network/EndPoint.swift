//
//  EndPoint.swift
//  ShortURL
//
//  Created by Fabio Miciano on 24/04/23.
//

import Foundation

protocol EndPoint {
    var path: String { get }
    var method: Method { get }
    var parameters: [String: Any]? { get }
    var header: String? { get }
}
