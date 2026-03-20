//
//  RealmManager.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 02/02/26.
//

import Foundation
import RealmSwift

class RealmManager {
    private var _realm: Realm?
    private var realm: Realm {
        get throws {
            if let existingRealm = _realm, !existingRealm.isInWriteTransaction {
                return existingRealm
            }
            
            let newRealm = try Realm()
            _realm = newRealm
            return newRealm
        }
    }
    
    init() {
        setupRealm()
        configureRealmMigration()
    }
    
    private func setupRealm() {
        do {
            _realm = try Realm()
            print("✅ RealmDatabaseManager inicializado")
        } catch {
            print("❌ Error inicializando Realm: \(error)")
            // En producción, podrías registrar este error en Crashlytics
        }
    }
    
    /// Return an Array of objects saved on Realm
    func getTodoTasks() -> [TodoTaskModel] {
        do {
            let realmInstance = try realm
            let groups = realmInstance.objects(TodoTaskModel.self)
            var names: [TodoTaskModel] = []
            
            for group in groups {
                names.append(group)
            }
            return names
        } catch let error {
            print("Error al obtener")
            return []
        }
    }
    
    /// New name of group saving on Realm
    func saveTask(newTodoTask: TodoTaskModel, completion: @escaping (Bool) -> Void) {
        do {
            let realmInstance = try realm
            
            try realmInstance.write {
                realmInstance.add(newTodoTask)
            }
            completion(true)
        } catch let error {
            print("system can not saved: \(error)")
            completion(false)
        }
    }
    
    /// Deleting task from realm
    func deleteTodoTask(todoTask: TodoTaskModel) {
        do {
            
            let realmInstance = try realm
            if let group = realmInstance.objects(TodoTaskModel.self).filter("id == %@", todoTask.id).first {
                try realmInstance.write {
                    realmInstance.delete(group)
                }
            }
            
        } catch let error {
            
            print("fallo al borrar")
            print(error.localizedDescription)
            
        }
    }
    
    func configureRealmMigration() {
        var config = Realm.Configuration()
        // Incrementa este número cada vez que cambies el esquema
        config.schemaVersion = 3

        config.migrationBlock = { migration, oldSchemaVersion in
//            if oldSchemaVersion < 2 {
                // No es necesario asignar la nueva propiedad si es opcional o tiene valor por defecto.
                // Si quieres dar un valor por defecto puedes hacerlo aquí:
                // migration.enumerateObjects(ofType: Group.className()) { oldObject, newObject in
                //     newObject?["descripcion"] = "valor por defecto"
                // }
//            }
        }

        Realm.Configuration.defaultConfiguration = config
    }
}
