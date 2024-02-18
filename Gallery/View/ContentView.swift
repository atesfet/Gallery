//
//  ContentView.swift
//  Gallery
//
//  Created by Helena Zhang on 2/16/24.
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
        Text("Welcome to The Gallery")
            .font(.system(size: 60, weight: .bold))
        Text("Where would you like to go?")
            .font(.system(size: 40, weight: .bold))
        
        
        TextField("Enter your dream art space here!", text: $prompt)
            .font(.system(size: 40, weight: .bold))
            .multilineTextAlignment(.center)
            .frame(width: 800, height: 160)
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Button("View Environment") {
            Task {
                viewModel.prompt = prompt
                _ = await openImmersiveSpace(id: "Environment")
                immersiveSpaceActive = true
            }
        }.onAppear {
            immersiveSpaceActive = true
        }
        .font(.system(size: 35))
        .padding()
        .frame(minWidth: 200, minHeight: 50)
        .buttonStyle(.borderedProminent)
        .padding(.vertical, 26)

        
        if immersiveSpaceActive {
            Button("  Exit Environment ") {
                Task {
                    await dismissImmersiveSpace()
                    immersiveSpaceActive = false
                    
                    
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
            .font(.system(size: 34))
            .padding()
            .buttonStyle(.borderedProminent)
            .padding(.vertical, 10)
        }
    }
}

#Preview(windowStyle: .volumetric) {
    ContentView()
}
