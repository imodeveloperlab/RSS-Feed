//
//  ViewController.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit
import FeedKit

class SearchViewController: DSViewController, UISearchResultsUpdating {
    
    public var presenter: DSViewController?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = false
        self.title = "RSS Feed"
        hideNavigationBar = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        
        guard let text = searchController.searchBar.text, text != "", text.count > 3 else {
            showPlaceHolder()
            return
        }
        
        guard let presenter = presenter else {
            return
        }
        
        let sections = RSSSourceManager.shared.sources.sections(presenter: presenter, style: .compactList, filter: text)
        
        if sections.totalViewModelsCount == 0 {
            self.showPlaceHolder()
        } else {
            self.show(content: sections)
        }
    }
    
    func showPlaceHolder() {
        
        self.showPlaceholder(image: UIImage(systemName: "doc.text.magnifyingglass"),
                             text: "I couldn't find any articles")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.viewWillDisappear(animated)
    }
}
