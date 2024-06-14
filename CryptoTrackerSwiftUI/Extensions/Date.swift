//
//  Date.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 14.06.2024.
//

import Foundation

extension Date {
    init(coinDateParameter: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: coinDateParameter) ?? Date()
        self.init(timeInterval: 0, since: date)
    }
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    func formatterDateToString() -> String {
        return shortFormatter.string(from: self)
    }
}
