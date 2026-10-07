import UIKit

final class CalendarDayCell: UICollectionViewCell {
    private let dayLabel = UILabel()
    private let taskIndicator = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true

        dayLabel.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        dayLabel.textAlignment = .center
        dayLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        contentView.addSubview(dayLabel)

        taskIndicator.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 0.6)
        taskIndicator.layer.cornerRadius = 4
        taskIndicator.isHidden = true
        contentView.addSubview(taskIndicator)

        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        taskIndicator.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            dayLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

            taskIndicator.widthAnchor.constraint(equalToConstant: 8),
            taskIndicator.heightAnchor.constraint(equalToConstant: 8),
            taskIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            taskIndicator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
    }

    func configure(date: Date, isSelected: Bool, hasTask: Bool, isToday: Bool) {
        let day = Calendar.current.component(.day, from: date)
        dayLabel.text = "\(day)"

        if isSelected {
            contentView.backgroundColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
            dayLabel.textColor = .white
        } else if isToday {
            contentView.backgroundColor = UIColor(red: 0.85, green: 0.92, blue: 1.0, alpha: 1.0)
            dayLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        } else {
            contentView.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1.0, alpha: 1.0)
            dayLabel.textColor = UIColor(red: 0.2, green: 0.4, blue: 0.8, alpha: 1.0)
        }

        taskIndicator.isHidden = !hasTask
    }

    func configureEmpty() {
        dayLabel.text = ""
        contentView.backgroundColor = .clear
        taskIndicator.isHidden = true
    }
}
