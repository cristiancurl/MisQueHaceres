//
//  ViewController.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 09/05/23.
//

import UIKit

class TODOViewController: UIViewController {

    @IBOutlet weak var tienesQueLabel2: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateTimeLabel: UILabel!
    var todoTask: TodoTaskModel

    init(todoTask: TodoTaskModel) {
        self.todoTask = todoTask
        super.init(nibName: "TODOViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.todoTask = TodoTaskModel()
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setName()
        setDate()
    }

    func setName() {
        guard let label = tienesQueLabel2 else {
            print("Error: tienesQueLabel es nil")
            return
        }
        label.text = self.todoTask.name
        descriptionLabel.text = self.todoTask.especifications
    }
    
    func setDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        let date = dateFormatter.string(from: self.todoTask.date)
        dateTimeLabel.text = date
    }
}
