//
//  String.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 14.06.2024.
//

import Foundation

extension String {
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
