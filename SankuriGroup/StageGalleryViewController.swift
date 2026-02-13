//
//  StageGalleryViewController.swift
//  SankuriGroup
//
//  Created by DMSS MACBOOK on 12/02/26.
//

import UIKit

class StageGalleryViewController: UIViewController, UIScrollViewDelegate {

    var imageURLs: [String] = []
    // MARK: - Info labels
    private let dateLabel = UILabel()
    private let descriptionLabel = UILabel()

    // Data coming from API
    var galleryItems: [StageGalleryItem] = []
    
    var stageId: Int = 0   // 👈 pass this from StageDetailViewController


    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()
    
    private var autoScrollTimer: Timer?

    private let headerView = UIView()
    private let backButton = UIButton(type: .system)
    private let titleLabel = UILabel()



    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        setupHeader()
        setupSlider()
        setupInfoSection()     // ✅ NEW

        updateInfo(for: 0)    // ✅ NEW

    }

    
    private func setupHeader() {
        headerView.backgroundColor = .white

        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)

        titleLabel.text = "\(stageId) Gallery"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.textColor = .black

        view.addSubview(headerView)
        headerView.addSubview(backButton)
        headerView.addSubview(titleLabel)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 56),

            backButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            backButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30),

            titleLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor)
        ])
    }

    @objc private func backTapped() {
        autoScrollTimer?.invalidate()
        navigationController?.popViewController(animated: true)
    }

    private func setupInfoSection() {
        descriptionLabel.font = .systemFont(ofSize: 16, weight: .medium)
        descriptionLabel.textColor = .black
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        
        dateLabel.font = .systemFont(ofSize: 14)
        dateLabel.textColor = .darkGray
        dateLabel.textAlignment = .center

        view.addSubview(descriptionLabel)
        view.addSubview(dateLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            
            
            descriptionLabel.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 12),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            dateLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            dateLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)

        ])
    }

    
    private func setupSlider() {
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self

        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.3)

        view.addSubview(scrollView)
        view.addSubview(pageControl)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 40),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.heightAnchor.constraint(equalToConstant: 220),

            pageControl.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 12),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupImagesIfNeeded()
    }
    
    private var didSetupImages = false

    private func setupImagesIfNeeded() {
        guard !didSetupImages else { return }
        guard !galleryItems.isEmpty else { return }
        guard scrollView.frame.width > 0 else { return }

        didSetupImages = true
        loadImages()
        updateInfo(for: 0)
        startAutoScroll()

    }

    
    private func loadImages() {

        scrollView.subviews.forEach { $0.removeFromSuperview() }

        let width = scrollView.frame.width
        let height = scrollView.frame.height

        scrollView.contentSize = CGSize(
            width: width * CGFloat(galleryItems.count),
            height: height
        )

        pageControl.numberOfPages = galleryItems.count
        pageControl.currentPage = 0

        for (index, item) in galleryItems.enumerated() {

            let imageView = UIImageView(
                frame: CGRect(
                    x: CGFloat(index) * width,
                    y: 0,
                    width: width,
                    height: height
                )
            )

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.backgroundColor = .lightGray

            if let url = URL(string: item.imageURL) {
                imageView.loadImage(from: url)
            }

            scrollView.addSubview(imageView)
        }
    }


    private func updateInfo(for index: Int) {
        guard index < galleryItems.count else { return }

        let item = galleryItems[index]
        dateLabel.text = formatDate(item.date)
        descriptionLabel.text = item.description
    }

    private func formatDate(_ dateString: String?) -> String {
        guard let dateString else { return "" }

        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"

        if let date = inputFormatter.date(from: dateString) {
            return outputFormatter.string(from: date)
        }

        return ""
    }

    private func startAutoScroll() {
        guard galleryItems.count > 1 else { return }

        autoScrollTimer?.invalidate()

        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: 2.0,
            target: self,
            selector: #selector(autoScroll),
            userInfo: nil,
            repeats: true
        )

        RunLoop.main.add(autoScrollTimer!, forMode: .common)
    }

    @objc private func autoScroll() {
        let pageWidth = scrollView.frame.width
        guard pageWidth > 0 else { return }

        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        let nextPage = (currentPage + 1) % galleryItems.count

        let offset = CGPoint(x: CGFloat(nextPage) * pageWidth, y: 0)
        scrollView.setContentOffset(offset, animated: true)

        pageControl.currentPage = nextPage
        updateInfo(for: nextPage)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        guard width > 0 else { return }

        let page = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = page
        updateInfo(for: page)
    }




    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width

        guard width > 0 else { return }

        let page = Int(
            round(scrollView.contentOffset.x / width)
        )

        pageControl.currentPage = page
    }


}



