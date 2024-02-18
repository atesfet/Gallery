
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
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var immersiveSpaceActive: Bool = false
    var body: some Scene {
        WindowGroup(id: "Main") {
            ContentView()
                .environmentObject(viewModel)
                
        }.windowStyle(.volumetric)
            
        ImmersiveSpace(id: "Environment") {
            ImmersiveView()
                .environmentObject(viewModel)
        }.immersionStyle(selection: .constant(.full), in: .full)
        WindowGroup(id: "Breathing") {
            BreathingAnimationView(exitEnvironment: {
                Task {
                    await dismissImmersiveSpace()
                    immersiveSpaceActive = false
                    
                }
            })
                .environmentObject(viewModel)
        }
    }
}

