//
//  NetworkManager.swift
//  AppVelox
//
//  Created by Евангелина Клюкай on 16.06.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import Foundation

class NetworkManager: NSObject, XMLParserDelegate {
    
    private let urlSession: URLSession
    
    private var rssItems: [News] = []
    private var currentElement = ""
    
    override init() {
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalCacheData
        config.urlCache = nil
        
        urlSession = URLSession.init(configuration: config)
    }
    
    private var currentTitle: String = "" {
        didSet {
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentPubData: String = "" {
        didSet {
            currentPubData = currentPubData.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentDescription: String = "" {
        didSet {
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentEnclosure: String = "" {
        didSet {
            currentEnclosure = currentEnclosure.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var currentCategory: String = "" {
        didSet {
            currentCategory = currentCategory.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    
    private var parserCompletionHandler: (([News]) -> Void)?
    
    func parseFeed(url: String, completionHandler: (([News]) -> Void)?) {
        self.parserCompletionHandler = completionHandler
        
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = self.urlSession
        let task = urlSession.dataTask(with: request) { (data, respons, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        if currentElement == "item" {
            currentTitle = ""
            currentPubData = ""
            currentDescription = ""
            currentCategory = ""
        }
        if currentElement == "enclosure" {
            if let url = attributeDict["url"] {
                currentEnclosure = url
            }
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "pubDate": currentPubData += string
        case "yandex:full-text": currentDescription += string
        case "enclosure": currentEnclosure += string
        case "category": currentCategory += string
            
        default: break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "item" {
            let rssItem = News(title: currentTitle, pubDate: currentPubData, enclosure: currentEnclosure, description: currentDescription, category: currentCategory)
            self.rssItems.append(rssItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(rssItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
        
    }
}


