//
//  StageDetailViewController.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 24/11/25.
//

import UIKit

final class StageDetailViewController: UIViewController {

    // MARK: - Data
    private let stages: [Stage]
    private let currentStageId: Int

    private var currentIndex: Int {
        stages.firstIndex(where: { $0.id == currentStageId }) ?? 0
    }

    // MARK: - UI
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let logoImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Suncity_Logo"))
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()

    private let progressCard = UIView()
    private let startDateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Start Date"
        label.font = UIFont(name: "Montserrat-Regular", size: 12)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let startDateValueLabel: UILabel = {
        let label = UILabel()
        label.text = "January, 2026"        // replace with real date if you have it
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let circularProgress = CircularProgressView()

    private let timelineTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Timeline"
        label.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stageNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()



    private let timelineStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Init
    init(stages: [Stage], currentStageId: Int) {
        self.stages = stages
        self.currentStageId = currentStageId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.96, alpha: 1)
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupScrollView()
        setupHeader()
        setupProgressCard()
        setupTimeline()
        applyProjectTitle()
        applyProgress()
    }

    // MARK: - Setup
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    private func setupHeader() {
        contentView.addSubview(backButton)
        contentView.addSubview(logoImageView)
        contentView.addSubview(titleLabel)

        backButton.addTarget(self, action: #selector(didTapBack), for: .touchUpInside)

        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            backButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            backButton.widthAnchor.constraint(equalToConstant: 32),
            backButton.heightAnchor.constraint(equalToConstant: 32),

            logoImageView.centerYAnchor.constraint(equalTo: backButton.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24)
        ])
    }

    private func setupProgressCard() {
        progressCard.translatesAutoresizingMaskIntoConstraints = false
        progressCard.backgroundColor = .white
        progressCard.layer.cornerRadius = 16
        progressCard.layer.shadowColor = UIColor.black.cgColor
        progressCard.layer.shadowOpacity = 0.08
        progressCard.layer.shadowOffset = CGSize(width: 0, height: 4)
        progressCard.layer.shadowRadius = 10

        contentView.addSubview(progressCard)
        progressCard.addSubview(startDateTitleLabel)
        progressCard.addSubview(startDateValueLabel)
        progressCard.addSubview(stageNameLabel)


        circularProgress.translatesAutoresizingMaskIntoConstraints = false
        progressCard.addSubview(circularProgress)

        NSLayoutConstraint.activate([
            progressCard.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            progressCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            progressCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            progressCard.heightAnchor.constraint(equalToConstant: 260),

            startDateTitleLabel.topAnchor.constraint(equalTo: progressCard.topAnchor, constant: 16),
            startDateTitleLabel.leadingAnchor.constraint(equalTo: progressCard.leadingAnchor, constant: 16),

            startDateValueLabel.topAnchor.constraint(equalTo: startDateTitleLabel.bottomAnchor, constant: 4),
            startDateValueLabel.leadingAnchor.constraint(equalTo: startDateTitleLabel.leadingAnchor),

            circularProgress.centerXAnchor.constraint(equalTo: progressCard.centerXAnchor),
            circularProgress.centerYAnchor.constraint(equalTo: progressCard.centerYAnchor, constant: 20),
            circularProgress.widthAnchor.constraint(equalToConstant: 160),
            circularProgress.heightAnchor.constraint(equalToConstant: 160),
            
            stageNameLabel.topAnchor.constraint(equalTo: progressCard.topAnchor, constant: 16),
                stageNameLabel.trailingAnchor.constraint(equalTo: progressCard.trailingAnchor, constant: -16)
        ])
    }

    private func setupTimeline() {
        contentView.addSubview(timelineTitleLabel)
        contentView.addSubview(timelineStackView)

        NSLayoutConstraint.activate([
            timelineTitleLabel.topAnchor.constraint(equalTo: progressCard.bottomAnchor, constant: 30),
            timelineTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            timelineTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            timelineStackView.topAnchor.constraint(equalTo: timelineTitleLabel.bottomAnchor, constant: 12),
            timelineStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            timelineStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),
            timelineStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])

        buildTimelineCards()
    }

    private func applyProjectTitle() {
        let full = "Project Overview"
        let attributed = NSMutableAttributedString(string: full)

        // "Project" in black
        if let rangeProject = full.range(of: "Project") {
            let nsRange = NSRange(rangeProject, in: full)
            attributed.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
        }

        // "Overview" in yellow
        if let rangeOverview = full.range(of: "Overview") {
            let nsRange = NSRange(rangeOverview, in: full)
            let yellow = UIColor(red: 0.95, green: 0.8, blue: 0.2, alpha: 1)
            attributed.addAttribute(.foregroundColor, value: yellow, range: nsRange)
        }

        // Font
        attributed.addAttribute(
            .font,
            value: UIFont(name: "Montserrat-Bold", size: 22)!,
            range: NSRange(location: 0, length: full.count)
        )

        titleLabel.attributedText = attributed
    }

    private func applyProgress() {
        let total = max(stages.count, 1)
        let value = CGFloat(currentIndex + 1) / CGFloat(total)
        circularProgress.progress = value

        // Extract stage number from name: "STAGE 02" → "02"
        let rawName = stages[currentIndex].name
        let numberPart = rawName.components(separatedBy: " ").last ?? ""

        // Build two-line text: "Stage\n02"
        let fullText = "Stage\n\(numberPart)"
        let attributed = NSMutableAttributedString(string: fullText)

        // Line 1: "Stage" (small, grey)
        let topRange = (fullText as NSString).range(of: "Stage")
        attributed.addAttribute(.font, value: UIFont(name: "Montserrat-Regular", size: 12)!, range: topRange)
        attributed.addAttribute(.foregroundColor, value: UIColor.darkGray, range: topRange)

        // Line 2: number (bold, black)
        let numRange = (fullText as NSString).range(of: numberPart)
        attributed.addAttribute(.font, value: UIFont(name: "Montserrat-Bold", size: 16)!, range: numRange)
        attributed.addAttribute(.foregroundColor, value: UIColor.black, range: numRange)

        stageNameLabel.attributedText = attributed
    }


    // MARK: - Timeline building
    private func buildTimelineCards() {
        timelineStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let highlightColor = UIColor(red: 0.95, green: 0.8, blue: 0.2, alpha: 1)

        for (index, stage) in stages.enumerated() {
            let card = UIView()
            card.layer.cornerRadius = 14
            card.translatesAutoresizingMaskIntoConstraints = false
            card.heightAnchor.constraint(equalToConstant: 70).isActive = true

            let isDone = index < currentIndex
            let isCurrent = index == currentIndex

            if isCurrent {
                card.backgroundColor = .black
            } else if isDone {
                card.backgroundColor = highlightColor
            } else {
                card.backgroundColor = .white
                card.layer.borderWidth = 0.5
                card.layer.borderColor = UIColor.lightGray.cgColor
            }

            let circle = UIView()
            circle.translatesAutoresizingMaskIntoConstraints = false
            circle.layer.cornerRadius = 10
            circle.layer.borderWidth = 2
            circle.layer.borderColor = UIColor.black.cgColor
            circle.backgroundColor = isDone || isCurrent ? .black : .clear

            let stepLabel = UILabel()
            stepLabel.translatesAutoresizingMaskIntoConstraints = false
            stepLabel.text = "STEP \(index + 1)"
            stepLabel.font = UIFont(name: "Montserrat-Medium", size: 11)
            stepLabel.textColor = isDone || isCurrent ? .white : .darkGray

            let nameLabel = UILabel()
            nameLabel.translatesAutoresizingMaskIntoConstraints = false
            nameLabel.text = stage.name.replacingOccurrences(of: "_", with: " ")
            nameLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
            nameLabel.textColor = isDone || isCurrent ? .white : .black

            card.addSubview(circle)
            card.addSubview(stepLabel)
            card.addSubview(nameLabel)

            NSLayoutConstraint.activate([
                circle.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
                circle.centerYAnchor.constraint(equalTo: card.centerYAnchor),
                circle.widthAnchor.constraint(equalToConstant: 20),
                circle.heightAnchor.constraint(equalToConstant: 20),

                stepLabel.leadingAnchor.constraint(equalTo: circle.trailingAnchor, constant: 12),
                stepLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 14),

                nameLabel.leadingAnchor.constraint(equalTo: stepLabel.leadingAnchor),
                nameLabel.topAnchor.constraint(equalTo: stepLabel.bottomAnchor, constant: 4),
                nameLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16)
            ])

            timelineStackView.addArrangedSubview(card)
        }
    }

    // MARK: - Actions
    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }
}

final class CircularProgressView: UIView {

    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 28)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var progress: CGFloat = 0 {
        didSet {
            progressLayer.strokeEnd = max(0, min(progress, 1))
            let percent = Int(progress * 100)
            percentageLabel.text = "\(percent)%"
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = .clear

        trackLayer.strokeColor =  UIColor.black.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 12
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        progressLayer.strokeColor = UIColor(red: 0.95, green: 0.8, blue: 0.2, alpha: 1).cgColor
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineWidth = 12
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
        layer.addSublayer(progressLayer)

        addSubview(percentageLabel)
        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = min(bounds.width, bounds.height) / 2 - 15
        let startAngle = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi

        let path = UIBezierPath(arcCenter: centerPoint,
                                radius: radius,
                                startAngle: startAngle,
                                endAngle: endAngle,
                                clockwise: true)

        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        trackLayer.frame = bounds
        progressLayer.frame = bounds
    }
}
