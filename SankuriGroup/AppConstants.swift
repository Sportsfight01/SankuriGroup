//
//  AppConstants.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 26/11/25.
//

import UIKit

// MARK: - Global style helpers

final class AppStyle {

    
    static func headerTitle(firstPart: String,
                            secondPart: String,
                            size: CGFloat = 28) -> NSAttributedString {
        
        let fullText = "\(firstPart) \(secondPart)"
        let attributed = NSMutableAttributedString(string: fullText)
        
        // Fonts (fallback to system if Montserrat isn't available)
        let regularFont = UIFont(name: "Montserrat-Regular", size: size)
            ?? UIFont.systemFont(ofSize: size, weight: .regular)
        let boldFont = UIFont(name: "Montserrat-Bold", size: size)
            ?? UIFont.systemFont(ofSize: size, weight: .bold)
        
        // Ranges based on STRING content (not locations)
        let nsString = fullText as NSString
        let firstRange = nsString.range(of: firstPart)
        let secondRange = nsString.range(of: secondPart)
        
        // First part: black + regular
        attributed.addAttributes(
            [
                .font: regularFont,
                .foregroundColor: UIColor.black
            ],
            range: firstRange
        )
        
        // Second part: yellow + bold
        attributed.addAttributes(
            [
                .font: boldFont,
                .foregroundColor: Colors.yellow
            ],
            range: secondRange
        )
        
        return attributed
    }
    
    // MARK: Global colors
    struct Colors {
        static let yellow: UIColor   = UIColor(hex: "#F0C040")
        static let bodyBackground: UIColor = UIColor(hex: "#EEEEEE")
        static let grey: UIColor     = UIColor(hex: "#D9D9D9")
    }
}

// MARK: - UIColor helper for hex strings

extension UIColor {
    /// Create a UIColor from a hex string like "#F0C040" or "F0C040"
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var cleaned = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        if cleaned.hasPrefix("#") {
            cleaned.removeFirst()
        }
        
        var rgb: UInt64 = 0
        Scanner(string: cleaned).scanHexInt64(&rgb)
        
        let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let b = CGFloat(rgb & 0x0000FF) / 255.0
        
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

