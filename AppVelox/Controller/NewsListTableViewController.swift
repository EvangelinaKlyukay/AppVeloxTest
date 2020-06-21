//
//  ViewController.swift
//  App
//
//  Created by Евангелина Клюкай on 15.06.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import UIKit

class NewsListTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    private let allCategoriesText = "Все категории"
    
    private var allNews: [News] = []
    private var currentNews: [News]?
    private let loadParser = NetworkManager()
    private var categories: [String] = []
    private var selectedCategoryIndex: Int = 0
    private var selectingCategoryIndex: Int = 0
    var pickerView = UIPickerView()
    
    @IBAction func categoryPicker(_ sender: Any) {
        if (categories.count <= 1) { return }
        
        let alert = UIAlertController(title: "Category", message: "\n\n\n\n\n\n", preferredStyle: .alert)
        alert.isModalInPresentation = true
        let pickerFrame = UIPickerView(frame: CGRect(x: 5, y: 20, width: 250, height: 140))
        alert.view.addSubview(pickerFrame)
        pickerFrame.dataSource = self
        pickerFrame.delegate = self
        pickerFrame.selectRow(selectedCategoryIndex, inComponent: 0, animated: true)
        selectingCategoryIndex = selectedCategoryIndex
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            self.selectedCategoryIndex = self.selectingCategoryIndex
            self.selectNewsByCurrentCategory()
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
            DispatchQueue.main.async {
                self.allNews = rssItems
                self.updateCategories()
                self.selectNewsByCurrentCategory()
                self.tableView.reloadSections(IndexSet(integer: 0), with: .middle)
                self.refreshControl?.endRefreshing()
            } 
        }
    }
    
    private func updateCategories() {
        categories.removeAll()
        categories.append(allCategoriesText)
        let availableCategories = allNews.map({ $0.category })
        categories.append(contentsOf: Set(availableCategories))
    }
    
    private func selectNewsByCurrentCategory() {
        if selectedCategoryIndex != 0 {
            let category = categories[selectedCategoryIndex]
            currentNews = allNews.filter({$0.category == category})
        } else {
            currentNews = allNews
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
        selectingCategoryIndex = row
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
        let item = currentNews?[indexPath.item]
        self.performSegue(withIdentifier: "showNews", sender: item)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rssItems = currentNews else {
            return 0
        }
        return rssItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! NewsListTableViewCell
        
        if let item = currentNews?[indexPath.item] {
            cell.item = item
        }
        return cell
    }
}
