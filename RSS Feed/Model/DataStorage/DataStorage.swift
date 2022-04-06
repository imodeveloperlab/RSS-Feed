//
//  DataStorrage.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation

class DataStorage {
    
    // User defaults keys
    let readArticlesKey = "ReadArticlesDetailsKey"
    let bookMarkArticlesKey = "BookMarkArticlesKey"
    
    // Data
    var readArticles: [String]
    var bookMarkArticles: [RSSArticle]
    
    static let shared = DataStorage()
    
    init() {
        
        // Load read articles info
        if let result = UserDefaults.standard.stringArray(forKey: readArticlesKey) {
            self.readArticles = result
        } else {
            readArticles = [String]()
        }
        
        // Load bookmarks
        if let result = try? UserDefaults.standard.getObject(forKey: bookMarkArticlesKey, castTo: [RSSArticle].self) {
            self.bookMarkArticles = result
        } else {
            self.bookMarkArticles = [RSSArticle]()
        }
    }
    
    /// Save data
    func saveData() {
        
        do {
            try UserDefaults.standard.setObject(self.bookMarkArticles, forKey: bookMarkArticlesKey)
        } catch {
            print(error)
        }
        
        UserDefaults.standard.setValue(readArticles, forKey: readArticlesKey)
        UserDefaults.standard.synchronize()
    }
    
    /// Mark article as read
    /// - Parameter articleId: String
    func markArticleAsRead(articleId: String) {
        readArticles.append(articleId)
        saveData()
    }
    
    /// Mark article as unread
    /// - Parameter articleId: String
    func markArticleAsUnread(articleId: String) {
        readArticles.removeAll { (id) -> Bool in
            id == articleId
        }
        saveData()
    }
    
    /// Bookmark article
    /// - Parameter article: RSSArticle
    func bookMark(article: RSSArticle) {
        bookMarkArticles.append(article)
        saveData()
    }
    
    /// Remove bookmark from article
    /// - Parameter article: RSSArticle
    func unBookMark(article: RSSArticle) {
        bookMarkArticles.removeAll { (a) -> Bool in
            return a.identifier() == article.identifier()
        }
        saveData()
    }
    
    /// Check is article is bookmarked
    /// - Parameter article: RSSArticle
    /// - Returns: RSSArticle
    func isArticleBookMarked(article: RSSArticle) -> Bool {
        return bookMarkArticles.contains { (a) -> Bool in
            return a.identifier() == article.identifier()
        }        
    }
    
    /// Check if article is marked as readed
    /// - Parameter articleId: String
    /// - Returns: Bool
    func didReadArticle(articleId: String) -> Bool {
        return readArticles.contains(articleId)
    }
}
