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
    @State private var showLoadingLaunchView: Bool = true
    
    init(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationView {
                    HomeView()
                    .preferredColorScheme(.dark)
                    .navigationBarHidden(true)
                }
                .environmentObject(vm)
                ZStack {
                    if showLoadingLaunchView {
                        LaunchView(showLoadingLaunchScreen: $showLoadingLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
                .zIndex(2.0)
            }
        }
    }
}
