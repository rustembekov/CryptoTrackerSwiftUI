//
//  SettingsView.swift
//  CryptoTrackerSwiftUI
//
//  Created by Sabr on 14.06.2024.
//

import Foundation
import SwiftUI

struct SettingsView: View {
    private let defaultURL: URL = URL(string: "https://www.google.com/")!
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            List {
                settingsOwnerSection
                coinGeckoSection
                applicationSection
            }
            .font(.headline)
            .tint(.blue)
            .listStyle(GroupedListStyle())
            .navigationBarTitle("Settings")
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading){
                    XMarkButton(dismiss: _dismiss)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
            SettingsView()
    }
}

extension SettingsView {
    private var settingsOwnerSection: some View {
        Section(header: Text("Sabyrzan Rustembekov")) {
            VStack(alignment: .leading){
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                ZStack {
                    Text("This app delevop by ")
                    + Text("©Sabyrzhan Rustembekov")
                        .italic()
                    + Text(". It uses MVVM Architecture, Combine, and CoreData")
                }
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.accent)

            }
            .padding(.vertical)
            Link("More details in Github🗂", destination: URL(string: "https://github.com/rustembekov")!)
        }
    }
    private var coinGeckoSection: some View {
        Section(header: Text("CoinGecko")) {
            VStack(alignment: .leading){
                Image("coingecko")
                    .resizable()
                    .frame(height: 100)
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                ZStack {
                    Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko!")
                }
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(Color.theme.accent)

            }
            .padding(.vertical)
            Link("Visit in CoinGecko🦎", destination: URL(string: "https://www.coingecko.com/")!)
        }
    }
    private var applicationSection: some View {
        Section(header: Text("Applications")) {
            Link("Terms of service", destination: defaultURL)
            Link("Privacy policy", destination: defaultURL)
            Link("Company website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        }
    }
}
