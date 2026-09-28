import Foundation
import RealmSwift

class TodoTaskModel: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String = ""
    @Persisted var specifications: String = ""
    @Persisted var date: Date = Date()

    convenience init(name: String, specifications: String, date: Date) {
        self.init()
        self.id = UUID().uuidString
        self.name = name
        self.specifications = specifications
        self.date = date
    }

    override static func ignoredProperties() -> [String] {
        []
    }
}
