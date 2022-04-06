//
//  RSSArticle+UI.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import FeedKit
import DSKit
import UIKit
import SafariServices

extension RSSArticle {
    
    /// Get article view model from RSSArticle
    /// - Parameters:
    ///   - presenter: DSViewController?
    ///   - style: DisplayStyle
    /// - Returns: DSViewModel
    func viewModel(presenter: DSViewController?, style: DisplayStyle) -> DSViewModel {
        
        let didRead = DataStorage.shared.didReadArticle(articleId: identifier())
        let didBookMark = DataStorage.shared.isArticleBookMarked(article: self)
        let composer = DSTextComposer()
        
        // Author
        switch style {
        case .list:
            if let author = author {
                composer.add(type: .text(font: .subheadlineWithSize(15), color: .brand),
                             text: author,
                             spacing: 5)
            }
        case .compactList:
            break
        }
        
        // Title
        switch style {
        case .list:
            
            composer.add(type: .text(font: .headlineWithSize(15), color: didRead ? .headline : .headline),
                         text: title,
                         spacing: 7)
            
        case .compactList:
            
            composer.add(type: .text(font: .bodyWithSize(15), color: didRead ? .headline : .headline),
                         text: title,
                         spacing: 7)
        }
        
        // Date
        switch style {
        case .list:
            composer.add(sfSymbol: "clock",
                         style: .custom(size: 10, weight: .medium),
                         tint: .subheadline)
            
            composer.add(type: .subheadlineWithSize(12),
                         text: " \(date.stringFormatted())",
                         newLine: false)
        case .compactList:
            
            if let author = author {
                composer.add(type: .text(font: .subheadlineWithSize(13), color: .brand),
                             text: author,
                             spacing: 5)
            }
        }
        
        // Action
        var action = composer.actionViewModel()
        
        if didBookMark {
            action.supplementaryItems = [didReadSupplementary(didRead: didRead), bookMarkSupplementary()]
        } else {
            action.supplementaryItems = [didReadSupplementary(didRead: didRead)]
        }
        
        // Handle tap
        action.didTap = { (model: DSViewModel) in
            
            let articleViewController = ArticleDetailsViewController()
            articleViewController.hidesBottomBarWhenPushed = true
            articleViewController.item = self
            
            // Open article view controller
            presenter?.push(articleViewController)
        }
        
        if let image = self.image {
            
            switch style {
            case .list:
                action.topImage(url: image, height: .equalTo(150))
            case .compactList:
                action.leftImage(url: image, style: .themeCornerRadius, size: .size(.init(width: 50, height: 50)))
                action.leftViewPosition = .top
            }
        }
        
        return action
    }
    
    /// Did read supplementary view
    /// - Parameter didRead: Bool
    /// - Returns: DSSupplementaryView
    func didReadSupplementary(didRead: Bool) -> DSSupplementaryView {
        
        var icon = DSImageVM(imageValue: .sfSymbol(name: didRead ? "checkmark.circle.fill" : "circle", style: .medium))
        icon.width = .absolute(19)
        icon.height = .absolute(19)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = didRead ? .custom(UIColor.systemGreen) : .custom(UIColor.systemGray)
        return icon.asSupplementary(position: .rightBottom, background: .clear)
    }
    
    /// Bookmark supplementary view
    /// - Returns: DSSupplementaryView
    func bookMarkSupplementary() -> DSSupplementaryView {
        
        var icon = DSImageVM(imageValue: .sfSymbol(name: "bookmark.fill", style: .medium))
        icon.width = .absolute(19)
        icon.height = .absolute(19)
        icon.contentMode = .scaleAspectFit
        icon.tintColor = .custom(UIColor.systemOrange)
        
        let margins = DSAppearance.shared.main.groupMargins
        let spacing = DSAppearance.shared.main.groupMargins * 2 + 19
        
        return icon.asSupplementary(position: .rightBottom, background: .clear, offset: .custom(.init(x: spacing, y: margins)))
    }
}

extension RSSArticle {
    
    /// Detailed section
    /// - Parameter presenter: DSViewController
    /// - Returns: DSSection
    func detailedSection(presenter: DSViewController) -> DSSection {
        
        var viewModels = [DSViewModel]()
        
        // Title
        let preparedTitle = title.prepareStringToDisplay()
        let label = DSLabelVM(.title2, text: preparedTitle)        
        viewModels.append(label)
        
        // Image
        if let image = self.image {
            let image = DSImageVM(imageUrl: image, height: .absolute(200),
                                  displayStyle: .themeCornerRadius,
                                  contentMode: .scaleAspectFill)
            viewModels.append(image)
        }
        
        // Date
        let composer = DSTextComposer()
        composer.add(sfSymbol: "clock", style: .custom(size: 11, weight: .medium), tint: .subheadline)
        composer.add(type: .subheadlineWithSize(13), text: " \(date.stringFormatted())", newLine: false)
        viewModels.append(composer.actionViewModel())
        
        // Text
        if let text = description, var stringFromHtml = text.stringFromHtml() {
            stringFromHtml = stringFromHtml.prepareStringToDisplay()
            let composer = DSTextComposer()
            composer.add(type: .body, text: stringFromHtml, lineSpacing: 5)
            viewModels.append(composer.textViewModel())
        }
        
        // Button
        if let url = URL(string: link) {
            
            var button = DSButtonVM(title: "Continue on \(author ?? "author website")", icon: UIImage(systemName: "doc.text")) { btn in
                
                let config = SFSafariViewController.Configuration()
                config.entersReaderIfAvailable = false
                let vc = SFSafariViewController(url: url, configuration: config)
                presenter.present(vc, animated: true)
            }
            
            button.type = .light
            viewModels.append(button)
        }
        
        return viewModels.list()
    }
}

extension Array where Element == RSSArticle {
    
    /// Sections
    /// - Parameters:
    ///   - presenter: DSViewController
    ///   - style: DisplayStyle
    ///   - filter: String?
    /// - Returns: [DSSection]
    func sections(presenter: DSViewController, style: DisplayStyle , filter: String? = nil) -> [DSSection] {
        
        let filteredItems = self.filter { (item) -> Bool in
            
            if let filter = filter {
                return item.searchString().lowercased().contains(filter.lowercased())
            }
            
            return true
        }
        
        // Today items
        let todayItems = filteredItems.filter { (item) -> Bool in
            return Date().stringFormattedDay() == item.date.stringFormattedDay()
        }
        
        // Older items
        let olderItems = filteredItems.filter { (item) -> Bool in
            return Date().stringFormattedDay() != item.date.stringFormattedDay()
        }
        
        // View models
        var todayViewModels = [DSViewModel]()
        var oldViewModels = [DSViewModel]()
        
        // Item models
        for item in todayItems {
            todayViewModels.append(item.viewModel(presenter: presenter, style: style))
        }
        
        // Item models
        for item in olderItems {
            oldViewModels.append(item.viewModel(presenter: presenter, style: style))
        }
        
        if filter != nil {
            todayViewModels = Array<DSViewModel>(todayViewModels.prefix(15))
            oldViewModels = Array<DSViewModel>(oldViewModels.prefix(15))
        }
        
        oldViewModels.append(DSSpaceVM(type: .custom(45)))
        
        return [todayViewModels.list().headlineHeader("Today"),
                oldViewModels.list().headlineHeader("All")]
    }
}
