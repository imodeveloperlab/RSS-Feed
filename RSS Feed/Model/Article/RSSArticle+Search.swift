//
//  RSSFeedItem+Search.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 21.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation

extension RSSArticle {
    
    /// Prepared string optimized for search in all articles
    /// - Returns: String
    func searchString() -> String {
        
        var string = ""
        
        string.append(title)
        
        if let author = author {
            string.append(" \(author)")
        }
        
        if let author = author {
            string.append(" \(author)")
        }
        
        string.append(" \(link)")
        
        return string
    }
    
    /// All article content in one string
    /// - Returns: String
    func allContentString() -> String {
        
        var string = ""
        
        string.append(title)
        
        if let author = author {
            string.append(" \(author)")
        }
        
        if let description = description {
            string.append(" \(description)")
        }
        
        string.append(" \(link)")
        
        return string
    }
}
