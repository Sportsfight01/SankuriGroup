//
//  HomeViewController.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 21/11/25.
//

import UIKit

class HomeViewController: UIViewController {
    
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
    
    private func createEstateCard(logoName: String, tag: Int) -> UIView {
        let cardView = UIView()
        cardView.layer.cornerRadius = 15
        cardView.clipsToBounds = true
        cardView.backgroundColor = .white
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.borderColor = UIColor.white.cgColor
        cardView.layer.borderWidth = 0.5
        cardView.tag = tag

        
        let logo = UIImageView(image: UIImage(named: "SuncityEstate"))
        logo.contentMode = .scaleAspectFill
        logo.translatesAutoresizingMaskIntoConstraints = false
        
        cardView.addSubview(logo)
        
        NSLayoutConstraint.activate([
            logo.topAnchor.constraint(equalTo: cardView.topAnchor),
            logo.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            logo.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            logo.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
        ])
        
       // Add tap gesture
                let tap = UITapGestureRecognizer(target: self, action: #selector(handleEstateTap(_:)))
                cardView.addGestureRecognizer(tap)
                cardView.isUserInteractionEnabled = true
        
        return cardView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    
    private func setupUI() {
        view.addSubview(backgroundImageView)
        view.addSubview(estatesContainerView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            estatesContainerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            estatesContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            estatesContainerView.heightAnchor.constraint(equalToConstant: 180),
            estatesContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        
        // Create two cards manually (no stack view)
        let estate1 = createEstateCard(logoName: "Suncity",tag: 1)
       // let estate2 = createEstateCard(logoName: "Suncity2",tag: 2)
        
        estatesContainerView.addSubview(estate1)
       // estatesContainerView.addSubview(estate2)
        
        NSLayoutConstraint.activate([
            estate1.centerXAnchor.constraint(equalTo: estatesContainerView.centerXAnchor),
            estate1.centerYAnchor.constraint(equalTo: estatesContainerView.centerYAnchor),
            estate1.heightAnchor.constraint(equalTo: estatesContainerView.heightAnchor),
            estate1.widthAnchor.constraint(equalTo: estatesContainerView.widthAnchor, multiplier: 0.45)
        ])

    }
    
    // MARK: - Navigation Action
    @objc private func handleEstateTap(_ sender: UITapGestureRecognizer) {
        guard let viewTag = sender.view?.tag else { return }

        if viewTag == 1 {
            // Load from storyboard instead of creating manually
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let suncityVC = storyboard.instantiateViewController(withIdentifier: "SuncityViewController") as? SuncityViewController {
                navigationController?.pushViewController(suncityVC, animated: true)
            } else {
                print("❌ Could not find SuncityViewController in storyboard.")
            }
        } else {
            print("Sunctity tapped - no navigation yet.")
        }
    }
}

