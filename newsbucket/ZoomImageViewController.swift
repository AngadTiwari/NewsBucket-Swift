//
//  ZoomImageViewController.swift
//  newsbucket
//
//  Created by Angad Tiwari on 10/10/17.
//  Copyright © 2017 angtwr31. All rights reserved.
//

import UIKit

class ZoomImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imgNews: UIImageView!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var TITLE: String? = ""
    var IMAGE_URL: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.minimumZoomScale = 0.5
        self.scrollView.maximumZoomScale = 6.0
        self.scrollView.contentSize = self.imgNews.frame.size
        self.scrollView.delegate = self
        
        if (IMAGE_URL != nil) {
            imgNews.contentMode = .scaleAspectFit
            if (IMAGE_URL != nil) {
                self.imgNews.setImageFromURl(stringImageUrl: IMAGE_URL!)
            }
        }
        navTitle?.title = "\(TITLE!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgNews
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
    }
}
