//
//  MainListViewModel.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 10/05/23.
//

import Foundation
import RealmSwift
import UserNotifications
import UIKit

class MainListViewModel {
    var todoTasksArray: [TodoTaskModel] = []
    var realmManager: RealmManager = RealmManager()
    
    init() {
        setTodoTasks()
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
    
    @MainActor // si es para actualizar la UI asi ya no se necesita main.async
    func loadImageAsync(from url: URL) async throws -> UIImage? {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            throw URLError(.cannotDecodeContentData)
        }
    }
    
    func chafa(completion: @escaping(Result<String, Error>) -> Void) {
        
    }
    
    func deleteAllObjects<T: Object>(_ objectType: T.Type) {
        do {
            var realm = try Realm()
            
            let objects = realm.objects(objectType)
            try! realm.write {
                realm.delete(objects)
            }
        } catch let error {
            print("system can not delete \(error)")
        }
    }
    
    /// New name of group saving on Realm
    func handleSaveTask(todoTask: TodoTaskModel, completion: @escaping (Bool) -> Void) {
        
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self.addNotificationRequest(todoTask: todoTask) { quePaso in
                    if quePaso {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
            case .notDetermined, .denied:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        self.addNotificationRequest(todoTask: todoTask) { quePaso in
                            if quePaso {
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }
                    } else {
                        // manejar rechazo (mostrar alerta, guardar estado, etc.)
                        print("se nego todo")
                        completion(false)
                    }
                }
            default:
                break
            }
        }
        
    }
    
    
    func handleSaveTaskAsync(todoTask: TodoTaskModel) async throws {
        try await withCheckedThrowingContinuation { continuation in
            handleSaveTask(todoTask: todoTask) { quePacho in
                if quePacho {
                    continuation.resume(returning: true)
                } else {
                    continuation.resume(returning: false)
                }
            }
        }
    }
    
    func saveTask(for todoTask: TodoTaskModel, completion: @escaping (Bool) -> Void) {
        DispatchQueue.main.async {
            self.realmManager.saveTask(newTodoTask: todoTask) { quePaso in
                self.setTodoTasks()
                if quePaso {
                    completion(true)
                } else {
                    // se me apago
                    print("error en el saveVIewModel")
                    completion(false)
                }
            }
        }
    }
    
    private func addNotificationRequest(todoTask: TodoTaskModel, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = todoTask.name
        content.body = todoTask.especifications
        content.sound = UNNotificationSound.default
        
        // Usar DateComponents para programar en fecha específica (comportamiento de calendario)
        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: todoTask.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)

        let request = UNNotificationRequest(identifier: todoTask.id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let err = error {
                print("Error scheduling notification:", err)
                completion(false)
            } else {
                print("Scheduled notification with id:", todoTask.id)
                self.saveTask(for: todoTask) { quePaso in
                    if quePaso {
                        completion(true)
                    } else {
                        completion(false)
                    }
                }
                
            }
        }
    }
    
    /// Return an Array of objects saved on Realm
    func setTodoTasks() {
        self.todoTasksArray = realmManager.getTodoTasks()
    }
    
    /// Update a specific Group by name
    func updateGroupName(oldGroup: TodoTaskModel, newName: String) {
        do {
            // Obtaining Object to update
            let realm = try! Realm()
            let person = realm.objects(TodoTaskModel.self).filter("id == %@", oldGroup.id).first
            
            // Update
            try! realm.write {
                person?.name = newName
            }
        } catch {
            print("System error updating")
        }
    }
    
    /// Deleting a Group by name from Realm
    func deleteTodoTask(todoTask: TodoTaskModel) {
        self.realmManager.deleteTodoTask(todoTask: todoTask)
        self.setTodoTasks()
    }
    
}


