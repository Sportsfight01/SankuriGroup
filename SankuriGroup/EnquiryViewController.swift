//
//  EnquiryViewController.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 26/11/25.
//

import UIKit

final class EnquiryViewController: UIViewController, UITextViewDelegate {

    private let headerContainer = UIView()
    private let backButton = UIButton(type: .system)
    private let logoImageView = UIImageView()

    private let titleLabel = UILabel()
    private let nameField = UITextField()
    private let emailField = UITextField()
    private let subjectField = UITextField()
    private let messageTextView = UITextView()
    private let submitButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppStyle.Colors.bodyBackground
        setupHeader()
        setupForm()
    }

    // MARK: - HEADER
    private func setupHeader() {
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerContainer)

        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 60)
        ])

        // Back Button
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .black
        backButton.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        backButton.translatesAutoresizingMaskIntoConstraints = false

        // Logo
        logoImageView.image = UIImage(named: "Suncity_Logo") // ensure this exists
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        headerContainer.addSubview(backButton)
        headerContainer.addSubview(logoImageView)

        NSLayoutConstraint.activate([
            backButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            backButton.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 28),
            backButton.heightAnchor.constraint(equalToConstant: 28),

            logoImageView.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 40),
            logoImageView.widthAnchor.constraint(equalToConstant: 140)
        ])
    }

    // MARK: - FORM UI
    private func setupForm() {
        
        titleLabel.attributedText = AppStyle.headerTitle(
            firstPart: "Get In",
            secondPart: "Touch"
        )
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        [nameField, emailField, subjectField].forEach { field in
            field.borderStyle = .roundedRect
            field.layer.cornerRadius = 12
            field.font = UIFont(name: "Montserrat-Regular", size: 18)
            field.translatesAutoresizingMaskIntoConstraints = false
        }

        nameField.placeholder = "Name"
        emailField.placeholder = "Email"
        subjectField.placeholder = "Subject"
        
        messageTextView.text = "Message"
        messageTextView.textColor = UIColor.lightGray
        messageTextView.delegate = self
        messageTextView.layer.cornerRadius = 12
        messageTextView.font = UIFont(name: "Montserrat-Regular", size: 18)
        messageTextView.translatesAutoresizingMaskIntoConstraints = false

        submitButton.setTitle("SUBMIT", for: .normal)
        submitButton.backgroundColor = AppStyle.Colors.yellow
        submitButton.layer.cornerRadius = 14
        submitButton.tintColor = .white
        submitButton.titleLabel?.font = UIFont(name: "Montserrat-SemiBold", size: 22)
        submitButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(titleLabel)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(subjectField)
        view.addSubview(messageTextView)
        view.addSubview(submitButton)

        NSLayoutConstraint.activate([

            // Title under header
            titleLabel.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            nameField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 24),
            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            nameField.heightAnchor.constraint(equalToConstant: 60),

            emailField.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 18),
            emailField.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            emailField.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            emailField.heightAnchor.constraint(equalToConstant: 60),

            subjectField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 18),
            subjectField.leadingAnchor.constraint(equalTo: emailField.leadingAnchor),
            subjectField.trailingAnchor.constraint(equalTo: emailField.trailingAnchor),
            subjectField.heightAnchor.constraint(equalToConstant: 60),

            messageTextView.topAnchor.constraint(equalTo: subjectField.bottomAnchor, constant: 20),
            messageTextView.leadingAnchor.constraint(equalTo: subjectField.leadingAnchor),
            messageTextView.trailingAnchor.constraint(equalTo: subjectField.trailingAnchor),
            messageTextView.heightAnchor.constraint(equalToConstant: 220),

            submitButton.topAnchor.constraint(equalTo: messageTextView.bottomAnchor, constant: 30),
            submitButton.leadingAnchor.constraint(equalTo: messageTextView.leadingAnchor),
            submitButton.trailingAnchor.constraint(equalTo: messageTextView.trailingAnchor),
            submitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    @objc private func backTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Message" {
            textView.text = ""
            textView.textColor = .black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Message"
            textView.textColor = .lightGray
        }
    }

}
