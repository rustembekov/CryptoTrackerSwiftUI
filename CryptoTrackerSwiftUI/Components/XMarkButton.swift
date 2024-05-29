//
//  XMarkButton.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 28.05.2024.
//

import Foundation
import SwiftUI

struct XMarkButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View{
        Button(action:{
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Image(systemName: "xmark")
        })
    }
}

struct XMarkButton_Previews: PreviewProvider {
    static var previews: some View {
        XMarkButton()
    }
}
