//
//  SuncityViewController.swift
//  SankuriGroup
//
//  Created by Mohan Kumar on 21/11/25.
//

import UIKit

class SuncityViewController: UIViewController {
    
    @IBOutlet weak var imageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Suncity" // navigation bar titlec
        view.addSubview(imageView)

    }
}
