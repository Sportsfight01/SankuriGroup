//
//  CircularProgressView.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 22/01/26.
//

import UIKit

final class CircularProgressView: UIView {

    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()
    private let percentageLabel = UILabel()

    var progress: CGFloat = 0 {
        didSet {
            setProgress(progress)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }

    private func setupLayers() {
        backgroundColor = .clear

        let lineWidth: CGFloat = 14
        let radius = (min(bounds.width, bounds.height) - lineWidth) / 2
        let centerPoint = CGPoint(x: bounds.midX, y: bounds.midY)

        let circularPath = UIBezierPath(
            arcCenter: centerPoint,
            radius: radius,
            startAngle: -.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        )

        // Track
        trackLayer.path = circularPath.cgPath
        trackLayer.strokeColor = UIColor.black.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.fillColor = UIColor.clear.cgColor
        layer.addSublayer(trackLayer)

        // Progress
        progressLayer.path = circularPath.cgPath
        progressLayer.strokeColor = AppStyle.Colors.yellow.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeEnd = 0
        progressLayer.lineCap = .round
        layer.addSublayer(progressLayer)

        // Percentage label
        percentageLabel.font = UIFont(name: "Montserrat-Bold", size: 28)
        percentageLabel.textAlignment = .center
        percentageLabel.textColor = .black
        percentageLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(percentageLabel)

        NSLayoutConstraint.activate([
            percentageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            percentageLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        setupLayers()
        setProgress(progress)
    }

     func setProgress(_ value: CGFloat) {
        let clamped = min(max(value, 0), 1)
        progressLayer.strokeEnd = clamped
        percentageLabel.text = "\(Int(clamped * 100))%"
    }
}

