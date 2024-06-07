//
//  HapticManager.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 07.06.2024.
//

import Foundation
import SwiftUI

class HapticManager {
    static private let generator = UINotificationFeedbackGenerator()
    
    static func notification(type: UINotificationFeedbackGenerator.FeedbackType){
        generator.notificationOccurred(type)
    }
}
