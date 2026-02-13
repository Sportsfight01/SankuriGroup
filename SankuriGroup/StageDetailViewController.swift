//
//  StageDetailViewController.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 24/11/25.
//

import UIKit

final class StageDetailViewController: UIViewController {
    
    // MARK: - Inputs
    private let estateId: Int
    private let stageId: Int

    // MARK: - Header
    private let headerView = UIView()
    private let backButton = UIButton(type: .system)
    private let logoImageView = UIImageView()

    // MARK: - Overview
    private let overviewLabel = UILabel()

    // MARK: - Progress Cards
    private var collectionView: UICollectionView!
    private let pageControl = UIPageControl()

    // MARK: - Timeline
    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Data
    private var phases: [StagePhase] = []
    private var selectedPhaseIndex: Int = 0

    // MARK: - Init
    init(estateId: Int, stageId: Int) {
        self.estateId = estateId
        self.stageId = stageId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "photo.on.rectangle"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private var stageGalleryURLs: [String] = []



    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupHeader()
        setupOverview()
        setupCollectionView()
        setupPageControl()
        setupTableView()
        fetchStageDetails()
        setupGalleryButton()

    }

    private func setupGalleryButton() {
        view.addSubview(galleryButton)

        galleryButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            galleryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            galleryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            galleryButton.widthAnchor.constraint(equalToConstant: 32),
            galleryButton.heightAnchor.constraint(equalToConstant: 32)
        ])

        galleryButton.addTarget(self, action: #selector(galleryTapped), for: .touchUpInside)
    }

    @objc private func galleryTapped() {
        fetchStageGalleryImages()
    }
    
    private func fetchStageGalleryImages() {

        EstateService.shared.getStageGalleryImages(
            estateId: estateId,
            stageId: stageId
        ) { [weak self] result in
            guard let self else { return }

            DispatchQueue.main.async {
                switch result {

                case .success(let images):
                    let items = images.map {
                        StageGalleryItem(
                            imageURL: $0.galleryURL,
                            date: $0.date,
                            description: $0.description
                        )
                    }

                    let vc = StageGalleryViewController()
                    vc.galleryItems = items
                    vc.stageId = self.stageId
                    self.navigationController?.pushViewController(vc, animated: true)


                case .failure(let error):
                    print("Stage Gallery API Error:", error)
                }
            }
        }
    }


    // MARK: - Header
    private func setupHeader() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerView)

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        logoImageView.image = UIImage(named: "suncity_logo")
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        headerView.addSubview(backButton)
        headerView.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),

            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Overview
    private func setupOverview() {
        
        overviewLabel.attributedText = AppStyle.headerTitle(
            firstPart: "Project",
            secondPart: "Overview"
        )
        overviewLabel.font = UIFont(name: "Montserrat-Bold", size: 24)
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(overviewLabel)

        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 16),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }

    // MARK: - CollectionView
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(
            width: view.bounds.width - 48,
            height: 260
        )

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = false   // ⚠️ IMPORTANT
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(
            ProgressCardCell.self,
            forCellWithReuseIdentifier: ProgressCardCell.identifier
        )

        collectionView.dataSource = self
        collectionView.delegate = self

        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 280)
        ])
    }

    // MARK: - Page Control
    private func setupPageControl() {
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .lightGray
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    // MARK: - TableView
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(
            TimelineCell.self,
            forCellReuseIdentifier: TimelineCell.identifier
        )

        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - API
    private func fetchStageDetails() {
        EstateService.shared.getStageDetails(
            estateId: estateId,
            stageId: stageId
        ) { [weak self] result in
            guard let self else { return }
            if case let .success(response) = result {
                DispatchQueue.main.async {
                    self.phases = response.phases
                    self.selectedPhaseIndex = 0
                    self.pageControl.numberOfPages = self.phases.count
                    self.collectionView.reloadData()
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Phase Calculation
    private func currentPhaseIndex() -> Int {
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return selectedPhaseIndex
        }

        let itemWidth = layout.itemSize.width + layout.minimumLineSpacing
        let rawIndex = collectionView.contentOffset.x / itemWidth
        let index = Int(round(rawIndex))

        return max(0, min(index, phases.count - 1))
    }

    private func applyPhaseChange() {
        let index = currentPhaseIndex()
        guard index != selectedPhaseIndex else { return }

        selectedPhaseIndex = index
        pageControl.currentPage = index
        tableView.setContentOffset(.zero, animated: false)
        tableView.reloadData()
    }
}

// MARK: - CollectionView
extension StageDetailViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return phases.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ProgressCardCell.identifier,
            for: indexPath
        ) as! ProgressCardCell

        let phase = phases[indexPath.item]
        let progress = phase.phaseWorkItems.isEmpty
            ? 0
            : CGFloat(phase.phaseWorkItems.filter { $0.isCompleted == true }.count)
              / CGFloat(phase.phaseWorkItems.count)

        cell.configure(
            leftTitle: "Start Date",
            leftValue: "January, 2026",
            stageNumber: "\(stageId)",
            phaseName: phase.name,
            progress: progress
        )

        return cell
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard scrollView == collectionView, !decelerate else { return }
        applyPhaseChange()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard scrollView == collectionView else { return }
        applyPhaseChange()
    }

    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        guard scrollView == collectionView,
              let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        else { return }

        let itemWidth = layout.itemSize.width + layout.minimumLineSpacing
        let index = round(targetContentOffset.pointee.x / itemWidth)
        targetContentOffset.pointee.x = index * itemWidth
    }
}

// MARK: - TableView
extension StageDetailViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phases[safe: selectedPhaseIndex]?.phaseWorkItems.count ?? 0
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: TimelineCell.identifier,
            for: indexPath
        ) as! TimelineCell

        let workItem = phases[selectedPhaseIndex].phaseWorkItems[indexPath.row]

        let item = TimelineItem(
            name: workItem.name,
            date: "",
            status: workItem.isCompleted == true ? .completed : .pending
        )

        cell.configure(with: item)
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
}

// MARK: - Safe Index
extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
