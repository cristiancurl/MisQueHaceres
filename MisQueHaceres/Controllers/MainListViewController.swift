import UIKit

final class MainListViewController: UITableViewController {
    let mainListViewModel = MainListViewModel()

    private func setButtonAdd() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddNew))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc private func goToAddNew() {
        let newTodoView = NewTODOViewController()
        newTodoView.delegate = self

        if let sheet = newTodoView.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }

        present(newTodoView, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        setButtonAdd()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainListViewModel.todoTasksArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = mainListViewModel.todoTasksArray[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TaskCell")
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.specifications
        cell.textLabel?.numberOfLines = 2
        cell.detailTextLabel?.numberOfLines = 2
        return cell
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = mainListViewModel.todoTasksArray[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] _, _, completion in
            guard let self else { return }
            let alert = BasicAlerts().showAcceptAlert(
                title: "Eliminar",
                message: "¿Deseas eliminar \(task.name)?",
                onAccept: {
                    self.mainListViewModel.deleteTodoTask(todoTask: task)
                    self.tableView.reloadData()
                    completion(true)
                },
                onCancel: {
                    completion(true)
                }
            )
            self.present(alert, animated: true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = mainListViewModel.todoTasksArray[indexPath.row]

        let editAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] _, _, completion in
            guard let self else { return }

            let alert = BasicAlerts().showTextFieldAlert(
                title: "Editar tarea",
                placeHolder: task.name,
                onSave: { newName in
                    let trimmed = newName.trimmingCharacters(in: .whitespacesAndNewlines)
                    if trimmed.isEmpty { completion(false); return }
                    self.mainListViewModel.updateTodo(task, newName: trimmed)
                    self.tableView.reloadData()
                    completion(true)
                },
                dismiss: { completion(true) }
            )

            self.present(alert, animated: true)
        }

        editAction.backgroundColor = .systemGreen
        return UISwipeActionsConfiguration(actions: [editAction])
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = mainListViewModel.todoTasksArray[indexPath.row]
        let controller = TODOViewController(todoTask: task)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension MainListViewController: NewTODODelegate {
    func newTodo(newTodoTask: TodoTaskModel) {
        Task {
            do {
                try await mainListViewModel.handleSaveTaskAsync(todoTask: newTodoTask)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.dismiss(animated: true)
                }
            } catch {
                print("Error saving todo: \(error)")
            }
        }
    }
}
