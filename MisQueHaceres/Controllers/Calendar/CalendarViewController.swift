import UIKit

final class CalendarViewController: UIViewController {
    private let calendarViewModel = CalendarViewModel()
    private var calendarCollectionView: UICollectionView!
    private var tasksTableView: UITableView!
    private var monthLabel: UILabel!
    private let inlineComposerView = InlineTaskComposerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupCollectionView()
        setupTableView()
        calendarViewModel.selectedDate = Date()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarViewModel.updateTasksForSelectedDate()
        tasksTableView.reloadData()
        calendarCollectionView.reloadData()
    }

    // MARK: - UI Setup
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 1.0, alpha: 1.0) // Pastel light blue
        title = "Calendar"

        // Month Label
        monthLabel = UILabel()
        monthLabel.text = calendarViewModel.getMonthYear(calendarViewModel.currentDate)
        monthLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        monthLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0) // Pastel blue
        monthLabel.textAlignment = .center
        view.addSubview(monthLabel)

        // Navigation Buttons
        let previousButton = UIButton(type: .system)
        previousButton.setTitle("←", for: .normal)
        previousButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        previousButton.addTarget(self, action: #selector(previousMonth), for: .touchUpInside)
        view.addSubview(previousButton)

        let nextButton = UIButton(type: .system)
        nextButton.setTitle("→", for: .normal)
        nextButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nextButton.addTarget(self, action: #selector(nextMonth), for: .touchUpInside)
        view.addSubview(nextButton)

        let todayButton = UIButton(type: .system)
        todayButton.setTitle("Today", for: .normal)
        todayButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        todayButton.addTarget(self, action: #selector(goToToday), for: .touchUpInside)
        view.addSubview(todayButton)

        // Collection View (Calendar Grid)
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        calendarCollectionView.backgroundColor = .clear
        calendarCollectionView.register(CalendarDayCell.self, forCellWithReuseIdentifier: "CalendarDayCell")
        calendarCollectionView.delegate = self
        calendarCollectionView.dataSource = self
        view.addSubview(calendarCollectionView)

        // Table View (Tasks for selected day)
        tasksTableView = UITableView()
        tasksTableView.backgroundColor = .clear
        tasksTableView.register(UITableViewCell.self, forCellReuseIdentifier: "TaskCell")
        tasksTableView.delegate = self
        tasksTableView.dataSource = self
        tasksTableView.separatorStyle = .none
        view.addSubview(tasksTableView)

        // Inline Composer View
        inlineComposerView.delegate = self
        view.addSubview(inlineComposerView)
    }

    private func setupConstraints() {
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        calendarCollectionView.translatesAutoresizingMaskIntoConstraints = false
        tasksTableView.translatesAutoresizingMaskIntoConstraints = false
        inlineComposerView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            monthLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            monthLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            calendarCollectionView.topAnchor.constraint(equalTo: monthLabel.bottomAnchor, constant: 16),
            calendarCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            calendarCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            calendarCollectionView.heightAnchor.constraint(equalToConstant: 280),

            tasksTableView.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor, constant: 12),
            tasksTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tasksTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tasksTableView.bottomAnchor.constraint(equalTo: inlineComposerView.topAnchor),

            inlineComposerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inlineComposerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inlineComposerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

    private func setupCollectionView() {
        if let flowLayout = calendarCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let itemSize = (view.frame.width - 40) / 7
            flowLayout.itemSize = CGSize(width: itemSize, height: itemSize)
        }
    }

    private func setupTableView() {
        tasksTableView.rowHeight = UITableViewAutomaticDimension
        tasksTableView.estimatedRowHeight = 60
    }

    @objc private func previousMonth() {
        calendarViewModel.previousMonth()
        updateCalendarDisplay()
    }

    @objc private func nextMonth() {
        calendarViewModel.nextMonth()
        updateCalendarDisplay()
    }

    @objc private func goToToday() {
        calendarViewModel.goToToday()
        updateCalendarDisplay()
    }

    private func updateCalendarDisplay() {
        monthLabel.text = calendarViewModel.getMonthYear(calendarViewModel.currentDate)
        calendarCollectionView.reloadData()
        tasksTableView.reloadData()
    }
}

// MARK: - UICollectionViewDelegate & DataSource
extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarViewModel.getDaysInMonth(calendarViewModel.currentDate).count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarDayCell", for: indexPath) as? CalendarDayCell else {
            return UICollectionViewCell()
        }

        let days = calendarViewModel.getDaysInMonth(calendarViewModel.currentDate)
        if let date = days[indexPath.item] {
            cell.configure(date: date, isSelected: calendarViewModel.isSameDay(date, calendarViewModel.selectedDate), hasTask: calendarViewModel.hasTasksOnDate(date), isToday: calendarViewModel.isToday(date))
        } else {
            cell.configureEmpty()
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let days = calendarViewModel.getDaysInMonth(calendarViewModel.currentDate)
        if let date = days[indexPath.item] {
            calendarViewModel.selectedDate = date
            collectionView.reloadData()
            tasksTableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate & DataSource
extension CalendarViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return calendarViewModel.todoTasksArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        let task = calendarViewModel.todoTasksArray[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.specifications
        cell.backgroundColor = UIColor(red: 0.92, green: 0.95, blue: 1.0, alpha: 1.0)
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        return cell
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let task = calendarViewModel.todoTasksArray[indexPath.row]

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
            guard let self else { return }
            self.calendarViewModel.deleteTodoTask(task)
            tableView.reloadData()
            completion(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - InlineTaskComposerViewDelegate
extension CalendarViewController: InlineTaskComposerViewDelegate {
    func didCreateTask(_ task: TodoTaskModel) {
        calendarViewModel.saveTask(task) { [weak self] success in
            guard let self else { return }
            if success {
                DispatchQueue.main.async {
                    self.tasksTableView.reloadData()
                    self.calendarCollectionView.reloadData()
                }
            }
        }
    }
}
