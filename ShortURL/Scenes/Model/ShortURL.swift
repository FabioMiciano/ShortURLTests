struct ShortURL: Codable, Equatable {
    let alias: String
    let link: Link
    
    enum CodingKeys: String, CodingKey {
        case alias
        case link = "_links"
    }
    
    static func == (lhs: ShortURL, rhs: ShortURL) -> Bool {
        lhs.alias == rhs.alias && lhs.link == rhs.link
    }
}

struct Link: Codable, Equatable {
    let original: String
    let short: String
    
    enum CodingKeys: String, CodingKey {
        case original = "self"
        case short
    }
}
