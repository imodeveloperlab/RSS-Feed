//
//  RSSSourceManager.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation

class RSSSourceManager: Codable {
    
    // Single tone
    static let shared = RSSSourceManager()
    
    // Sources to parse
    var sources: [RSSSource]
    
    init() {
        
        self.sources = rssSources
        
        if let dateValue = UserDefaults.standard.object(forKey: "lastUpdate") as? Date {
            lastUpdate = dateValue
        }
    }
    
    var lastUpdate: Date? = nil {
        didSet {
            guard let lastUpdate = lastUpdate else {
                return
            }
            UserDefaults.standard.set(lastUpdate, forKey: "lastUpdate")
            UserDefaults.standard.synchronize()
        }
    }
    
    func shouldUpdate() -> Bool {
        
        guard let lastUpdate = lastUpdate else {
            return true
        }
        
        let lastUpdateInMillisecondsAgo = lastUpdate.timeIntervalSinceNow
        return lastUpdateInMillisecondsAgo < -updatePeriodicity
    }
    
    func setUpToDate() {
        lastUpdate = Date()
    }
    
    func getArticle(articleId: String) -> RSSArticle? {
        
        for source in sources {
            
            guard let articles = source.articles else {
                return nil
            }
            
            for article in articles {
                if article.identifier() == articleId {
                    return article
                }
            }
        }
        
        return nil
    }
}
