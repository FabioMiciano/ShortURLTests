//
//  APIError.swift
//  ShortURL
//
//  Created by Fabio Miciano on 24/04/23.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case requestFailedWith(statusCode: Int, message: String)
    case requestFailed(error: Error)
    case decodingFailed
}
