//
//  MoviesSwiftUIApp.swift
//  MoviesSwiftUI
//
//  Created by Mohammad Azam on 10/13/23.
//

import SwiftUI

@main
struct MoviesSwiftUIApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView(httpClientL: HTTPClient())
            }
        }
    }
}
