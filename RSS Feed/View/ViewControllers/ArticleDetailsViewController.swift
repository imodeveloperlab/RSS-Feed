//
//  ArticleDetailsViewController.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit
import FeedKit

class ArticleDetailsViewController: DSViewController {
    
    public var item: RSSArticle?
    let timeline = RSSTimeLine()
    var skipMarkAsRead: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        update()
        hideBottomContent()
        extendedLayoutIncludesOpaqueBars = true
    }
    
    func update() {
        
        guard let item = self.item else {
            return
        }
        
        self.title = item.author
        self.show(content: item.detailedSection(presenter: self))
        updateTolBar()
        
        if !skipMarkAsRead {
            DataStorage.shared.markArticleAsRead(articleId: item.identifier())
        } else {
            skipMarkAsRead = false
        }
    }
    
    func updateTolBar() {
        
        guard let item = self.item else {
            return
        }
        
        // Prev
        let prev = UIBarButtonItem(image: UIImage(systemName: "chevron.up.circle"),
                                   style: .plain,
                                   target: self,
                                   action: #selector(prevArticle))
        
        prev.isEnabled = timeline.prevArticle(currentArticleId: item.identifier()) != nil
        
        // Next
        let next = UIBarButtonItem(image: UIImage(systemName: "chevron.down.circle"), style: .plain, target: self, action: #selector(nextArticle))
        next.isEnabled = timeline.nextArticle(currentArticleId: item.identifier()) != nil
        
        // Next
        let isArticleReaded = DataStorage.shared.didReadArticle(articleId: item.identifier())
        let readMark = UIBarButtonItem(image: UIImage(systemName: isArticleReaded ? "checkmark.circle.fill" : "circle"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(readMarkArticle))
        
        if isArticleReaded {
            readMark.tintColor = UIColor.systemGreen
        }
        
        next.isEnabled = timeline.nextArticle(currentArticleId: item.identifier()) != nil
        
        let isArticleBookMarked = DataStorage.shared.isArticleBookMarked(article: item)
        let bookMark = UIBarButtonItem(image: UIImage(systemName: isArticleBookMarked ? "bookmark.fill" : "bookmark"),
                                       style: .plain,
                                       target: self,
                                       action: #selector(bookMarkArticle))
        
        if isArticleBookMarked {
            bookMark.tintColor = UIColor.systemOrange
        }

        let share = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                    style: .plain,
                                    target: self,
                                    action: #selector(shareArticle))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                     target: self,
                                     action: nil)
        
        toolbarItems = [readMark, spacer, bookMark, spacer, next, spacer, prev, spacer, share]
        navigationController?.setToolbarHidden(false, animated: true)
    }
    
    @objc func nextArticle() {
        
        guard let item = self.item else {
            return
        }
        
        if let item = timeline.nextArticle(currentArticleId: item.identifier()) {
            self.item = item
        }
        
        self.update()
    }
    
    @objc func prevArticle() {
        
        guard let item = self.item else {
            return
        }
        
        if let item = timeline.prevArticle(currentArticleId: item.identifier()) {
            self.item = item
        }
        
        self.update()
    }
    
    @objc func readMarkArticle() {
        
        guard let item = self.item else {
            return
        }
        
        if DataStorage.shared.didReadArticle(articleId: item.identifier()) {
            DataStorage.shared.markArticleAsUnread(articleId: item.identifier())
            skipMarkAsRead = true
        } else {
            DataStorage.shared.markArticleAsRead(articleId: item.identifier())
        }
        
        self.update()
    }
    
    @objc func bookMarkArticle() {
        
        guard let item = self.item else {
            return
        }

        let isArticleBookMarked = DataStorage.shared.isArticleBookMarked(article: item)

        if isArticleBookMarked {
            DataStorage.shared.unBookMark(article: item)
        } else {
            DataStorage.shared.bookMark(article: item)
        }
        
        self.update()
    }
    
    @objc func shareArticle() {
        
        guard let item = self.item else {
            return
        }
        
        let items = [URL(string: item.link)!]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
}
