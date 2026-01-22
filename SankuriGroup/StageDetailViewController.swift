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

    // MARK: - UI
    private let tableView = UITableView(frame: .zero, style: .grouped)

    // Header (Progress)
    private let civilProgressView = CircularProgressView()
    private let registrationProgressView = CircularProgressView()

    // MARK: - Data
    private var civilItems: [TimelineItem] = []
    private var registrationItems: [TimelineItem] = []

    // MARK: - Init
    init(estateId: Int, stageId: Int) {
        self.estateId = estateId
        self.stageId = stageId
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupTableView()
        fetchStageDetails()
    }

    // MARK: - Setup
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
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
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
        ) { [weak self] (result: Result<StageDetailResponse, Error>) in
            guard let self = self else { return }

            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.mapResponse(response)
                }
            case .failure(let error):
                print("Stage details error:", error)
            }
        }
    }

    // MARK: - Mapping
    private func mapResponse(_ response: StageDetailResponse) {
        civilItems.removeAll()
        registrationItems.removeAll()

        for phase in response.phases {

            let items: [TimelineItem] = phase.phaseWorkItems.map { work in
                let status: TimelineStatus =
                    work.isCompleted == true ? .completed : .pending

                return TimelineItem(
                    name: work.name,
                    date: "",
                    status: status
                )
            }

            if phase.name.lowercased().contains("civil") {
                civilItems = items

                let progress = calculateProgress(items: phase.phaseWorkItems)
                civilProgressView.setProgress(progress)

            } else if phase.name.lowercased().contains("registration") {
                registrationItems = items

                let progress = calculateProgress(items: phase.phaseWorkItems)
                registrationProgressView.setProgress(progress)
            }
        }

        tableView.reloadData()
    }

    // MARK: - Progress Calculation
    private func calculateProgress(items: [PhaseWorkItem]) -> CGFloat {
        guard !items.isEmpty else { return 0 }
        let completed = items.filter { $0.isCompleted == true }.count
        return CGFloat(completed) / CGFloat(items.count)
    }
}

// MARK: - UITableViewDataSource
extension StageDetailViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Civil + Registration
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? civilItems.count : registrationItems.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: TimelineCell.identifier,
            for: indexPath
        ) as! TimelineCell

        let item = indexPath.section == 0
            ? civilItems[indexPath.row]
            : registrationItems[indexPath.row]

        cell.configure(with: item)
        return cell
    }
}

// MARK: - UITableViewDelegate
extension StageDetailViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        viewForHeaderInSection section: Int
    ) -> UIView? {

        let container = UIView()
        container.backgroundColor = .clear

        let titleLabel = UILabel()
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textColor = .label
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        let progressView = section == 0 ? civilProgressView : registrationProgressView
        progressView.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.text = section == 0 ? "Civil Phase" : "Registration Phase"

        container.addSubview(titleLabel)
        container.addSubview(progressView)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),

            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            progressView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            progressView.widthAnchor.constraint(equalToConstant: 120),
            progressView.heightAnchor.constraint(equalToConstant: 120),
            progressView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12)
        ])

        return container
    }

    func tableView(
        _ tableView: UITableView,
        heightForHeaderInSection section: Int
    ) -> CGFloat {
        return 180
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 80
    }
}
