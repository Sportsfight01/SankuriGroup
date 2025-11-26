//
//  TimelineCell.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 26/11/25.
//

import UIKit

class TimelineCell: UITableViewCell {

    static let identifier = "TimelineCell"

    let bgView = UIView()
    let titleLabel = UILabel()
    let dateLabel = UILabel()
    let statusImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none

        bgView.layer.cornerRadius = 16
        bgView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = UIFont(name: "Montserrat-SemiBold", size: 20)
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        dateLabel.font = UIFont(name: "Montserrat-Regular", size: 16)
        dateLabel.textColor = .darkGray
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.contentMode = .scaleAspectFit

        contentView.addSubview(bgView)
        bgView.addSubview(titleLabel)
        bgView.addSubview(dateLabel)
        bgView.addSubview(statusImageView)

        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            // ICON on the LEFT MIDDLE
            statusImageView.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            statusImageView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 20),
            statusImageView.widthAnchor.constraint(equalToConstant: 28),
            statusImageView.heightAnchor.constraint(equalToConstant: 28),

            // TITLE to the right of the icon
            titleLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -20),

            // DATE under title
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -20),
            dateLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -16)
        ])

    }

    func configure(with item: TimelineItem) {
        titleLabel.text = item.name
        dateLabel.text  = item.date

        // Colours by status
        switch item.status {
        case .completed:
            bgView.backgroundColor = UIColor.systemYellow
            titleLabel.textColor = .black
            dateLabel.textColor = .black
            statusImageView.image = UIImage(named: "status_completed")

        case .inProgress:
            bgView.backgroundColor = .black
            titleLabel.textColor = .white
            dateLabel.textColor = .white
            statusImageView.image = UIImage(named: "status_inprogress")


        case .pending:
            bgView.backgroundColor = .white
            titleLabel.textColor = .black
            dateLabel.textColor = .darkGray
            statusImageView.image = UIImage(named: "status_pending")

        }
    }
}
