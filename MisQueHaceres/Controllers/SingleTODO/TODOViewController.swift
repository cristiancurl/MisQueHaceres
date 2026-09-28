import UIKit

final class TODOViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    private var todoTask: TodoTaskModel

    init(todoTask: TodoTaskModel) {
        self.todoTask = todoTask
        super.init(nibName: "TODOViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    private func configureUI() {
        nameLabel.text = todoTask.name
        descriptionLabel.text = todoTask.specifications
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: todoTask.date)
    }
}
