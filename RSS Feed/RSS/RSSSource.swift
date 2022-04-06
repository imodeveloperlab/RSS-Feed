//
//  RSSSource.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import FeedKit
import DSKit

class RSSSource: Codable {
    
    /// RSS Source
    /// - Parameters:
    ///   - title: String
    ///   - url: String?
    internal init(title: String, url: String?) {
        
        self.title = title
        self.url = url
        
        if let result = try? UserDefaults.standard.getObject(forKey: title, castTo: [RSSArticle].self) {
            self.articles = result
        }
    }
    
    let title: String
    let url: String?
    var articles: [RSSArticle]? {
        
        didSet {
            
            guard let articles = articles else {
                return
            }
            
            try? UserDefaults.standard.setObject(articles, forKey: title)
        }
    }
    
    var updated: Bool = false
}
