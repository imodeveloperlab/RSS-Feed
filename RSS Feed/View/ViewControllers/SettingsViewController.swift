//
//  SettingsSettingsViewController.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 20.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import UIKit
import DSKit

class SettingsViewController: DSViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        updateContent()
        extendedLayoutIncludesOpaqueBars = false
    }
    
    func updateContent() {
        show(content: [interfaceStyleSection(), appearancesSection()], animated: false)
        showPoweredBy()
    }
}

extension SettingsViewController {
    
    /// Interface style section
    /// - Returns: DSSection
    func interfaceStyleSection() -> DSSection {
        
        let system = getAction(for: .unspecified)
        let dark = getAction(for: .dark)
        let light = getAction(for: .light)
        
        return [system, dark, light].list().headlineHeader("Interface style")
    }
    
    /// Get appearances section
    /// - Returns: DSSection
    func appearancesSection() -> DSSection {
        
        /// Appearance
        let appearances: [DSDesignable] = [SystemAppearance(), DSNewsAppearance()]
        
        let viewModels: [DSViewModel] = appearances.map { (theme) -> DSActionVM in
            return getAction(for: theme)
        }
        
        /// Section
        let listSection = viewModels.list()
        
        /// Set header text view model with headline style
        listSection.headlineHeader("Appearance")
        
        return listSection
    }
}

extension SettingsViewController {
    
    /// Get action for appearance
    /// - Parameter appearance: DSDesignable
    /// - Returns: DSActionVM
    func getAction(for appearance: DSDesignable) -> DSActionVM {
        
        // Action with title
        var action = DSActionVM(title: appearance.title)
        
        /// Set companion object
        action.object = appearance as AnyObject
        
        // If current appearance is equal to appearance then config it as selected one
        if DSAppearance.shared.main.title == appearance.title {
            
            // Set right icon with selected brand color for tint
            action.rightIcon(sfSymbolName: "checkmark.circle.fill", tintColor: .custom(appearance.brandColor))
        } else {
            
            // Set right icon as empty circle
            action.rightIcon(sfSymbolName: "circle")
        }
        
        // Handle did tap on action
        action.didTap { (action: DSActionVM) in
            
            // Get appearance from object
            guard let appearance = action.object as? DSDesignable else {
                return
            }
            
            // Set as current appearance
            DSAppearance.shared.main = appearance
            
            // Call update content to update interface
            self.updateContent()
        }
        
        return action
    }
    
    /// Get action for user interface style
    /// - Parameter style: UIUserInterfaceStyle
    /// - Returns: DSActionVM
    func getAction(for style: UIUserInterfaceStyle) -> DSActionVM {
        
        var name = ""
        var icon = ""
        var description: String?
        
        switch style {
        case .dark:
            name = "Dark"
            icon = "moon.circle.fill"
        case .light:
            name = "Light"
            icon = "sun.max.fill"
        default:
            name = "System"
            icon = "gear"
            description = "Based on the user's iOS settings"
        }
        
        // Action with title and subtitle
        var action = DSActionVM(title: name, subtitle: description)
        
        // Set style as companion object
        action.object = style as AnyObject
        
        // Set left icon
        action.leftIcon(sfSymbolName: icon)
        
        // If current style is equal to style then config it as selected one
        if DSAppearance.shared.userInterfaceStyle == style {
            
            // Set right icon with selected brand color for tint
            action.rightIcon(sfSymbolName: "checkmark.circle.fill", tintColor: .custom(appearance.brandColor))
            
        } else {
            
            // Set right icon as empty circle
            action.rightIcon(sfSymbolName: "circle")
        }
        
        // Handle did tap on action
        action.didTap { (action: DSActionVM) in
            
            guard let style = action.object as? UIUserInterfaceStyle else {
                return
            }
            
            DSAppearance.shared.userInterfaceStyle = style
            self.updateContent()
        }
        
        return action
    }
    
    func showPoweredBy() {
        
        let powerByText = DSTextComposer(alignment: .center)
        powerByText.add(type: .subheadline, text: "Powered by ", lineSpacing: 5)
        powerByText.add(sfSymbol: "square.stack.3d.down.right.fill", style: .custom(size: 12, weight: .medium), tint: .brand, newLine: false)
        
        powerByText.add(type: .headlineWithSize(13), text: " DSKit", newLine: false)
        powerByText.add(type: .subheadline, text: "Made with ❤️ by imodeveloper")
        powerByText.add(type: .subheadline, text: "www.dskit.app")
        
        var poweredByAction = DSActionVM(composer: powerByText)
        poweredByAction.style.displayStyle = .default
        showBottom(content: poweredByAction)
    }
}

