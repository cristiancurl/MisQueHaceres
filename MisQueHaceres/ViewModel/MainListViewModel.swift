import Foundation
import RealmSwift
import UserNotifications
import UIKit

final class MainListViewModel {
    var todoTasksArray: [TodoTaskModel] = []
    private let realmManager: RealmManager

    init(realmManager: RealmManager = RealmManager()) {
        self.realmManager = realmManager
        setTodoTasks()
    }

    func setTodoTasks() {
        todoTasksArray = realmManager.getTodoTasks()
    }

    func saveTask(_ task: TodoTaskModel, completion: @escaping (Bool) -> Void) {
        realmManager.saveTask(task) { success in
            if success { self.setTodoTasks() }
            completion(success)
        }
    }

    func updateTodo(_ task: TodoTaskModel, newName: String? = nil, newSpecifications: String? = nil, newDate: Date? = nil) {
        realmManager.updateTask(task, newName: newName, newSpecifications: newSpecifications, newDate: newDate)
        setTodoTasks()
    }

    func deleteTodoTask(todoTask: TodoTaskModel) {
        realmManager.deleteTodoTask(todoTask)
        setTodoTasks()
    }

    func handleSaveTask(todoTask: TodoTaskModel, completion: @escaping (Bool) -> Void) {
        let center = UNUserNotificationCenter.current()

        center.getNotificationSettings { [weak self] settings in
            switch settings.authorizationStatus {
            case .authorized, .provisional:
                self?.scheduleNotification(for: todoTask, completion: completion)
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    if granted {
                        self?.scheduleNotification(for: todoTask, completion: completion)
                    } else {
                        completion(false)
                    }
                }
            default:
                completion(false)
            }
        }
    }

    private func scheduleNotification(for todoTask: TodoTaskModel, completion: @escaping (Bool) -> Void) {
        let content = UNMutableNotificationContent()
        content.title = todoTask.name
        content.body = todoTask.specifications
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: todoTask.date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: todoTask.id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error {
                print("Notification error: \(error)")
                self.saveTask(todoTask) { completion($0) }
                return
            }

            self.saveTask(todoTask) { completion($0) }
        }
    }
}
