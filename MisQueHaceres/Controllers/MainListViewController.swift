//
//  MainListViewController.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 09/05/23.
//

import UIKit

class MainListViewController: UITableViewController {
    
    let mainListViewModel = MainListViewModel()
    
    // UI Element
    private var emptyStateView: EmptyStateView!

    // MARK: Life Cicle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background title
        self.tableView.backgroundView?.backgroundColor = .black
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.green]
        
        // Refresh Control
        self.setRefreshControl()
        
        // Empty state
        self.setEmptyState()
        tableView.delegate = self
//        mainListViewModel.deleteAllObjects(Group.self)
    }
    
    // MARK: UI
    
    // Logo empty state
    private func setEmptyState() {
        emptyStateView = EmptyStateView(frame: tableView.bounds)
        self.tableView.backgroundView = emptyStateView
    }
    
    private func setRefreshControl() {
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
    }
    
    
    @objc func handleRefresh(_ sender: UIRefreshControl) {
        
        self.showAlertNewList()
        self.tableView.refreshControl?.endRefreshing()
    }
    
    /// Show alert controller
    private func showAlertNewList() {
        
        let basicAlert = BasicAlert().Showalert(title: "Agregar nombre", placeHolder: "Nombre") { name in
            self.mainListViewModel.saveGroup(name: name)
            self.tableView.reloadData()
            self.tableView.refreshControl?.endRefreshing()
        }
        present(basicAlert, animated: true, completion: nil)
    }
    
    
    // MARK: - TABLE DELEGATES
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Showing background
        let groups = mainListViewModel.getNamesOfGroup()
        if groups.count > 0 {
            self.tableView.backgroundView?.isHidden = true
        } else {
            self.tableView.backgroundView?.isHidden = false
        }
        
        return mainListViewModel.getNamesOfGroup().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //title row string
        let groupNames = mainListViewModel.getNamesOfGroup()
        let name = groupNames[indexPath.row].name
        
        // Table View Cell
        let cell = UITableViewCell()
        cell.contentView.backgroundColor = .black
        cell.textLabel?.text = name
        cell.textLabel?.font = UIFont(name: "Helvetica", size: 20)
        cell.textLabel?.textColor = .green
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    
    // Trailing a la derecha eliminar
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // How to separate contextual action
        let swipeAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] (action, view, completionHandler) in
            
            // Getting group to delete
            guard let groups = self?.mainListViewModel.getNamesOfGroup() else { return }
            let groupName = groups[indexPath.row].name
            self?.mainListViewModel.deleteGroupByName(groupName: groupName)
            self?.tableView.reloadData()
            // Done
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }
    
    // leading editar
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let swipeAction = UIContextualAction(style: .normal, title: "Editar") { [weak self] (action, view, completionHandler) in
            
            guard let groups = self?.mainListViewModel.getNamesOfGroup() else { return }
            let oldGroup = groups[indexPath.row]
            
            let basicAlert = BasicAlert().Showalert(title: "Editar nombre", placeHolder: "Nombre") { newName in
                self?.mainListViewModel.updateGroupName(oldGroup: oldGroup, newName: newName)
                self?.tableView.reloadData()
            }
            self?.present(basicAlert, animated: true, completion: nil)
        }
        
        swipeAction.backgroundColor = .green
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }
    
    // Scroll
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 3
        let offsetY = scrollView.contentOffset.y
        emptyStateView.transform = CGAffineTransform(translationX: 0, y: offsetY / 2)
    }
}

