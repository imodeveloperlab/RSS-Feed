//
//  BookMarksViewController.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

class BookMarksViewController: DSViewController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        title = "Bookmarks"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setToolbarHidden(true, animated: true)
        updateContent()
    }
 
    func updateContent() {
        
        let sections = DataStorage.shared.bookMarkArticles.sections(presenter: self, style: .list)
        
        if sections.totalViewModelsCount == 1 {
            self.showPlaceholder(image: UIImage(systemName: "bookmark"), text: "There are currently no\nitems marked for viewing")
        } else {
            self.show(content: sections)
        }
    }
}
