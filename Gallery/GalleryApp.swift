//
//  GalleryApp.swift
//  Gallery
//
//  Created by Prabaljit Walia on 2/16/24.
//

import SwiftUI

@main
struct GalleryApp: App {
    @StateObject private var viewModel = SharedViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "Environment") {
            ImmersiveView()
                .environmentObject(viewModel) 
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}

