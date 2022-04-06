//
//  FilterDetailsViewController.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit
import FeedKit

class FilterDetailsViewController: DSViewController {
    
    public var filter: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        self.title = filter
        hideNavigationBar = true
        
        guard let filter = filter else {
            return
        }
        
        let sections = RSSSourceManager.shared.sources.sections(presenter: self, style: .list, filter: filter)
        
        print(sections.totalViewModelsCount)
        
        if sections.totalViewModelsCount <= 1 {
            self.showPlaceHolder()
        } else {
            self.show(content: sections)
        }
    }
    
    func showPlaceHolder() {
        
        if let filter = filter {
            self.showPlaceholder(image: UIImage(systemName: "doc.text.magnifyingglass"),
                                 text: "I couldn't find any articles for \(filter)")
        } else {
            self.showPlaceholder(image: UIImage(systemName: "doc.text.magnifyingglass"),
            text: "I couldn't find any articles")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewWillDisappear(animated)
    }
}
