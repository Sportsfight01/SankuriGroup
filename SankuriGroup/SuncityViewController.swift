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

    private var stages: [Stage] = []
    private var planningColor: UIColor = .systemYellow
    private var selectedStageIndex: Int? = nil
    private var sideMenuView: UIView!
    private var sideMenuVisible = false
    private var dimmedView: UIView!
    private var sliderTimer: Timer?
    private var currentSlideIndex = 0



    // MARK: - Header UI
    private let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let homeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "house.fill"), for: .normal)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "Suncity_Logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome To Suncity"
        label.font = UIFont(name: "Montserrat-Bold", size: 22)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    private let siteImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "site_image"))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let sliderScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    private let sliderPageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 5
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()


    private let progressStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    private let stagesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Stages"
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let stageStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(white: 0.96, alpha: 1)
        navigationItem.hidesBackButton = true
        setupUI()
        setupImageSlider()
        startAutoSlider()
        setupMenu()
        loadDataFromService()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }


    // MARK: - UI Setup
    private func setupUI() {
        
        view.addSubview(menuButton)
        view.addSubview(homeButton)
        view.addSubview(logoImageView)
        view.addSubview(titleLabel)
        view.addSubview(sliderScrollView)
        view.addSubview(sliderPageControl)
        view.addSubview(progressStackView)
        view.addSubview(stagesTitleLabel)
        view.addSubview(stageStackView)
        
        menuButton.addTarget(self, action: #selector(toggleSideMenu), for: .touchUpInside)
        homeButton.addTarget(self, action: #selector(goHome), for: .touchUpInside)
        
        let fullText = "Welcome To Suncity"
        let attributed = NSMutableAttributedString(string: fullText)

        // Range for "Welcome To"
        if let rangeWelcome = fullText.range(of: "Welcome To") {
            let nsRange = NSRange(rangeWelcome, in: fullText)
            attributed.addAttribute(.foregroundColor, value: UIColor.black, range: nsRange)
        }

        // Range for "Suncity"
        if let rangeSuncity = fullText.range(of: "Suncity") {
            let nsRange = NSRange(rangeSuncity, in: fullText)
            attributed.addAttribute(.foregroundColor, value: UIColor.systemYellow, range: nsRange)
        }

        titleLabel.attributedText = attributed
        
        NSLayoutConstraint.activate([
            // Header icons
            menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            menuButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            menuButton.widthAnchor.constraint(equalToConstant: 30),
            menuButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Home Button
            homeButton.centerYAnchor.constraint(equalTo: menuButton.centerYAnchor),
            homeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            homeButton.widthAnchor.constraint(equalToConstant: 30),
            homeButton.heightAnchor.constraint(equalToConstant: 30),
            
            // Logo placed BETWEEN menu & home
            logoImageView.centerYAnchor.constraint(equalTo: menuButton.centerYAnchor),
            logoImageView.leadingAnchor.constraint(greaterThanOrEqualTo: menuButton.trailingAnchor, constant: 20),
            logoImageView.trailingAnchor.constraint(lessThanOrEqualTo: homeButton.leadingAnchor, constant: -20),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            
            // Title
            titleLabel.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Site Image
            // Slider ScrollView
            sliderScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            sliderScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            sliderScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            sliderScrollView.heightAnchor.constraint(equalToConstant: 180),

            // Page Control
            sliderPageControl.topAnchor.constraint(equalTo: sliderScrollView.bottomAnchor, constant: 6),
            sliderPageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            
            // Progress Bar
            progressStackView.topAnchor.constraint(equalTo: sliderPageControl.bottomAnchor, constant: 40),
            progressStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            progressStackView.heightAnchor.constraint(equalToConstant: 38),
            
            // Stages Title
            stagesTitleLabel.topAnchor.constraint(equalTo: progressStackView.bottomAnchor, constant: 40),
            stagesTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // Stage Grid
            stageStackView.topAnchor.constraint(equalTo: stagesTitleLabel.bottomAnchor, constant: 14),
            stageStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stageStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stageStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
    }

    // MARK: - Side Menu Setup
    // MARK: - Side Menu Setup
    private func setupMenu() {
        // Dimmed background
        dimmedView = UIView(frame: view.bounds)
        dimmedView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        dimmedView.alpha = 0
        let tapToClose = UITapGestureRecognizer(target: self, action: #selector(toggleSideMenu))
        dimmedView.addGestureRecognizer(tapToClose)
        view.addSubview(dimmedView)
        
        // Side menu container
        sideMenuView = UIView(frame: CGRect(x: -240, y: 0, width: 240, height: view.frame.height))
        sideMenuView.backgroundColor = .white
        sideMenuView.layer.shadowColor = UIColor.black.cgColor
        sideMenuView.layer.shadowOpacity = 0.3
        sideMenuView.layer.shadowOffset = CGSize(width: 3, height: 0)
        sideMenuView.layer.shadowRadius = 5
        
        // 1) Welcome heading
        let welcomeLabel = UILabel(frame: CGRect(x: 20, y: 60, width: 200, height: 30))
        welcomeLabel.text = "Suncity"
        welcomeLabel.font = UIFont(name: "Montserrat-SemiBold", size: 24)
        welcomeLabel.textColor = .black
        sideMenuView.addSubview(welcomeLabel)
        
        // 2) Services button
        let servicesButton = UIButton(type: .system)
        servicesButton.setTitle("Services", for: .normal)
        servicesButton.setTitleColor(.black, for: .normal)
        servicesButton.contentHorizontalAlignment = .left
        servicesButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        servicesButton.frame = CGRect(x: 20, y: welcomeLabel.frame.maxY + 40, width: 200, height: 40)
        sideMenuView.addSubview(servicesButton)
        
        // Divider line between Services and Contact Us
        let divider = UIView(
            frame: CGRect(
                x: 20,
                y: servicesButton.frame.maxY + 8,
                width: sideMenuView.frame.width - 40,
                height: 0.5
            )
        )
        divider.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        sideMenuView.addSubview(divider)
        
        // 3) Contact Us button
        let contactButton = UIButton(type: .system)
        contactButton.setTitle("Contact Us", for: .normal)
        contactButton.setTitleColor(.black, for: .normal)
        contactButton.contentHorizontalAlignment = .left
        contactButton.titleLabel?.font = UIFont(name: "Montserrat-Regular", size: 16)
        contactButton.frame = CGRect(x: 20, y: divider.frame.maxY + 8, width: 200, height: 40)
        sideMenuView.addSubview(contactButton)
        
        // 4) Version label at bottom (auto from Info.plist)
        // Version label centered at bottom
        let versionLabel = UILabel()
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"

        versionLabel.text = "Version \(version)"
        versionLabel.font = UIFont(name: "Montserrat-Regular", size: 12)
        versionLabel.textColor = .darkGray
        versionLabel.textAlignment = .center
        versionLabel.translatesAutoresizingMaskIntoConstraints = false

        sideMenuView.addSubview(versionLabel)

        // Constraints to center it horizontally and place near bottom
        NSLayoutConstraint.activate([
            versionLabel.centerXAnchor.constraint(equalTo: sideMenuView.centerXAnchor),
            versionLabel.bottomAnchor.constraint(equalTo: sideMenuView.bottomAnchor, constant: -30),
            versionLabel.widthAnchor.constraint(equalTo: sideMenuView.widthAnchor) // allows full-width centering
        ])

        // Finally add menu to main view
        view.addSubview(sideMenuView)
    }



    @objc private func toggleSideMenu() {
        UIView.animate(withDuration: 0.3) {
            if self.sideMenuVisible {
                self.sideMenuView.frame.origin.x = -240
                self.dimmedView.alpha = 0
            } else {
                self.sideMenuView.frame.origin.x = 0
                self.dimmedView.alpha = 1
            }
        }
        sideMenuVisible.toggle()
    }

    @objc private func goHome() {
        let homeVC = HomeViewController()
        navigationController?.pushViewController(homeVC, animated: true)
    }
    
    private func setupImageSlider() {
        let images = (1...5).map { _ in UIImage(named: "site_image")! }

        sliderScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(images.count), height: 180)

        for (index, img) in images.enumerated() {
            let imgView = UIImageView(image: img)
            imgView.contentMode = .scaleAspectFill
            imgView.clipsToBounds = true
            imgView.layer.cornerRadius = 12
            imgView.frame = CGRect(
                x: CGFloat(index) * view.frame.width,
                y: 0,
                width: view.frame.width,
                height: 180
            )
            sliderScrollView.addSubview(imgView)
        }

        sliderScrollView.delegate = self
    }

    private func startAutoSlider() {
        sliderTimer?.invalidate() // Clear old timer if exists
        
        sliderTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { _ in
            self.moveToNextSlide()
        }
    }
    private func moveToNextSlide() {
        let totalSlides = 5
        currentSlideIndex += 1
        
        if currentSlideIndex == totalSlides {
            currentSlideIndex = 0  // loop back to first slide
        }

        let xOffset = CGFloat(currentSlideIndex) * self.view.frame.width

        sliderScrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        sliderPageControl.currentPage = currentSlideIndex
    }


    // MARK: - Data
    private func loadDataFromService() {
        setupProgressBar(currentStage: "Planning")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.planningColor = UIColor(red: 0.95, green: 0.8, blue: 0.2, alpha: 1)
            self.stages = [
                Stage(id: 1, name: "STAGE 01", color: .black),
                Stage(id: 2, name: "STAGE 02", color: .darkGray),
                Stage(id: 3, name: "STAGE 03", color: self.planningColor),
                Stage(id: 4, name: "STAGE 04", color: .lightGray),
                Stage(id: 5, name: "STAGE 05", color: .lightGray),
                Stage(id: 6, name: "STAGE 06", color: .lightGray)
            ]
            self.setupStageGrid()
        }
    }

    private func setupProgressBar(currentStage: String) {
        progressStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let stages = ["Discovery", "Planning", "Execution", "Result"]

        for stage in stages {
            let label = UILabel()
            label.text = "  \(stage)  "
            label.textAlignment = .center
            label.font = UIFont(name: "Montserrat-Bold", size: 13)
            label.layer.cornerRadius = 6
            label.clipsToBounds = true

            if stage == currentStage {
                label.backgroundColor = planningColor
                label.textColor = .black
            } else {
                label.backgroundColor = .lightGray
                label.textColor = .darkGray
            }
            progressStackView.addArrangedSubview(label)
        }
    }

    private func setupStageGrid() {
        stageStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        let columns = 3
        var currentRow: UIStackView?

        for (index, stage) in stages.enumerated() {
            if index % columns == 0 {
                currentRow = UIStackView()
                currentRow?.axis = .horizontal
                currentRow?.distribution = .fillEqually
                currentRow?.spacing = 12
                currentRow?.translatesAutoresizingMaskIntoConstraints = false
                stageStackView.addArrangedSubview(currentRow!)
            }

            if let row = currentRow {
                let stageView = createStageCard(for: stage)
                stageView.widthAnchor.constraint(equalToConstant: (view.frame.width - 64) / 3).isActive = true
                row.addArrangedSubview(stageView)
            }
        }
    }

    private func createStageCard(for stage: Stage) -> UIView {
        let card = UIView()
        card.layer.cornerRadius = 10
        card.backgroundColor = stage.color
        card.heightAnchor.constraint(equalToConstant: 80).isActive = true
        card.tag = stage.id
        card.isUserInteractionEnabled = true

        let tap = UITapGestureRecognizer(target: self, action: #selector(handleStageTap(_:)))
        card.addGestureRecognizer(tap)

        let label = UILabel()
        label.text = stage.name
        label.textAlignment = .center
        label.textColor = stage.color == .lightGray ? .black : .white
        label.font = UIFont(name: "Montserrat-Bold", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false

        card.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: card.centerYAnchor)
        ])

        return card
    }

    @objc private func handleStageTap(_ sender: UITapGestureRecognizer) {
        guard let selectedCard = sender.view else { return }
        selectedStageIndex = selectedCard.tag
        print("Stage tapped: \(selectedStageIndex ?? -1)")

        // highlight selection
        for row in stageStackView.arrangedSubviews {
            guard let rowStack = row as? UIStackView else { continue }
            for view in rowStack.arrangedSubviews {
                view.layer.borderWidth = (view.tag == selectedStageIndex) ? 3 : 0
                view.layer.borderColor = (view.tag == selectedStageIndex) ? UIColor.systemBlue.cgColor : nil
            }
        }

        // push detail screen
        if let id = selectedStageIndex {
            let detailVC = StageDetailViewController(stages: stages, currentStageId: id)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }


}

extension SuncityViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / view.frame.width)
        currentSlideIndex = pageIndex
        sliderPageControl.currentPage = pageIndex
    }

}


