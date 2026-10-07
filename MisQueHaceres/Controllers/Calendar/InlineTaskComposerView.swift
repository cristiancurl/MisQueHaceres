import UIKit

protocol InlineTaskComposerViewDelegate: AnyObject {
    func didCreateTask(_ task: TodoTaskModel)
}

final class InlineTaskComposerView: UIView {
    weak var delegate: InlineTaskComposerViewDelegate?
    private let nameTextField = UITextField()
    private let descriptionTextField = UITextField()
    private let timeLabel = UILabel()
    private let addButton = UIButton(type: .system)
    private var selectedDate = Date()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = UIColor(red: 0.92, green: 0.95, blue: 1.0, alpha: 1.0)

        nameTextField.placeholder = "Task name"
        nameTextField.borderStyle = .roundedRect
        nameTextField.backgroundColor = .white
        addSubview(nameTextField)

        descriptionTextField.placeholder = "Description"
        descriptionTextField.borderStyle = .roundedRect
        descriptionTextField.backgroundColor = .white
        addSubview(descriptionTextField)

        timeLabel.text = "Time: Now"
        timeLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        timeLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        addSubview(timeLabel)

        addButton.setTitle("+ Add", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        addButton.addTarget(self, action: #selector(addTask), for: .touchUpInside)
        addSubview(addButton)

        setupConstraints()
    }

    private func setupConstraints() {
        nameTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            nameTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            nameTextField.heightAnchor.constraint(equalToConstant: 36),

            descriptionTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 8),
            descriptionTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            descriptionTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            descriptionTextField.heightAnchor.constraint(equalToConstant: 36),

            timeLabel.topAnchor.constraint(equalTo: descriptionTextField.bottomAnchor, constant: 8),
            timeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),

            addButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            addButton.centerYAnchor.constraint(equalTo: timeLabel.centerYAnchor),
            addButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
        ])
    }

    func setSelectedDate(_ date: Date) {
        selectedDate = date
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        timeLabel.text = "Time: \(formatter.string(from: date))"
    }

    @objc private func addTask() {
        guard let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !name.isEmpty,
              let description = descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
              !description.isEmpty else {
            showError()
            return
        }

        let task = TodoTaskModel(name: name, specifications: description, date: selectedDate)
        delegate?.didCreateTask(task)
        clearFields()
    }

    private func clearFields() {
        nameTextField.text = ""
        descriptionTextField.text = ""
    }

    private func showError() {
        nameTextField.layer.borderColor = UIColor.red.cgColor
        nameTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.red.cgColor
        descriptionTextField.layer.borderWidth = 1
    }
}
