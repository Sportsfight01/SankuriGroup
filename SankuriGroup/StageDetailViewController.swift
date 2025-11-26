//
//  StageDetailViewController.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 24/11/25.
//

import UIKit

// Your app should already define:
// struct Stage { let id: Int; let name: String }

struct TimelineItem {
    let name: String
    let date: String
    let status: TimelineStatus
}

enum TimelineStatus {
    case completed
    case inProgress
    case pending
}

final class StageDetailViewController: UIViewController {

    // MARK: - Data

    private let stages: [Stage]
    private let currentStageId: Int

    private var currentIndex: Int {
        stages.firstIndex(where: { $0.id == currentStageId }) ?? 0
    }

    struct StageCardModel {
        let title: String        // Project Overview / Registration Overview
        let leftTitle: String    // Start Date / Registered
        let leftValue: String    // January, 2026
        let stageNumber: String
        let progress: CGFloat
    }

    private var cards: [StageCardModel] = []

    private var projectTimeline: [TimelineItem] = []
    private var registrationTimeline: [TimelineItem] = []
    private var currentPage: Int = 0

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
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // Card slider
    private var collectionView: UICollectionView!
    private let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.currentPage = 0
        pc.pageIndicatorTintColor = .lightGray
        pc.currentPageIndicatorTintColor = .black
        pc.translatesAutoresizingMaskIntoConstraints = false
        return pc
    }()

    // Timeline
    private let timelineTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Timeline"
        label.font = UIFont(name: "Montserrat-Bold", size: 20) ?? .boldSystemFont(ofSize: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let timelineTableView = UITableView()
    private var tableHeightConstraint: NSLayoutConstraint?

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

        view.backgroundColor = AppStyle.Colors.bodyBackground
        navigationController?.setNavigationBarHidden(true, animated: false)

        setupScrollView()
        setupHeader()
        applyProjectTitle()

        setupCards()
        setupCollectionView()
        setupTimelineTableView()
        setupTimelineData()
        
        timelineTableView.reloadData()

        // visual so card shadow not clipped
        collectionView.clipsToBounds = false
        collectionView.superview?.clipsToBounds = false
        scrollView.clipsToBounds = false
        contentView.clipsToBounds = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateTimelineForPage(currentPage)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateTimelineForPage(currentPage)
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

    private func applyProjectTitle() {
        
        titleLabel.attributedText = AppStyle.headerTitle(
            firstPart: "Project",
            secondPart: "Overview"
        )
    }

    private func setupCards() {
        let stageName = stages[currentIndex].name
        let numberPart = stageName.components(separatedBy: " ").last ?? "01"

        cards = [
            StageCardModel(
                title: "Project Overview",
                leftTitle: "Start Date",
                leftValue: "January, 2026",
                stageNumber: numberPart,
                progress: 0.33
            ),
            StageCardModel(
                title: "Registration Overview",
                leftTitle: "Start Date",
                leftValue: "April, 2026",
                stageNumber: numberPart,
                progress: 0.60
            )
        ]

        pageControl.numberOfPages = cards.count
        pageControl.currentPage = 0
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 24)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true

        collectionView.register(ProgressCardCell.self,
                                forCellWithReuseIdentifier: ProgressCardCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self

        contentView.addSubview(collectionView)
        contentView.addSubview(pageControl)

        pageControl.addTarget(self, action: #selector(pageControlChanged(_:)), for: .valueChanged)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 250),

            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    private func setupTimelineTableView() {
        timelineTableView.translatesAutoresizingMaskIntoConstraints = false
        timelineTableView.dataSource = self
        timelineTableView.delegate = self
        timelineTableView.separatorStyle = .none
        timelineTableView.backgroundColor = .clear
        timelineTableView.isScrollEnabled = false

        timelineTableView.register(TimelineCell.self,
                                   forCellReuseIdentifier: TimelineCell.identifier)

        contentView.addSubview(timelineTitleLabel)
        contentView.addSubview(timelineTableView)

        tableHeightConstraint = timelineTableView.heightAnchor.constraint(equalToConstant: 0)
        tableHeightConstraint?.isActive = true

        NSLayoutConstraint.activate([
            timelineTitleLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            timelineTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24),
            timelineTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24),

            timelineTableView.topAnchor.constraint(equalTo: timelineTitleLabel.bottomAnchor, constant: 12),
            timelineTableView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            timelineTableView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            timelineTableView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }

    private func setupTimelineData() {
        // Card 0 – Project Overview
        projectTimeline = [
            TimelineItem(name: "Foundation Work",   date: "10 Jan 2026", status: .completed),
            TimelineItem(name: "Column Setup",      date: "22 Jan 2026", status: .inProgress),
            TimelineItem(name: "Brick Work",        date: "15 Feb 2026", status: .pending),
            TimelineItem(name: "Foundation Work",   date: "10 Jan 2026", status: .completed),
            TimelineItem(name: "Column Setup",      date: "22 Jan 2026", status: .inProgress),
            TimelineItem(name: "Brick Work",        date: "15 Feb 2026", status: .pending)
        ]

        // Card 1 – Registration Overview
        registrationTimeline = [
            TimelineItem(name: "Submit Documents",  date: "02 Jan 2026", status: .completed),
            TimelineItem(name: "Verification",      date: "08 Jan 2026", status: .inProgress),
            TimelineItem(name: "Approval",          date: "20 Jan 2026", status: .pending),
            TimelineItem(name: "Submit Documents",  date: "02 Jan 2026", status: .completed),
            TimelineItem(name: "Verification",      date: "08 Jan 2026", status: .inProgress)
        ]

        updateTimelineForPage(0)
    }

    // MARK: - Timeline switching

    private func updateTimelineForPage(_ page: Int) {
        currentPage = max(0, min(page, cards.count - 1))

        timelineTableView.reloadData()

        DispatchQueue.main.async {
            self.timelineTableView.layoutIfNeeded()
            self.tableHeightConstraint?.constant = self.timelineTableView.contentSize.height
            self.view.layoutIfNeeded()
        }
    }



    // MARK: - Actions

    @objc private func didTapBack() {
        navigationController?.popViewController(animated: true)
    }

    @objc private func pageControlChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateTimelineForPage(page)
    }
}


// MARK: - CollectionView + Snapping

extension StageDetailViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cards.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize(width: collectionView.bounds.width - 48, height: 250)
        }

        let insets = layout.sectionInset.left + layout.sectionInset.right
        let spacing = layout.minimumLineSpacing
        let width = collectionView.bounds.width - insets - spacing

        return CGSize(width: width, height: 250)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProgressCardCell.identifier,
            for: indexPath
        ) as? ProgressCardCell else {
            return UICollectionViewCell()
        }

        let model = cards[indexPath.item]
        cell.configure(leftTitle: model.leftTitle,
                       leftValue: model.leftValue,
                       stageNumber: model.stageNumber,
                       progress: model.progress)
        return cell
    }

    // Snapping only for the card collection view

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView === collectionView else { return }
        updatePageFromCollection()
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView === collectionView else { return }
        updatePageFromCollection()
    }

    private func updatePageFromCollection() {
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let indexPath = collectionView.indexPathForItem(at: visiblePoint) {
            pageControl.currentPage = indexPath.item
            updateTimelineForPage(indexPath.item)
        }
    }
}

// MARK: - CircularProgressView

final class CircularProgressView: UIView {

    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()

    private let percentageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 28) ?? .boldSystemFont(ofSize: 28)
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

        trackLayer.strokeColor = UIColor.black.cgColor
        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.lineWidth = 12
        trackLayer.lineCap = .round
        layer.addSublayer(trackLayer)

        progressLayer.strokeColor = AppStyle.Colors.yellow.cgColor
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

        let path = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )

        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        trackLayer.frame = bounds
        progressLayer.frame = bounds
    }
}

// MARK: - UITableViewDataSource / Delegate

extension StageDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentPage == 0 ? projectTimeline.count : registrationTimeline.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TimelineCell.identifier,
            for: indexPath
        ) as? TimelineCell else {
            return UITableViewCell()
        }

        let item = currentPage == 0
            ? projectTimeline[indexPath.row]
            : registrationTimeline[indexPath.row]

        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        100
    }
}
