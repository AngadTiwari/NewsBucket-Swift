//
//  ViewController.swift
//  newsbucket
//
//  Created by MAC on 30/09/17.
//  Copyright © 2017 angtwr31. All rights reserved.
//

import UIKit

extension UIImageView{
    
    func setImageFromURl(stringImageUrl url: String){
        
        if let url = NSURL(string: url) {
            if let data = NSData(contentsOf: url as URL) {
                self.image = UIImage(data: data as Data)
            }
        }
    }
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate  {

    @IBOutlet weak var menuToggleBtn: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var bottomTabBar: UITabBar!
    @IBOutlet weak var sidemenuTableView: UITableView!
    @IBOutlet weak var newslistTableView: UITableView!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    var isMenuOpen = false
    var selectedNewsSource = "bbc-news"
    
    let news_title = ["BBC News", "Bloomberg", "Buzzfeed", "CNN", "ESPN", "Google News", "The Economist", "The Times of India"]
    let news_source = ["bbc-news", "bloomberg", "buzzfeed", "cnn", "espn", "google-news", "the-economist", "the-times-of-india"]
    
    var news_data: NSArray = []
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sidemenu: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bottomTabBar.delegate = self
        self.sidemenu.layer.shadowOpacity = 1
        self.sidemenu.layer.shadowRadius = 10.0
        self.navBar?.title = news_title[0]
        self.sidemenuTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        self.bottomTabBar.selectedItem = self.bottomTabBar.items![0] as UITabBarItem
        self.getNewsDataForCategory(selectedNewsSource, self.bottomTabBar.selectedItem!.title)
        
    }
    
    @IBAction func onMenuClick(_ sender: Any) {
        if(isMenuOpen) {
            (leadingConstraint.constant = -200)
        } else {
            (leadingConstraint.constant = 0)
        }
        UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        isMenuOpen = !isMenuOpen
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.getNewsDataForCategory(self.selectedNewsSource, self.bottomTabBar.selectedItem!.title)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tableView == self.sidemenuTableView) ? news_title.count : news_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == self.sidemenuTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "sidemenu_list_id", for: indexPath)
            cell.textLabel?.text = news_title[indexPath.row]
            return cell
        } else if(tableView == self.newslistTableView){
            let cell = tableView.dequeueReusableCell(withIdentifier: "news_list_id", for: indexPath) as! NewsTableViewCell
            
            if let news = self.news_data[indexPath.row] as? [String:Any] {
                let title = news["title"] as? String
                let url = news["urlToImage"] as? String
                let date = news["publishedAt"] as? String
                
                cell.txt_title?.text = "\(title!)"
                cell.txt_date?.text = "Published Date: \(date!)"
                cell.img_news?.setImageFromURl(stringImageUrl: "\(url!)")
            }
            
            return cell
        }
        return UITableViewCell.init()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(tableView == self.sidemenuTableView) {
            self.selectedNewsSource = self.news_source[indexPath.row]
            self.navBar?.title = news_title[indexPath.row]
            self.onMenuClick(self.menuToggleBtn)
            self.getNewsDataForCategory(self.selectedNewsSource, self.bottomTabBar.selectedItem!.title)
        } else if(tableView == self.newslistTableView) {
            //print("newslistclick \(self.news_data?[indexPath.row]["title"] as! String)")
        }
    }
    
    func showAlert(_ heading:String, _ msg: String) {
        let alert = UIAlertController(title: heading, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getNewsDataForCategory(_ source: String,_ category: String?) {
        
        self.loader.startAnimating()
        DispatchQueue.global(qos: .background).async {
            let urlString = URL(string: "https://newsapi.org/v1/articles?source=\(source)&sortBy=\(category!)&apiKey=0d1d916fb7154fc6955a453c76f36475")
            if let url = urlString {
                let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                    guard let data = data, error == nil else { return }
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                        if json["articles"] != nil {
                            self.news_data = json["articles"] as! NSArray
                            DispatchQueue.main.async {
                                self.newslistTableView.reloadData()
                            }
                        } else {
                            self.news_data = []
                            DispatchQueue.main.async {
                                self.newslistTableView.reloadData()
                                self.showAlert("Alert", json["message"] as! String)
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                        DispatchQueue.main.async {
                            self.showAlert("Alert", error.localizedDescription)
                        }
                    }
                    DispatchQueue.main.async {
                        self.loader.stopAnimating()
                    }
                }
                task.resume()
            }
        }
    }
}

