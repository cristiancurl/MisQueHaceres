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
    
    
    // MARK: TABLE DELEGATES
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
        let name = groupNames[indexPath.row]
        
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
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        // How to separate contextual action
        let swipeAction = UIContextualAction(style: .destructive, title: "Eliminar") { [weak self] (action, view, completionHandler) in
            
            // Getting group to delete
            guard let groups = self?.mainListViewModel.getNamesOfGroup() else { return }
            let groupName = groups[indexPath.row]
            self?.mainListViewModel.deleteGroupByName(groupName: groupName)
            self?.tableView.reloadData()
            // Done
            completionHandler(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [swipeAction])
        return configuration
    }
    
    // Scroll
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 1
//        print(scrollView.contentOffset.y * -1)
//        let y = scrollView.contentOffset.y * -1
//        self.tableView.backgroundView?.frame = CGRect(x: self.view.frame.width / 2, y: y, width: 135, height: 180)
//        self.tableView.reloadData()
        // 2
//        let offsetY = scrollView.contentOffset.y
//
//        // Mover la imagen de fondo según la posición del scroll
//        if let backgroundView = tableView.backgroundView {
//            backgroundView.frame.origin.y = -offsetY / 2
//        }
        
        // 3
        let offsetY = scrollView.contentOffset.y
        emptyStateView.transform = CGAffineTransform(translationX: 0, y: offsetY / 2)
    }
}

