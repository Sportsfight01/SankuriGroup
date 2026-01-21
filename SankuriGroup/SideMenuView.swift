//
//  SideMenuView.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 21/01/26.
//

import UIKit

protocol SideMenuDelegate: AnyObject {
    func didSelectMenuItem(_ item: SideMenuView.MenuItem)
}

final class SideMenuView: UIView {

    enum MenuItem {
        case home
        case enquiry
        case logout
    }

    weak var delegate: SideMenuDelegate?

        // MARK: - Public
        var titleText: String = "" {
            didSet {
                titleLabel.text = titleText
            }
        }

    // MARK: - UI
    private let titleLabel = UILabel()
    private let menuWidth: CGFloat = 280
    private let overlayView = UIView()
    private let containerView = UIView()
    private let versionLabel = UILabel()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Setup
    private func setupUI() {
        frame = UIScreen.main.bounds

        // Overlay
        overlayView.frame = bounds
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        overlayView.alpha = 0
        addSubview(overlayView)

        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        overlayView.addGestureRecognizer(tap)

        // Container
        containerView.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: bounds.height)
        containerView.backgroundColor = .white
        addSubview(containerView)

        setupHeader()
        setupMenuItems()
        setupVersion()
    }

    // MARK: - Header
    private func setupHeader() {

        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }


    // MARK: - Menu Items
    private func setupMenuItems() {

        let homeBtn = createButton("Home", action: #selector(enquiryTapped))
        let enquiryBtn = createButton("Enquiry", action: #selector(contactTapped))

        let divider1 = createDivider()

        let stack = UIStackView(arrangedSubviews: [
            homeBtn,
            divider1,
            enquiryBtn
        ])

        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }

    private func createButton(_ title: String, action: Selector) -> UIButton {
        let btn = UIButton(type: .system)
        btn.setTitle(title, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
        btn.setTitleColor(.black, for: .normal)
        btn.contentHorizontalAlignment = .left
        btn.addTarget(self, action: action, for: .touchUpInside)
        return btn
    }

    private func createDivider() -> UIView {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        v.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return v
    }

    // MARK: - Version
    private func setupVersion() {
        versionLabel.text = "Version 1.0"
        versionLabel.font = .systemFont(ofSize: 14)
        versionLabel.textColor = .gray
        versionLabel.translatesAutoresizingMaskIntoConstraints = false

        containerView.addSubview(versionLabel)

        NSLayoutConstraint.activate([
            versionLabel.bottomAnchor.constraint(equalTo: containerView.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            versionLabel.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
    }

    // MARK: - Actions
    @objc private func enquiryTapped() {
        delegate?.didSelectMenuItem(.home)
        hide()
    }

    @objc private func contactTapped() {
        delegate?.didSelectMenuItem(.enquiry)
        hide()
    }

    // MARK: - Show / Hide
    func show(in parent: UIView) {
        parent.addSubview(self)

        UIView.animate(withDuration: 0.3) {
            self.overlayView.alpha = 1
            self.containerView.frame.origin.x = 0
        }
    }

    @objc func hide() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0
            self.containerView.frame.origin.x = -self.menuWidth
        }) { _ in
            self.removeFromSuperview()
        }
    }
}
