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
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                HomeView()
                .preferredColorScheme(.dark)
                .navigationBarHidden(true)
            }.environmentObject(vm)
        }
    }
}
