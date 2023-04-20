//
//  ShortURL.swift
//  ShortURL
//
//  Created by Fabio Miciano on 20/04/23.
//

struct ShortURL: Decodable {
    let alias: String
    let link: Link
}

struct Link: Decodable {
    let original: String
    let short: String
}
