import Foundation
import RealmSwift

final class CalendarViewModel {
    private let realmManager: RealmManager
    var todoTasksArray: [TodoTaskModel] = []
    var currentDate: Date = Date()
    var selectedDate: Date = Date() {
        didSet {
            updateTasksForSelectedDate()
        }
    }

    init(realmManager: RealmManager = RealmManager()) {
        self.realmManager = realmManager
        updateTasksForSelectedDate()
    }

    // MARK: - Date Functions
    func getDaysInMonth(_ date: Date) -> [Date?] {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let firstDay = calendar.date(from: components)!
        let range = calendar.range(of: .day, in: .month, for: firstDay)!
        let numDays = range.count

        let firstWeekday = calendar.component(.weekday, from: firstDay) - 1
        var days: [Date?] = Array(repeating: nil, count: firstWeekday)

        for i in 0..<numDays {
            let day = calendar.date(byAdding: .day, value: i, to: firstDay)!
            days.append(day)
        }

        return days
    }

    func getMonthYear(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }

    func getWeekdaySymbols() -> [String] {
        return Calendar.current.shortWeekdaySymbols
    }

    // MARK: - Navigation
    func nextMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) ?? currentDate
    }

    func previousMonth() {
        currentDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) ?? currentDate
    }

    func goToToday() {
        currentDate = Date()
        selectedDate = Date()
    }

    // MARK: - Task Management
    func updateTasksForSelectedDate() {
        let allTasks = realmManager.getTodoTasks()
        let calendar = Calendar.current
        let selectedComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)

        todoTasksArray = allTasks.filter { task in
            let taskComponents = calendar.dateComponents([.year, .month, .day], from: task.date)
            return selectedComponents == taskComponents
        }.sorted { $0.date < $1.date }
    }

    func saveTask(_ task: TodoTaskModel, completion: @escaping (Bool) -> Void) {
        realmManager.saveTask(task) { [weak self] success in
            if success {
                self?.updateTasksForSelectedDate()
            }
            completion(success)
        }
    }

    func deleteTodoTask(_ task: TodoTaskModel) {
        realmManager.deleteTodoTask(task)
        updateTasksForSelectedDate()
    }

    func updateTodo(_ task: TodoTaskModel, newName: String? = nil, newSpecifications: String? = nil, newDate: Date? = nil) {
        realmManager.updateTask(task, newName: newName, newSpecifications: newSpecifications, newDate: newDate)
        updateTasksForSelectedDate()
    }

    func isToday(_ date: Date) -> Bool {
        Calendar.current.isDateInToday(date)
    }

    func isSameDay(_ date1: Date, _ date2: Date) -> Bool {
        Calendar.current.isDate(date1, inSameDayAs: date2)
    }

    func hasTasksOnDate(_ date: Date) -> Bool {
        let allTasks = realmManager.getTodoTasks()
        return allTasks.contains { isSameDay($0.date, date) }
    }
}
