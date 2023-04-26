import XCTest
@testable import ShortURL

final class LocalDataManagerTests: XCTestCase {
    private lazy var userDefaultsSpy = UserDefaultsSpy()
    private lazy var keyMock = "unitTest"
    lazy var sut = LocalDataManager(userDefaults: userDefaultsSpy, key: keyMock)
    
    func testSaveItem_WhenReceiveValidModel_ShouldSetFuncCalled() {
        let linkMock = Link(original: "http://example.com", short: "http://localhost:3000/alias/1313")
        let modelMock = ShortURL(alias: "1313", link: linkMock)
        
        XCTAssertNoThrow(try sut.save(item: modelMock))
        XCTAssertEqual(userDefaultsSpy.saveCalledCount, 1)
        XCTAssertFalse(userDefaultsSpy.currentData.isEmpty)
    }
    
    func testLoad_WhenHasSavedItens_ShouldReturnListOfShortURLModel() {
        let linkMock1 = Link(original: "http://example.com", short: "http://localhost:3000/alias/1313")
        let modelMock1 = ShortURL(alias: "1313", link: linkMock1)
        let linkMock2 = Link(original: "http://example.com", short: "http://localhost:3000/alias/1414")
        let modelMock2 = ShortURL(alias: "1414", link: linkMock2)
        let listToSave = [modelMock1, modelMock2]
        
        userDefaultsSpy.set(listToSave, forKey: keyMock)
        
        let listItem: [ShortURL]? = try? sut.load()
        
        XCTAssertNotNil(listItem)
        XCTAssertEqual(listItem?.count, 2)
    }
}

private final class UserDefaultsSpy: UserDefaults {
    private(set) var currentData: [String: Any] = [:]
    
    private(set) var saveCalledCount = 0
    override func set(_ value: Any?, forKey defaultName: String) {
        saveCalledCount += 1
        
        guard let value = value else { return }
        
        currentData[defaultName] = value
    }
    
    private(set) var loadDataCalledCount = 0
    override func data(forKey defaultName: String) -> Data? {
        loadDataCalledCount += 1
        
        guard let value = currentData[defaultName] as? [ShortURL] else { return nil }
        let data = try? JSONEncoder().encode(value)
        
        return data
    }
}
