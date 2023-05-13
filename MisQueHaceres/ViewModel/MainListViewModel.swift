//
//  MainListViewModel.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 10/05/23.
//

import Foundation
import RealmSwift

struct MainListViewModel {
    
    /// New name of group saving on Realm
    func saveGroup(name: String) {
        do {
            // NewObject
            let realm = try! Realm()
            let group = Group()
            group.name = name
            
            // Save
            try! realm.write {
                realm.add(group)
            }
        } catch {
            print("system can not saved")
        }
    }
    
    /// Return an Array of objects saved on Realm
    func getNamesOfGroup() -> [String] {
        do {
            let realm = try! Realm()
            let groups = realm.objects(Group.self)
            var names: [String] = []
            
            for group in groups {
                names.append(group.name)
            }
            return names
        } catch {
            print("names were not get, error system")
            return []
        }
    }
    
    /// Update a specific Group by name
    func updateGroupName(oldName: String, newName: String) {
        do {
            // Obtaining Object to update
            let realm = try! Realm()
            let person = realm.objects(Group.self).filter("name == %@", oldName).first
            
            // Update
            try! realm.write {
                person?.name = newName
            }
        } catch {
            print("System error updating")
        }
    }
    
    /// Deleting a Group by name from Realm
    func deleteGroupByName(groupName: String) {
        // Obtaining Objetc to delete
        let realm = try! Realm()
        let group = realm.objects(Group.self).filter("name == %@", groupName).first
        
        // Delete
        if let group = group {
            try! realm.write {
                realm.delete(group)
            }
        }
    }
    
}
