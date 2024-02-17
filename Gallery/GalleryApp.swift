//
//  GalleryApp.swift
//  Gallery
//
//  Created by Prabaljit Walia on 2/16/24.
//

import SwiftUI

@main
struct GalleryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.windowStyle(.volumetric)

        ImmersiveSpace(id: "Environment") {
            ImmersiveView()
        }.immersionStyle(selection: .constant(.full), in: .full)
    }
}
