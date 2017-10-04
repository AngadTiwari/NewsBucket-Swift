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

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var menuToggleBtn: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var bottomTabBar: UITabBar!
    @IBOutlet weak var sidemenuTableView: UITableView!
    @IBOutlet weak var newslistTableView: UITableView!
    
    var isMenuOpen = false
    
    let news_title = ["BBC News", "Bloomberg", "Buzzfeed", "CNN", "ESPN", "Google News", "The Economist", "The Times of India"]
    let news_source = ["bbc-news", "bloomberg", "buzzfeed", "cnn", "espn", "google-news", "the-economist", "the-times-of-india"]
    
    var news_data: NSArray = []
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sidemenu: UIView!
    
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
            
//            let news_img_data = self.news_data[indexPath.row]["urlToImage"] as? String
//            let news_date_data = self.news_data[indexPath.row]["publishedAt"] as? String
//            let news_title_data = self.news_data[indexPath.row]["title"] as? String
//            
//            cell.img_news?.setImageFromURl(stringImageUrl: "\(news_img_data)")
//            cell.txt_date?.text = "Published Date: \(news_date_data)"
//            cell.txt_title?.text = "\(news_title_data)"

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
            self.navBar?.title = news_title[indexPath.row]
            self.onMenuClick(self.menuToggleBtn)
            self.getNewsDataForCategory(self.news_source[indexPath.row], self.bottomTabBar.selectedItem!.title)
        } else if(tableView == self.newslistTableView) {
            //print("newslistclick \(self.news_data?[indexPath.row]["title"] as! String)")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sidemenu.layer.shadowOpacity = 1
        self.sidemenu.layer.shadowRadius = 10.0
        self.navBar?.title = news_title[0]
        self.sidemenuTableView.selectRow(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        self.bottomTabBar.selectedItem = self.bottomTabBar.items![0] as UITabBarItem
    }
    
    func getNewsDataForCategory(_ source: String,_ category: String?) {
        let urlString = URL(string: "https://newsapi.org/v1/articles?source=\(source)&sortBy=\(category!)&apiKey=0d1d916fb7154fc6955a453c76f36475")
        if let url = urlString {
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data, error == nil else { return }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]
                    self.news_data = json["articles"] as! NSArray
                    self.newslistTableView.reloadData()
                } catch let error as NSError {
                    print(error)
                }
            }
            task.resume()
        }
    }
}

