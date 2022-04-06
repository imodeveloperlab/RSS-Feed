//
//  RSSFeedItem+RSSArticle.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import FeedKit

extension RSSFeedItem {
    
    /// Get RSSArticle from RSSFeedItem
    /// - Returns: RSSArticle?
    func article() -> RSSArticle? {
        
        // Title
        guard let title = title else {
            return nil
        }
        
        // Date
        guard let date = pubDate else {
            return nil
        }
        
        // Link
        guard let link = link else {
            return nil
        }
        
        // Image
        var imageUrl = description?.getImageUrl()
        
        // Image from media
        if imageUrl == nil {
            if let url = media?.mediaThumbnails?.first?.attributes?.url {
                imageUrl = URL(string: url)
            }
        }
        
        // Image from content
        if imageUrl == nil {
            imageUrl = self.content?.contentEncoded?.getImageUrl()
        }
        
        // Image from enclosure
        if imageUrl == nil {
            imageUrl = self.enclosure?.attributes?.url?.getImageUrl()
        }
        
        let article = RSSArticle(title: title,
                                 description: description,
                                 date: date,
                                 link: link,
                                 author: author,
                                 image: imageUrl)
        
        if article.isValid() {
            return article
        } else {
            print("Invalid article: \(String(describing: self.link))")
            return nil
        }
    }
}
