//
//  ViewController.swift
//  App
//
//  Created by Евангелина Клюкай on 15.06.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import UIKit
import FeedKit

class NewsListTableViewController: UITableViewController {
    
    private var rssItems: [News]?
    
    //var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = myRefreshControl
        
        fetchData()
    }
    
    private func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "http://www.vesti.ru/vesti.rss") { (rssItems) in
            self.rssItems = rssItems
            
            OperationQueue.main.addOperation {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .left)
            }
        }
    }
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func refresh(sender: UIRefreshControl) {
        
        tableView.reloadData()
        sender.endRefreshing()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = rssItems else {
            return 0
        }
        return rssItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsListTableViewCell
        
        if let item = rssItems?[indexPath.item] {
            cell.item = item
        }
        
        return cell
    }
}

