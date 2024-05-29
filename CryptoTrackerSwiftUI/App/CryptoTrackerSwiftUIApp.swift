//
//  CryptoTrackerSwiftUIApp.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 23.04.2024.
//

import SwiftUI

@main
struct CryptoTrackerSwiftUIApp: App {
    @State private var vm = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                .navigationBarHidden(true)
            }.environmentObject(vm)
        }
    }
}
