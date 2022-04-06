//
//  HomeViewController.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit
import Cartography

class HomeViewController: DSViewController {
    
    let dataSubscriber = RSSDataSubscriber()
    let rssDataStatus = RSSDataStatusSubscriber()
    var progressBar = UIProgressView()

    // Display style
    var displayStyle: DisplayStyle = .list
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Articles"
        setUpSearchViewController()
        extendedLayoutIncludesOpaqueBars = true
        setUpProgressBar()
        setUpRSSUpdateSubscriber()
        updateContent()
        setUpDisplayStyleButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateContent()
    }
    
    /// Set up rss update subscriber
    func setUpRSSUpdateSubscriber() {
        
        self.loading(true)
        
        rssDataStatus.statusDidUpdate = { status in
            self.navigationItem.titleView = self.progressBar
            self.progressBar.setProgress(status.progress(), animated: true)
        }
        
        dataSubscriber.dataDidUpdate = { _ in
            
            self.loading(false)
            
            self.progressBar.setProgress(1.0, animated: true)
            
            DispatchQueue.main.after(0.5) {
                self.navigationItem.titleView = nil
                self.progressBar.setProgress(0.0, animated: true)
            }
            
            self.updateContent()
        }
    }
    
    // Progress bar
    func setUpProgressBar() {
        
        // Progress bar
        progressBar.progress = 0.4
        progressBar.backgroundColor = appearance.navigationBar.bar
        progressBar.tintColor = appearance.brandColor
        
        constrain(progressBar) { bar in
            bar.width <= 150
        }
    }
    
    // Display style
    func setUpDisplayStyleButton() {
        
        var icon: UIImage? = UIImage()
        
        switch displayStyle {
        case .list:
            icon = UIImage(systemName: "list.bullet.below.rectangle")
        case .compactList:
            icon = UIImage(systemName: "list.dash")
        }
        
        let button = UIBarButtonItem(image: icon, style: .plain, target: self, action: #selector(switchList))
        self.navigationItem.setRightBarButton(button, animated: true)
    }
    
    // Switch list
    @objc func switchList() {
        
        switch displayStyle {
        case .list:
            displayStyle = .compactList
        case .compactList:
            displayStyle = .list
        }
        
        setUpDisplayStyleButton()
        updateContent()
    }
    
    // Set up search view controller
    func setUpSearchViewController() {
        
        let searchViewController = SearchViewController()
        searchViewController.presenter = self
        
        let searchController = UISearchController(searchResultsController: searchViewController)
        searchController.searchBar.placeholder = "Search in articles"
        searchController.searchBar.barTintColor = appearance.navigationBar.bar
        searchController.searchBar.tintColor = appearance.navigationBar.text
        
        searchController.searchResultsUpdater = searchViewController
        navigationItem.searchController = searchController
    }
    
    // Update content
    func updateContent() {
        
        let sections = RSSSourceManager.shared.sources.sections(presenter: self, style: displayStyle)
        
        if sections.isEmpty {
            
            let message = "Oh no, we can't show articles this time, please try latter"
            self.showPlaceholder(image: UIImage(named: "doc.richtext"), text: message)
            
        } else {
            
            if sections.totalViewModelsCount > 0 {
                self.loading(false)
            }
            
            if !filters.isEmpty {
                
                let filterViews = filters.map { title -> DSViewModel in
                    
                    var model = filterRow(title: title)
                    
                    model.didTap { (_: DSLabelVM) in
                        let vc = FilterDetailsViewController()
                        vc.filter = title
                        self.push(vc)
                    }
                    
                    return model
                }
                
                self.showTop(content: filterViews.gallery().topInset(inset: 10))                
            }
            
            self.show(content: sections)
        }
    }
    
    /// Product Info
    /// - Parameters:
    ///   - title: String
    ///   - image: String
    /// - Returns: DSViewModel
    func filterRow(title: String) -> DSLabelVM {
        
        let composer = DSTextComposer(alignment: .center)
        composer.add(type: .subheadline, text: " \(title)", newLine: false)
        var text = composer.textViewModel()
        text.style.displayStyle = .grouped(inSection: false)
        text.style.borderStyle = .custom(width: 1, color: UIColor.black.withAlphaComponent(0.1))
        text.width = .estimated(100)
        
        return text
    }
}
