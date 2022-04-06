//
//  ViewController.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 17.05.2021.
//

import UIKit
import DSKit

class ViewController: DSTabBarViewController {
    
    let home = HomeViewController()
    let bookMarks = BookMarksViewController()
    let settings = SettingsViewController()
    
    open override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let config = DSSFSymbolConfig.symbolConfig(style: .custom(size: 17, weight: .medium))
        let configSelected = DSSFSymbolConfig.symbolConfig(style: .custom(size: 20, weight: .semibold))
        
        home.tabBarItem.title = "Articles"
        home.tabBarItem.image = UIImage(systemName: "doc.richtext", withConfiguration: config)
        home.tabBarItem.selectedImage = UIImage(systemName: "doc.richtext.fill", withConfiguration: configSelected)
        
        bookMarks.tabBarItem.title = "Bookmarks"
        bookMarks.tabBarItem.image = UIImage(systemName: "bookmark", withConfiguration: config)
        bookMarks.tabBarItem.selectedImage = UIImage(systemName: "bookmark.fill", withConfiguration: configSelected)
        
        settings.tabBarItem.title = "Settings"
        settings.tabBarItem.image = UIImage(systemName: "lightbulb", withConfiguration: config)
        settings.tabBarItem.selectedImage = UIImage(systemName: "lightbulb.fill", withConfiguration: configSelected)
        
        setViewControllers([DSNavigationViewController(rootViewController: home),
                            DSNavigationViewController(rootViewController: bookMarks),
                            DSNavigationViewController(rootViewController: settings)], animated: true)
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}
