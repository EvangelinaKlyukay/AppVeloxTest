//
//  TableViewCell.swift
//  AppVelox
//
//  Created by Евангелина Клюкай on 15.06.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import UIKit

class NewsListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pubDateLabel: UILabel!
    
    var item: News! {
        didSet {
            titleLabel.text = item.title
            pubDateLabel.text = item.pubDate
        }
    }
}
