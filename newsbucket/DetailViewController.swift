//
//  DetailViewController.swift
//  newsbucket
//
//  Created by Angad Tiwari on 10/10/17.
//  Copyright © 2017 angtwr31. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var imgNews: UIButton!
    @IBOutlet weak var txtDate: UILabel!
    @IBOutlet weak var txtAuthor: UILabel!
    @IBOutlet weak var txtDescription: UILabel!
    @IBOutlet weak var navTitle: UINavigationItem!
    
    var TITLE: String? = ""
    var IMAGE_URL: String? = ""
    var AUTHOR: String? = ""
    var DATE: String? = ""
    var DESCRIPTION: String? = ""
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
        }.resume()
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.imgNews.setBackgroundImage(UIImage(data: data), for: UIControlState.normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (IMAGE_URL != nil) {
            imgNews.contentMode = .scaleAspectFit
            if let image_url = URL(string: IMAGE_URL!) {
                self.downloadImage(url: image_url)
            }
        }
        txtDate?.text = (DATE != nil ? "Published Date: \(DATE!)" : "Published Date: Not Available")
        txtAuthor?.text = (AUTHOR != nil ? "\(AUTHOR!)" : "Not Available")
        txtDescription?.text = (DESCRIPTION != nil ? "\(DESCRIPTION!)" : "Not Available")
        navTitle?.title = "\(TITLE!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ZoomImageViewController {
            let vc = segue.destination as? ZoomImageViewController
            
            vc?.IMAGE_URL = IMAGE_URL
            vc?.TITLE = TITLE
        }
    }
}
