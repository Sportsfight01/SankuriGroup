//
//  HomeViewController.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 21/11/25.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var estates: [Estate] = []
    private let estatesScrollView = UIScrollView()

    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "home")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let estatesContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private func createEstateCard(estate: Estate) -> UIView {
        let cardView = UIView()
        cardView.layer.cornerRadius = 15
        cardView.clipsToBounds = true
        cardView.backgroundColor = .white
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.borderColor = UIColor.white.cgColor
        cardView.layer.borderWidth = 0.5

        // ✅ Tag = estate id
        cardView.tag = estate.id

        // LOGO
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFit
        logo.clipsToBounds = true
        logo.translatesAutoresizingMaskIntoConstraints = false

        // NAME LABEL
        let nameLabel = UILabel()
        nameLabel.text = estate.name.capitalized
        nameLabel.font = UIFont(name: "Montserrat-SemiBold", size: 16)
        nameLabel.textColor = .black
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.translatesAutoresizingMaskIntoConstraints = false

        // Add subviews
        cardView.addSubview(logo)
        cardView.addSubview(nameLabel)

        // (Optional) Load logo from URL
        if let url = URL(string: estate.logoURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data else { return }
                DispatchQueue.main.async {
                    logo.image = UIImage(data: data)
                }
            }.resume()
        }

        // Constraints
        NSLayoutConstraint.activate([
            // Logo takes top area
            logo.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            logo.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            logo.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            logo.bottomAnchor.constraint(equalTo: nameLabel.topAnchor, constant: -8),

            // Name label at bottom
            nameLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -8),
            nameLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            nameLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 20)
        ])

        // Tap gesture
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleEstateTap(_:)))
        cardView.addGestureRecognizer(tap)
        cardView.isUserInteractionEnabled = true

        return cardView
    }


    override func viewDidLoad() {
        super.viewDidLoad()
      //  print("Received estateId:", estateId ?? -1)

        setupUI()
        setupEstateScrollView()

        fetchEstates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupEstateScrollView() {

        // ScrollView
        estatesScrollView.translatesAutoresizingMaskIntoConstraints = false
        estatesScrollView.showsHorizontalScrollIndicator = false
        estatesScrollView.alwaysBounceHorizontal = true
        estatesScrollView.clipsToBounds = false

        // Container View
        estatesContainerView.translatesAutoresizingMaskIntoConstraints = false

        // Hierarchy (VERY IMPORTANT)
        view.addSubview(estatesScrollView)
        estatesScrollView.addSubview(estatesContainerView)

        NSLayoutConstraint.activate([

            // MARK: ScrollView → constrained to MAIN VIEW
            estatesScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            estatesScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            estatesScrollView.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -100
            ),
            estatesScrollView.heightAnchor.constraint(equalToConstant: 180),

            // MARK: Container → constrained ONLY to ScrollView
            estatesContainerView.topAnchor.constraint(equalTo: estatesScrollView.topAnchor),
            estatesContainerView.bottomAnchor.constraint(equalTo: estatesScrollView.bottomAnchor),
            estatesContainerView.leadingAnchor.constraint(equalTo: estatesScrollView.leadingAnchor),
            estatesContainerView.trailingAnchor.constraint(equalTo: estatesScrollView.trailingAnchor),

            // KEY constraint for horizontal scrolling
            estatesContainerView.heightAnchor.constraint(equalTo: estatesScrollView.heightAnchor)
        ])
    }



    private func fetchEstates() {
        EstateService.shared.fetchEstates { [weak self] result in
            switch result {
            case .success(let estates):
                self?.estates = estates
                self?.renderEstateCards()

            case .failure(let error):
                print("❌ Failed to load estates:", error)
            }
        }
    }


    private func renderEstateCards() {

        estatesContainerView.subviews.forEach { $0.removeFromSuperview() }

        var previousCard: UIView?

        for estate in estates {

            let card = createEstateCard(estate: estate)
            estatesContainerView.addSubview(card)

            NSLayoutConstraint.activate([
                card.topAnchor.constraint(equalTo: estatesContainerView.topAnchor),
                card.bottomAnchor.constraint(equalTo: estatesContainerView.bottomAnchor),
                card.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6)
            ])

            if let previous = previousCard {
                card.leadingAnchor.constraint(equalTo: previous.trailingAnchor, constant: 16).isActive = true
            } else {
                card.leadingAnchor.constraint(equalTo: estatesContainerView.leadingAnchor, constant: 16).isActive = true
            }

            previousCard = card
        }

        // 🔑 This enables scrolling
        if let lastCard = previousCard {
            lastCard.trailingAnchor.constraint(equalTo: estatesContainerView.trailingAnchor, constant: -16).isActive = true
        }
    }

    
    private func setupUI() {
        view.addSubview(backgroundImageView)
       // view.addSubview(estatesContainerView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

    }
    
    // MARK: - Navigation Action
    @objc private func handleEstateTap(_ sender: UITapGestureRecognizer) {
        guard let estateId = sender.view?.tag else { return }

        print("Tapped estate id:", estateId)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let suncityVC = storyboard.instantiateViewController(
            withIdentifier: "SuncityViewController"
        ) as? SuncityViewController {

            suncityVC.estateId = estateId   // 🔥 pass selected estate
            navigationController?.pushViewController(suncityVC, animated: true)
        }
    }
}

