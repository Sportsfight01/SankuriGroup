//
//  ProgressCardCell.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 26/11/25.
//

import UIKit

final class ProgressCardCell: UICollectionViewCell {

    static let identifier = "ProgressCardCell"

    private let leftStack = UIStackView()
    private let rightStack = UIStackView()

    private let leftTitleLabel = UILabel()
    private let leftValueLabel = UILabel()

    private let rightTitleLabel = UILabel()
    private let rightValueLabel = UILabel()
    
    private let phaseLabel = UILabel()


    private let circle = CircularProgressView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true

        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 10
        layer.masksToBounds = false

        // Left labels
        leftTitleLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        leftTitleLabel.textColor = .darkGray

        leftValueLabel.font = UIFont(name: "Montserrat-SemiBold", size: 18)
        leftValueLabel.textColor = .black

        leftStack.axis = .vertical
        leftStack.alignment = .leading
        leftStack.spacing = 4
        leftStack.translatesAutoresizingMaskIntoConstraints = false
        leftStack.addArrangedSubview(leftTitleLabel)
        leftStack.addArrangedSubview(leftValueLabel)

        // Right labels: "Stage" + number
        rightTitleLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        rightTitleLabel.text = "Stage"
        rightTitleLabel.textColor = .darkGray
        rightTitleLabel.textAlignment = .right

        rightValueLabel.font = UIFont(name: "Montserrat-Bold", size: 18)
        rightValueLabel.textColor = .black
        rightValueLabel.textAlignment = .right

        rightStack.axis = .vertical
        rightStack.alignment = .trailing
        rightStack.spacing = 4
        rightStack.translatesAutoresizingMaskIntoConstraints = false
        rightStack.addArrangedSubview(rightTitleLabel)
        rightStack.addArrangedSubview(rightValueLabel)

        circle.translatesAutoresizingMaskIntoConstraints = false
        
        phaseLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        phaseLabel.textColor = .black
        phaseLabel.textAlignment = .center
        phaseLabel.translatesAutoresizingMaskIntoConstraints = false


        contentView.addSubview(leftStack)
        contentView.addSubview(rightStack)
        contentView.addSubview(circle)
        contentView.addSubview(phaseLabel)

        NSLayoutConstraint.activate([
            leftStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            leftStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            rightStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            rightStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            circle.topAnchor.constraint(equalTo: leftStack.bottomAnchor, constant: 24),
            circle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            circle.widthAnchor.constraint(equalToConstant: 160),
            circle.heightAnchor.constraint(equalToConstant: 160),
        ])
        
        NSLayoutConstraint.activate([
            phaseLabel.topAnchor.constraint(equalTo: circle.bottomAnchor, constant: 12),
            phaseLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            phaseLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

    }

    func configure(
        leftTitle: String,
        leftValue: String,
        stageNumber: String,
        phaseName: String,
        progress: CGFloat
    ) {
        leftTitleLabel.text = leftTitle
        leftValueLabel.text = leftValue
        rightValueLabel.text = stageNumber
        phaseLabel.text = phaseName
        circle.progress = progress
    }

}
