//
//  StageGalleryViewController.swift
//  SankuriGroup
//
//  Created by DMSS MACBOOK on 12/02/26.
//

import UIKit

class StageGalleryViewController: UIViewController, UIScrollViewDelegate {

    var imageURLs: [String] = []
    
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
        startAutoScroll()
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

        loadImages()
    }


    
    private func loadImages() {
        guard !imageURLs.isEmpty else { return }

        let width = view.frame.width - 32
        let height: CGFloat = 220

        scrollView.contentSize = CGSize(
            width: width * CGFloat(imageURLs.count),
            height: height
        )

        pageControl.numberOfPages = imageURLs.count
        pageControl.currentPage = 0

        for (index, urlString) in imageURLs.enumerated() {
            let imageView = UIImageView()
            imageView.frame = CGRect(
                x: CGFloat(index) * width,
                y: 0,
                width: width,
                height: height
            )

            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 12
            imageView.backgroundColor = .lightGray

            if let url = URL(string: urlString) {
                imageView.loadImage(from: url)
            }

            scrollView.addSubview(imageView)
        }
    }

    private func startAutoScroll() {
        guard imageURLs.count > 1 else { return }

        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: 2.0,
            target: self,
            selector: #selector(autoScroll),
            userInfo: nil,
            repeats: true
        )
    }

    @objc private func autoScroll() {
        let pageWidth = scrollView.frame.width
        guard pageWidth > 0 else { return }

        let currentPage = Int(scrollView.contentOffset.x / pageWidth)
        let nextPage = (currentPage + 1) % imageURLs.count

        let offset = CGPoint(x: CGFloat(nextPage) * pageWidth, y: 0)
        scrollView.setContentOffset(offset, animated: true)
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        guard width > 0 else { return }

        pageControl.currentPage = Int(scrollView.contentOffset.x / width)
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



