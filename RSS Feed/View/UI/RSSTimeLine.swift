//
//  RSSTimeLine.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import FeedKit

class RSSTimeLine {
    
    /// RSS Feed timeline
    /// - Parameter sources: [RSSSource]
    /// - Returns: [RSSArticle]
    static func rssFeedTimeLine(for sources: [RSSSource]) -> [RSSArticle] {
        
        let articles = sources.map { (source) -> [RSSArticle] in
            
            guard let articles = source.articles else {
                return [RSSArticle]()
            }
            
            let mapped = articles.map { (article) -> RSSArticle in
                var article = article
                article.author = source.title
                
                return article
            }
            
            return mapped
            
        }.flatMap({$0})
        
        // Sort items
        let sortedArticles = articles.sorted { (a, b) -> Bool in
            return a.date > b.date
        }
        
        return sortedArticles
    }
    
    /// Index for article id in array off articles
    /// - Parameters:
    ///   - articleId: String
    ///   - articles: [RSSArticle]
    /// - Returns: Int?
    func indexFor(articleId: String, in articles: [RSSArticle]) -> Int? {
        
        for (index, article) in articles.enumerated() {
            if articleId == article.identifier() {
                return index
            }
        }
        
        return nil
    }
    
    // Next article in timeline
    func nextArticle(currentArticleId: String) -> RSSArticle? {
        
        let articles = RSSTimeLine.rssFeedTimeLine(for: RSSSourceManager.shared.sources)
        let currentIndex = indexFor(articleId: currentArticleId, in: articles)
        
        if let currentIndex = currentIndex {
            if (articles.count - 1) >= currentIndex + 1 {
                return articles[currentIndex + 1]
            }
        }
        
        return nil
    }
    
    // Previous article in timeline
    func prevArticle(currentArticleId: String) -> RSSArticle? {
        
        let articles = RSSTimeLine.rssFeedTimeLine(for: RSSSourceManager.shared.sources)
        let currentIndex = indexFor(articleId: currentArticleId, in: articles)
        
        if let currentIndex = currentIndex {
            if (currentIndex - 1) >= 0 {
                return articles[currentIndex - 1]
            }
        }
        
        return nil
    }
}
