//
//  ViewController.swift
//  App
//
//  Created by Евангелина Клюкай on 15.06.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import UIKit

class NewsListTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private var previousItems: [News] = []
    private var rssItems: [News]?
    private let loadParser = NetworkManager()
    private let categories  = ["Политика", "Экономика", "Происшествия", "Общество", "Культура", "В мире", "Спорт"]
    private var selectedCategory = "Политика"
    var pickerView = UIPickerView()
    
    @IBAction func categoryPicker(_ sender: Any) {
          let alert = UIAlertController(title: "Category", message: "\n\n\n\n\n\n", preferredStyle: .alert)
          alert.isModalInPresentation = true
          let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
          alert.view.addSubview(pickerFrame)
          pickerFrame.dataSource = self
          pickerFrame.delegate = self
          alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
              self.rssItems = self.previousItems.filter({$0.category == self.selectedCategory})
                         self.selectedCategory = self.categories[0]
                         self.tableView.reloadData()
          }))
          self.present(alert,animated: true, completion: nil)
      }
    
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
    
       func numberOfComponents(in pickerView: UIPickerView) -> Int {
           return 1
       }

       func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
           return categories.count
       }

       func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
           return categories[row]
       }

       func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
           selectedCategory = categories[row]
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
