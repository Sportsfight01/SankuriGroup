//
//  SuncityViewController.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 21/11/25.
//

import UIKit

struct Stage {
    let id: Int
    let name: String
    let color: UIColor
}

class SuncityViewController: UIViewController {

    // MARK: - Public
    var estateId: Int?
    private let sideMenu = SideMenuView()


    // MARK: - Data
    private var stages: [Stage] = []

    // MARK: - Scroll
    private let scrollView = UIScrollView()
    private let contentView = UIView()

    // MARK: - Header
    private let menuButton = UIButton(type: .system)
    private let homeButton = UIButton(type: .system)
    private let logoImageView = UIImageView(image: UIImage(named: "Suncity_Logo"))

    private var estateName: String = ""

    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()

    // MARK: - Slider
    private let sliderScrollView = UIScrollView()
    private let pageControl = UIPageControl()

    // MARK: - Phase bar
    private let progressStackView = UIStackView()

    // MARK: - Stages
    private let stagesTitleLabel: UILabel = {
        let lbl = UILabel()
        lbl.text = "Stages"
        lbl.font = UIFont(name: "Montserrat-Bold", size: 20)
        return lbl
    }()

    private let stageGridStack = UIStackView()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.bodyBackground
        navigationController?.setNavigationBarHidden(true, animated: false)
        sideMenu.delegate = self
        
        setupScroll()
        setupUI()
        setupSlider()
        setupPhaseBar()

        guard let estateId else { return }
        fetchEstateDetails(id: estateId)
        menuButton.addTarget(self, action: #selector(menuTapped), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(homeTapped), for: .touchUpInside)
    }

    @objc private func menuTapped() {
        print("Menu tapped")
        sideMenu.show(in: view)

    }

    @objc private func homeTapped() {
        print("Home tapped")

        navigationController?.popToRootViewController(animated: true)
    }

    // MARK: - Scroll Setup
    private func setupScroll() {
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

    // MARK: - API
    private func fetchEstateDetails(id: Int) {
        EstateService.shared.getEstateById(estateId: id) { [weak self] result in
            guard let self else { return }

            switch result {
            case .success(let response):

                // ✅ Save estate name
                self.estateName = response.name ?? ""

                // ✅ Update welcome label
                self.updateWelcomeTitle()

                // Existing stage logic
                self.stages = response.estateStages.map {
                    Stage(
                        id: $0.stageId,
                        name: "STAGE \($0.stageId)",
                        color: AppStyle.Colors.yellow
                    )
                }

                self.buildStageGrid()

            case .failure(let error):
                print(error)
            }
        }
    }


    // MARK: - UI Setup
    private func setupUI() {

        [menuButton, homeButton, logoImageView,
         titleLabel, sliderScrollView, pageControl,
         progressStackView, stagesTitleLabel, stageGridStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        menuButton.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        homeButton.setImage(UIImage(systemName: "house.fill"), for: .normal)
        
        menuButton.tintColor = .black
        homeButton.tintColor = .black

//        titleLabel.attributedText = AppStyle.headerTitle(
//            firstPart: "Welcome To",
//            secondPart: "Suncity"
//        )

        progressStackView.axis = .horizontal
        progressStackView.distribution = .fillEqually
        progressStackView.spacing = 8

        stageGridStack.axis = .vertical
        stageGridStack.spacing = 12

        NSLayoutConstraint.activate([
            menuButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            menuButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            homeButton.centerYAnchor.constraint(equalTo: menuButton.centerYAnchor),
            homeButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: menuButton.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 28),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            sliderScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            sliderScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            sliderScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            sliderScrollView.heightAnchor.constraint(equalToConstant: 180),

            pageControl.topAnchor.constraint(equalTo: sliderScrollView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            progressStackView.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            progressStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            progressStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            progressStackView.heightAnchor.constraint(equalToConstant: 36),

            stagesTitleLabel.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 30),
            stagesTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),

            stageGridStack.topAnchor.constraint(equalTo: stagesTitleLabel.bottomAnchor, constant: 20),
            stageGridStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stageGridStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            stageGridStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func updateWelcomeTitle() {
        titleLabel.attributedText = AppStyle.headerTitle(
            firstPart: "Welcome To",
            secondPart: estateName.capitalized
        )
        
        sideMenu.titleText = estateName.capitalized

    }


    // MARK: - Phase Bar
    private func setupPhaseBar() {
        ["Discovery", "Planning", "Execution", "Result"].forEach {
            let lbl = UILabel()
            lbl.text = $0
            lbl.textAlignment = .center
            lbl.font = UIFont(name: "Montserrat-Bold", size: 13)
            lbl.backgroundColor = $0 == "Planning" ? AppStyle.Colors.yellow : AppStyle.Colors.grey
            lbl.layer.cornerRadius = 6
            lbl.clipsToBounds = true
            progressStackView.addArrangedSubview(lbl)
        }
    }

    // MARK: - Slider
    private func setupSlider() {
        sliderScrollView.isPagingEnabled = true
        sliderScrollView.showsHorizontalScrollIndicator = false

        let images = (1...5).compactMap { _ in UIImage(named: "site_image") }
        sliderScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(images.count), height: 180)
        pageControl.numberOfPages = images.count

        for (i, img) in images.enumerated() {
            let iv = UIImageView(image: img)
            iv.frame = CGRect(x: CGFloat(i) * view.frame.width, y: 0,
                              width: view.frame.width, height: 180)
            iv.layer.cornerRadius = 12
            iv.clipsToBounds = true
            iv.contentMode = .scaleAspectFill
            sliderScrollView.addSubview(iv)
        }
    }

    // MARK: - Stage Grid
    private func buildStageGrid() {
        stageGridStack.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let columns = 3
        var row: UIStackView?

        for (index, stage) in stages.enumerated() {
            if index % columns == 0 {
                row = UIStackView()
                row?.axis = .horizontal
                row?.spacing = 12
                row?.distribution = .fillEqually
                stageGridStack.addArrangedSubview(row!)
            }
            row?.addArrangedSubview(stageCard(stage))

            if index == stages.count - 1 {
                let remaining = columns - ((index % columns) + 1)
                for _ in 0..<remaining {
                    row?.addArrangedSubview(UIView())
                }
            }
        }
    }

    private func stageCard(_ stage: Stage) -> UIView {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = stage.color
        v.layer.cornerRadius = 14

        v.tag = stage.id          // ✅ StageId (156, 155, etc)
        v.isUserInteractionEnabled = true

        let label = UILabel()
        label.text = stage.name
        label.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        v.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: v.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: v.centerYAnchor),
            v.heightAnchor.constraint(equalToConstant: 90)
        ])

        v.addGestureRecognizer(
            UITapGestureRecognizer(
                target: self,
                action: #selector(stageTapped(_:))
            )
        )

        return v
    }



    @objc private func stageTapped(_ g: UITapGestureRecognizer) {
        guard let stageId = g.view?.tag else { return }
        guard let estateId = estateId else { return }

        let vc = StageDetailViewController(
            estateId: estateId,
            stageId: stageId
        )
        navigationController?.pushViewController(vc, animated: true)
    }

    
}


extension SuncityViewController: SideMenuDelegate {

    func didSelectMenuItem(_ item: SideMenuView.MenuItem) {
        switch item {

        case .home:
            navigationController?.popToRootViewController(animated: true)

        case .enquiry:
            let vc = EnquiryViewController()
            navigationController?.pushViewController(vc, animated: true)

        case .logout:
            print("Logout tapped")
            // Clear user session here
        }
    }
}

