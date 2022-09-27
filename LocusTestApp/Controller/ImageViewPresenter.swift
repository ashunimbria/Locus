//
//  ImageViewPresenter.swift
//  LocusTestApp
//
//  Created by Ashish Nimbria on 26/09/22.
//

import UIKit

class ImageViewPresenter: UIViewController {

    @IBOutlet weak var myImageView: UIImageView!
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = self.image {
            myImageView.image = image
        }
    }

}
