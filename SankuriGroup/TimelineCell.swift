//
//  TimelineCell.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 26/11/25.
//

import UIKit

final class TimelineCell: UITableViewCell {

    static let identifier = "TimelineCell"

    private let containerView = UIView()
    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    private let statusImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        containerView.layer.cornerRadius = 16
        containerView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        dateLabel.font = UIFont(name: "Montserrat-Regular", size: 13)
        dateLabel.textColor = .darkGray

        statusImageView.translatesAutoresizingMaskIntoConstraints = false

        let stack = UIStackView(arrangedSubviews: [titleLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stack)
        containerView.addSubview(statusImageView)
        contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            statusImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            statusImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 28),
            statusImageView.heightAnchor.constraint(equalToConstant: 28),

            stack.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stack.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }

    func configure(with item: TimelineItem) {
        titleLabel.text = item.name
        dateLabel.text = item.date

        switch item.status {
        case .completed:
            containerView.backgroundColor = AppStyle.Colors.yellow
            statusImageView.image = UIImage(systemName: "checkmark.circle.fill")
            statusImageView.tintColor = .systemBlue
        case .pending:
            containerView.backgroundColor = .black
            statusImageView.image = UIImage(systemName: "ellipsis.circle")
            statusImageView.tintColor = .systemBlue
        }
    }
}
