import Foundation
import UserNotifications

final class SettingsViewModel {
    private let realmManager: RealmManager

    var isDarkMode: Bool {
        get {
            UserDefaults.standard.bool(forKey: "isDarkMode")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "isDarkMode")
        }
    }

    var notificationsEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: "notificationsEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "notificationsEnabled")
            if newValue {
                requestNotificationPermissions()
            }
        }
    }

    var syncEnabled: Bool {
        get {
            UserDefaults.standard.bool(forKey: "syncEnabled")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "syncEnabled")
        }
    }

    init(realmManager: RealmManager = RealmManager()) {
        self.realmManager = realmManager
    }

    // MARK: - Notifications
    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }

    func getNotificationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    // MARK: - Data Management
    func deleteAllTasks(completion: @escaping (Bool) -> Void) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.deleteAll()
            }
            completion(true)
        } catch {
            print("Error deleting all tasks: \(error)")
            completion(false)
        }
    }

    // MARK: - Sync (Placeholder for future implementation)
    func syncData(completion: @escaping (Bool) -> Void) {
        // TODO: Implement cloud sync logic here
        // For now, this is a placeholder
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(true)
        }
    }
}
