import Foundation

protocol LocalDataManaging {
    func save<T: Codable>(item: T) throws
    func load<T: Codable>() throws -> [T]
}

final class LocalDataManager: LocalDataManaging {
    private let userDefaults: UserDefaults
    private let key: String
    
    init(userDefaults: UserDefaults = .standard, key: String) {
        self.userDefaults = userDefaults
        
        if let isUITesting = ProcessInfo.processInfo.environment["__XCODE_BUILT_PRODUCTS_DIR_PATHS"], isUITesting.contains("UITest"){
            self.key = "UITESTING"
        } else {
            self.key = key
        }
        
    }
 
// PRAGMA MARK: -- PUBLIC FUNTIONS --
    func save<T: Codable>(item: T) throws {
        var list:[T] = try load()
        list.append(item)
        let dataList = try JSONEncoder().encode(list)
        userDefaults.set(dataList, forKey: key)
    }
    
    func load<T: Codable>() throws -> [T] {
        
        guard
            let data = userDefaults.data(forKey: key),
            let items = try? JSONDecoder().decode([T].self, from: data) else {
            return []
        }
        
        return items
    }
}
