import UIKit
import UserNotifications

final class SettingsViewController: UIViewController {
    private let settingsViewModel = SettingsViewModel()
    private let tableView = UITableView(style: .grouped)
    private let sections = ["Notifications", "Appearance", "Data", "Sync"]
    private var notificationSwitch: UISwitch!
    private var darkModeSwitch: UISwitch!
    private var syncSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }

    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.0, alpha: 1.0)
        title = "Settings"

        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingsCell")
        view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 50
    }
}

// MARK: - UITableViewDelegate & DataSource
extension SettingsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 1 // Notifications
        case 1: return 1 // Dark Mode
        case 2: return 1 // Delete Data
        case 3: return 1 // Sync
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
        cell.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)

        switch indexPath.section {
        case 0: // Notifications
            cell.textLabel?.text = "Enable Notifications"
            let notificationSwitch = UISwitch()
            notificationSwitch.isOn = settingsViewModel.notificationsEnabled
            notificationSwitch.addTarget(self, action: #selector(toggleNotifications(_:)), for: .valueChanged)
            cell.accessoryView = notificationSwitch
            self.notificationSwitch = notificationSwitch

        case 1: // Dark Mode
            cell.textLabel?.text = "Dark Mode"
            let darkModeSwitch = UISwitch()
            darkModeSwitch.isOn = settingsViewModel.isDarkMode
            darkModeSwitch.addTarget(self, action: #selector(toggleDarkMode(_:)), for: .valueChanged)
            cell.accessoryView = darkModeSwitch
            self.darkModeSwitch = darkModeSwitch

        case 2: // Delete Data
            cell.textLabel?.text = "Delete All Tasks"
            cell.textLabel?.textColor = .red
            cell.accessoryType = .disclosureIndicator

        case 3: // Sync
            cell.textLabel?.text = "Enable Sync"
            let syncSwitch = UISwitch()
            syncSwitch.isOn = settingsViewModel.syncEnabled
            syncSwitch.addTarget(self, action: #selector(toggleSync(_:)), for: .valueChanged)
            cell.accessoryView = syncSwitch
            self.syncSwitch = syncSwitch

        default:
            break
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 2 { // Delete All Tasks
            showDeleteConfirmation()
        }
    }

    @objc private func toggleNotifications(_ sender: UISwitch) {
        settingsViewModel.notificationsEnabled = sender.isOn
    }

    @objc private func toggleDarkMode(_ sender: UISwitch) {
        settingsViewModel.isDarkMode = sender.isOn
        // TODO: Apply theme changes to the app
    }

    @objc private func toggleSync(_ sender: UISwitch) {
        settingsViewModel.syncEnabled = sender.isOn
        if sender.isOn {
            settingsViewModel.syncData { success in
                print("Sync completed: \(success)")
            }
        }
    }

    private func showDeleteConfirmation() {
        let alert = UIAlertController(title: "Delete All Tasks", message: "Are you sure you want to delete all tasks? This action cannot be undone.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.settingsViewModel.deleteAllTasks { success in
                DispatchQueue.main.async {
                    if success {
                        let confirmAlert = UIAlertController(title: "Success", message: "All tasks have been deleted.", preferredStyle: .alert)
                        confirmAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(confirmAlert, animated: true)
                    } else {
                        let errorAlert = UIAlertController(title: "Error", message: "Failed to delete tasks.", preferredStyle: .alert)
                        errorAlert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(errorAlert, animated: true)
                    }
                }
            }
        })

        present(alert, animated: true)
    }
}
