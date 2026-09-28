import UIKit
import UserNotifications

protocol NewTODODelegate: AnyObject {
    func newTodo(newTodoTask: TodoTaskModel)
}

final class NewTODOViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var timeDatePicker: UIDatePicker!

    weak var delegate: NewTODODelegate?
    var selectedDate: Date = Date().addingTimeInterval(120)

    override func viewDidLoad() {
        super.viewDidLoad()
        timeDatePicker.minimumDate = selectedDate
        timeDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc private func dateChanged(_ sender: UIDatePicker) {
        selectedDate = sender.date
    }

    @IBAction func saveButtonPress(_ sender: Any) {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty,
              let description = descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !description.isEmpty else {
            textViewError()
            return
        }

        goodStyle()
        let newTask = TodoTaskModel(name: name, specifications: description, date: selectedDate)
        delegate?.newTodo(newTodoTask: newTask)
    }

    private func textViewError() {
        nameTextField.layer.borderColor = UIColor.red.cgColor
        nameTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.red.cgColor
        descriptionTextField.layer.borderWidth = 1
    }

    private func goodStyle() {
        nameTextField.layer.borderColor = UIColor.gray.cgColor
        nameTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.gray.cgColor
        descriptionTextField.layer.borderWidth = 1
    }
}
