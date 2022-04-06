//
//  String+Extensions.swift
//  RSS Feed
//
//  Created by Borinschi Ivan on 21.04.2021.
//  Copyright © 2021 Borinschi Ivan. All rights reserved.
//

import Foundation
import Sweep

extension String {
    
    /// Get string from HTML string
    /// - Returns: String?
    func stringFromHtml() -> String? {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    /// Get image URL
    /// - Returns: URL?
    func getImageUrl() -> URL? {
        
        // JPG
        let jpgImages = self.substrings(between: "https://", and: ".jpg")
        for image in jpgImages {
            
            let stringUrl = imageUrlConditioner(image: String(image), extension: "jpg")
            
            if let url = URL(string: stringUrl) {
                return url
            }
        }
        
        // PNG
        let pngImages = self.substrings(between: "https://", and: ".png")
        for image in pngImages {
            
            let stringUrl = imageUrlConditioner(image: String(image), extension: "png")
            if let url = URL(string: stringUrl) {
                return url
            }
        }
        
        return nil
    }
    
    /// Image url conditioner
    /// - Parameters:
    ///   - image: String
    ///   - ext: String
    /// - Returns: String
    func imageUrlConditioner(image: String, extension ext: String) -> String {
        
        var image = String("https://\(image).\(ext)")
        image = image.replace(target: "/small/", withString: "/big/")
        image = image.replace(target: "/0x100", withString: "/0x300")
        return image
    }
    
    /// Prepare string to be displayed
    /// - Returns: String
    func prepareStringToDisplay() -> String {
        
        var string = self
        string = string.trimmingCharacters(in: .whitespaces)
        string = string.trimmingCharacters(in: .whitespacesAndNewlines)
        string = string.trimmingCharacters(in: .newlines)
        string = string.trimmingCharacters(in: .illegalCharacters)
        string = string.replacingOccurrences(of: "\n", with: "")
        string = string.replacingOccurrences(of: "&nbsp;", with: "")
        string = string.replacingOccurrences(of: "nbsp;", with: "")
        string = string.replacingOccurrences(of: "&amp;", with: "")
        string = string.replacingOccurrences(of: "amp;", with: "")
        string = string.replacingOccurrences(of: "&rdquo;", with: "”")
        string = string.replacingOccurrences(of: "&bdquo;", with: "„")
        string = string.replacingOccurrences(of: "&quot;", with: "\"")
        string = string.replacingOccurrences(of: "&#039;&#039;", with: "”")
        string = string.replacingOccurrences(of: "&#039;", with: "'")
        string = string.deletePrefix(" ")
        string = string.replacingOccurrences(of: "\\n{2,}", with: "", options: .regularExpression, range: nil)
        
        return string
    }
}

extension String {
    
    func deletePrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
}
