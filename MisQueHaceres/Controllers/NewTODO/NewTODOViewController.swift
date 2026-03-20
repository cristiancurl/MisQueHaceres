//
//  NewTODOViewController.swift
//  MisQueHaceres
//
//  Created by Cristian Plascencia on 27/01/26.
//

import UIKit
import UserNotifications

// Comunicacion con MainListVC
protocol newTODODelegate {
    func newTodo(newTodoTask: TodoTaskModel)
}

class NewTODOViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var timeDatePicker: UIDatePicker!
    var selectedDate: Date = Date().addingTimeInterval(60 * 2)
    
    var delegate: newTODODelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeDatePicker.minimumDate = selectedDate
        timeDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        self.view.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(gesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func dateChanged(_ sender: UIDatePicker) {
        print(sender.date)
        self.selectedDate = sender.date
    }
    
    // Perfeccionar textfields para utilizar un solo componente
    @IBAction func SaveButtonPress(_ sender: Any) {
        if let nameText = nameTextField.text,
           let descriptionText = descriptionTextField.text {
            if nameText.isEmpty || descriptionText.isEmpty {
                textViewError()
            } else {
                goodStyle()
                let newTask = TodoTaskModel()
                newTask.name = nameText
                newTask.especifications = descriptionText
                newTask.date = selectedDate
                newTask.id = UUID().uuidString
                delegate?.newTodo(newTodoTask: newTask)
            }
        } else {
            print("algo no cargo")
        }
    }
    
    func scheduleLocalNotification(for task: TodoTaskModel) {
            let center = UNUserNotificationCenter.current()

            // Solicitar autorización si es necesario
            center.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized, .provisional:
//                    self.addNotificationRequest(alarm: alarm)
                    break
                case .notDetermined:
                    break
//                    center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
//                        if granted {
//                            self.addNotificationRequest(alarm: alarm)
//                        } else {
//                            // manejar rechazo (mostrar alerta, guardar estado, etc.)
//                        }
//                    }
                default:
                    // autorizado denegado o restringido: avisar al usuario para activar en Settings
                    break
                }
            }
        }
    
    func textViewError() {
        nameTextField.layer.borderColor = UIColor.red.cgColor
        nameTextField.layer.borderWidth = 1
    }
    
    func goodStyle() {
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.layer.borderWidth = 1
    }
}
