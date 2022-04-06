//
//  RSSDataManager.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import FeedKit
import Foundation
import DSKit
import Combine

class RSSDataParser {
    
    static let shared = RSSDataParser()
    internal var dataPublisher = PassthroughSubject<[RSSSource], Never>()
    internal var dataStatusPublisher = PassthroughSubject<RSSUpdateStatus, Never>()
    
    var updateInProgress: Bool = false
    
    init() {
        
        Timer.scheduledTimer(timeInterval: 60 * 15,
                                         target: self,
                                         selector: #selector(fireTimer),
                                         userInfo: nil, repeats: true)
    }
    
    @objc func fireTimer() {
        update()
    }
    
    public func update() {
        
        if readPropertyListFromServer {
            
            RSSPlistReader().getPropertyList { dictionary in
                
                let sources = dictionary.map { (key, value) in
                    RSSSource(title: key, url: value)
                }
                
                RSSSourceManager.shared.sources = sources
                self.prepareAndStartUpdate()
                
            } fail: { error in
                print(error)
                self.prepareAndStartUpdate()
            }
            
        } else {
            prepareAndStartUpdate()
        }
    }
    
    fileprivate func prepareAndStartUpdate() {
        if !updateInProgress {
            
            updateInProgress = true
            
            if RSSSourceManager.shared.shouldUpdate() {
                
                for source in RSSSourceManager.shared.sources {
                    source.updated = false
                }
                
                updateNextInQueueIfNeed()
                
            } else {
                didFinishUpdate()
            }
        }
    }
    
    internal func updateNextInQueueIfNeed() {
                
        // Get next source to update
        let filtered = RSSSourceManager.shared.sources.filter { (source) -> Bool in
            source.updated == false
        }
        
        DispatchQueue.main.async {
            let updated = RSSSourceManager.shared.sources.count - filtered.count
            let total = RSSSourceManager.shared.sources.count
            self.dataStatusPublisher.send(RSSUpdateStatus(updated: updated, totalSources: total))
        }
        
        if filtered.isEmpty {
            
            RSSSourceManager.shared.setUpToDate()
            didFinishUpdate()
            
        } else {
            
            guard let source = filtered.first else {
                
                RSSSourceManager.shared.setUpToDate()
                didFinishUpdate()
                return
            }
            
            update(source: source)
        }
    }
    
    internal func didFinishUpdate() {
        
        DispatchQueue.main.async {
            self.dataPublisher.send(RSSSourceManager.shared.sources)
            self.updateInProgress = false
        }
    }
    
    internal func update(source: RSSSource) {
        
        guard let url = source.url, let feedURL = URL(string: url.replace(target: "\n", withString: "")) else {
            
            source.updated = true
            print("Bad source url: \(source.url)")
            updateNextInQueueIfNeed()
            return
        }
        
        let parser = FeedParser(URL: feedURL)
        
        // Parse asynchronously, not to block the UI.
        parser.parseAsync(queue: DispatchQueue.global(qos: .userInitiated)) { (result) in
            
            switch result {
            case .success(let feed):
                
                switch feed {
                case let .atom(feed):
                    
                    source.articles = feed.articles()
                    source.updated = true
                    self.updateNextInQueueIfNeed()
                    
                case let .rss(feed):
                    
                    source.articles = feed.articles()
                    source.updated = true
                    self.updateNextInQueueIfNeed()
                    
                case let .json(_):
                    
                    source.articles = nil
                    source.updated = true
                    self.updateNextInQueueIfNeed()
                }
                
            case .failure(_):
                
                source.articles = nil
                source.updated = true
                self.updateNextInQueueIfNeed()
            }
        }
    }
}
