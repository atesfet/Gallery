//
//  ContentView.swift
//  Gallery
//
//  Created by Prabaljit Walia on 2/16/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ContentView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) private var dismissImmersiveSpace
    @State private var immersiveSpaceActive: Bool = false
    @State private var prompt: String = ""
    @EnvironmentObject var viewModel: SharedViewModel

    var body: some View {
        VStack {
            TextField("Enter prompt here", text: $prompt) // Add a TextField for the prompt
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(immersiveSpaceActive ? "Exit Environment" : "View Environment") {
                Task {
                    if !immersiveSpaceActive {
                        viewModel.prompt = prompt 
                        _ = await openImmersiveSpace(id: "Environment")
                        immersiveSpaceActive = true
                    } else {
                        await dismissImmersiveSpace()
                        immersiveSpaceActive = false
                    }
                }
            }

        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
