//
//  ViewController.swift
//  App
//
//  Created by Евангелина Клюкай on 15.06.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import UIKit

class NewsListTableViewController: UITableViewController {
    
    
    private var rssItems: [News]?
    private let loadParser = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(self.refresh(_:)), for: UIControl.Event.valueChanged)
        
        fetchData()
    }
    
    @objc func refresh(_ sender : AnyObject) {
        fetchData()
    }
    
    private func fetchData() {
        loadParser.parseFeed(url: "http://www.vesti.ru/vesti.rss") { (rssItems) in
            self.rssItems = rssItems
            
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(integer: 0), with: .middle)
                self.refreshControl?.endRefreshing()
            } 
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "showNews" {
            let newsController = segue.destination as! NewsViewController
            newsController.news = sender as? News
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = rssItems?[indexPath.item]
        self.performSegue(withIdentifier: "showNews", sender: item)
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

