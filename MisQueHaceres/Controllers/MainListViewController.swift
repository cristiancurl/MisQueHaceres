//
//  MainListViewController.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 09/05/23.
//

import UIKit

class MainListViewController: UITableViewController, newTODODelegate {
    let mainListViewModel = MainListViewModel()
    
    // UI Element
    // TODO: Cosas para agregar:
    // descripcion al model de tarea.. cosa mas dificil ✅
    
    // ver la funcionaldiad del reloj
    // ver lo de las multilineas en las celdas
    // agregar animacion a las celdas importantes.
    //      se puede agregar un checkbox de cosas importantes y buscar diseño para recalcar
    // crearle diseño fresa a la app
    // arreglar el asunto con GIT por que tengo dos cuentas y este proyecto esta en CURL
    
    // MARK: Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
        self.setButtonAdd()
        tableView.delegate = self
    }
    
    // MARK: UI
    private func setButtonAdd() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddNew))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    // Add new TODO button
    @objc func goToAddNew() {
        // controlador extra para crear tarea
        let newTodoview = NewTODOViewController()
        newTodoview.delegate = self
        
        if let sheet = newTodoview.sheetPresentationController {
            // agregando propiedades de presentation a newTODOController
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
        }
        
        present(newTodoview, animated: true)
    }
    
    // MARK: - Delegete New
    
    /// Llamado del delegado de la ventana newTODO
    func newTodo(newTodoTask: TodoTaskModel) {
        Task {
            try await self.mainListViewModel.handleSaveTaskAsync(todoTask: newTodoTask)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.refreshControl?.endRefreshing()
                self.tableView.isScrollEnabled = true
            }
        }
        
        dismiss(animated: true)
    }
    
    // MARK: - TABLE DELEGATES
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        mainListViewModel.todoTasksArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table View Cell
        let cell = UITableViewCell()
        cell.textLabel?.text = mainListViewModel.todoTasksArray[indexPath.row].name
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 20)
        cell.textLabel?.numberOfLines = 2
        return cell
    }
    
    // Trailing a la derecha eliminar
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // How to separate contextual action
        let swipeAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] (action, view, completionHandler) in
            
            // Getting group to delete
            guard let todoTask = self?.mainListViewModel.todoTasksArray[indexPath.row] else { return }
            
            // Alert
            let alertBeforeDelete = BasicAlerts()
                .showAcceptAlert(
                    title: "Eliminar?",
                    message: "Desea eliminar a : \(todoTask.name)"
                ) {
                
                // Delete on View Model
                self?.mainListViewModel.deleteTodoTask(todoTask: todoTask)
                self?.tableView.reloadData()
                // Done
                completionHandler(true)
                
            } onCancel: {
                completionHandler(true)
            }
            
            self?.present(alertBeforeDelete, animated: true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }
    
    // leading editar
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipeAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] (action, view, completionHandler) in
            
            guard let groups = self?.mainListViewModel.todoTasksArray else { return }
            let oldGroup = groups[indexPath.row]
            // cambiar de alerta a view controller
            let basicAlert = BasicAlerts().showTextFieldAlert(title: "Editar nombre", placeHolder: "Nombre") { newName in
                self?.mainListViewModel.updateGroupName(oldGroup: oldGroup, newName: newName)
                self?.tableView.reloadData()
                completionHandler(true)
            } dismiss: {
                completionHandler(true)
            }
            self?.present(basicAlert, animated: true, completion: nil)
        }
        
        swipeAction.backgroundColor = .green
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }
    
    //Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = TODOViewController(todoTask: mainListViewModel.todoTasksArray[indexPath.row])
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

