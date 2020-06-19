//
//  NewsTableViewController.swift
//  AppVelox
//
//  Created by Евангелина Клюкай on 15.06.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {
    
    var news: News?

    @IBOutlet weak var imageNews: WebImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let news = news {
            titleLabel.text = news.title
            descriptionLabel.text = news.description
            if let imageUrl = news.enclosure {
                imageNews.load(url: imageUrl)
            }
        }
    }
    
}
