//
//  UIApplicationView.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 21.05.2024.
//

import Foundation
import SwiftUI

extension UIApplication {
    func ensEditing(){
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
