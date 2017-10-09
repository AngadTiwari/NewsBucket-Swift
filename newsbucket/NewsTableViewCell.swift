//
//  NewsTableViewCell.swift
//  newsbucket
//
//  Created by Angad Tiwari on 03/10/17.
//  Copyright © 2017 angtwr31. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var img_news: UIImageView!
    @IBOutlet weak var txt_date: UILabel!
    @IBOutlet weak var txt_title: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
