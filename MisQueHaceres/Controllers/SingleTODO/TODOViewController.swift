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
    
    // Formateador estático para reuso (UI thread)
    private static let displayFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yy HH:mm"
        df.locale = Locale.current
        df.timeZone = TimeZone.current
        return df
    }()

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
    }

    func setName() {
        guard let label = tienesQueLabel2 else {
            print("Error: tienesQueLabel es nil")
            return
        }
        label.text = self.todoTask.name
        descriptionLabel.text = self.todoTask.especifications
        setDate()
    }
    
    func setDate() {
        // la hora viene en zone 0
        // hay que pasarlo a dia fecha y hora
        
        dateTimeLabel.text = self.todoTask.date.description
    }
}
