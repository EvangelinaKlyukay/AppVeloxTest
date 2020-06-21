//
//  WebImageView.swift
//  AppVelox
//
//  Created by Евангелина Клюкай on 17.06.2020.
//  Copyright © 2020 Евангелина Клюкай. All rights reserved.
//

import UIKit


class WebImageView: UIImageView {
    func load(url: URL) {
        let task = URLSession.shared.dataTask(with: url) { (data, respons, error) in
            let image = UIImage(data: data!)
            DispatchQueue.main.async {
                self.image = image
            }
        }
        task.resume()
    }
}
