//
//  ShortURL.swift
//  ShortURL
//
//  Created by Fabio Miciano on 20/04/23.
//

struct ShortURL: Codable {
    let alias: String
    let link: Link
    
    enum CodingKeys: String, CodingKey {
        case alias
        case link = "_links"
    }
}

struct Link: Codable {
    let original: String
    let short: String
    
    enum CodingKeys: String, CodingKey {
        case original = "self"
        case short
    }
}
