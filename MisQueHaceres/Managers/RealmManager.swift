import Foundation
import RealmSwift

final class RealmManager {
    private let realm: Realm

    init() {
        do {
            self.realm = try Realm()
            configureRealmMigration()
        } catch {
            fatalError("Realm could not be initialized: \(error)")
        }
    }

    private func configureRealmMigration() {
        var config = Realm.Configuration.defaultConfiguration
        config.schemaVersion = 1
        config.migrationBlock = { migration, oldSchemaVersion in
            if oldSchemaVersion < 1 {
                migration.enumerateObjects(ofType: TodoTaskModel.className()) { _, newObject in
                    newObject?["name"] = newObject?["name"] ?? ""
                    newObject?["specifications"] = newObject?["specifications"] ?? ""
                    newObject?["date"] = newObject?["date"] ?? Date()
                }
            }
        }
        Realm.Configuration.defaultConfiguration = config
    }

    func getTodoTasks() -> [TodoTaskModel] {
        Array(realm.objects(TodoTaskModel.self).sorted(byKeyPath: "date", ascending: true))
    }

    func saveTask(_ task: TodoTaskModel, completion: @escaping (Bool) -> Void) {
        do {
            try realm.write {
                realm.add(task, update: .modified)
            }
            completion(true)
        } catch {
            print("Realm save error: \(error)")
            completion(false)
        }
    }

    func updateTask(_ task: TodoTaskModel, newName: String? = nil, newSpecifications: String? = nil, newDate: Date? = nil) {
        do {
            try realm.write {
                if let newName { task.name = newName }
                if let newSpecifications { task.specifications = newSpecifications }
                if let newDate { task.date = newDate }
            }
        } catch {
            print("Realm update error: \(error)")
        }
    }

    func deleteTodoTask(_ task: TodoTaskModel) {
        do {
            try realm.write {
                realm.delete(task)
            }
        } catch {
            print("Realm delete error: \(error)")
        }
    }
}
