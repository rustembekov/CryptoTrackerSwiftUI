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
        UINavigationBar.appearance().tintColor = UIColor(Color.theme.accent)
        UITableView.appearance().backgroundColor = UIColor.clear
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                NavigationView {
                    HomeView()
                    .navigationBarHidden(true)
                }
                .navigationViewStyle(StackNavigationViewStyle())
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
