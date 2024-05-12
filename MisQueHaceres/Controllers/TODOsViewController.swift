//
//  ViewController.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 09/05/23.
//

import UIKit

class TODOsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .red
        let button = UIButton()
        self.view.addSubview(button)
        
        
        button.addTarget(self, action: #selector(self.click), for: .touchUpInside)
        button.titleLabel?.text = "Repito"
    }
    
    @objc func click() {
        let controller = TODOsViewController()
        self.navigationController?.pushViewController(controller, animated: true)
    }

}
