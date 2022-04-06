//
//  RSSArticle.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation

struct RSSArticle: Codable {
    
    let title: String
    let description: String?
    let date: Date
    let link: String
    var author: String?
    var image: URL?
}

extension RSSArticle {
    
    func isValid() -> Bool {
        
        /// Apple will reject app if articles or app info will contain information about covid and pandemy
        let exclude = ["covid",
                       "covid-19",
                       "virus",
                       "pandemy",
                       "corona",
                       "infection",
                       "vaccin",
                       "cov-19"]
        
        // Filtred articles
        let filtered = [self].filter { (article) -> Bool in
            let match = exclude.filter { article.allContentString().lowercased().range(of:$0) != nil }.count != 0
            return !match
        }
        
        return !filtered.isEmpty
    }
}
