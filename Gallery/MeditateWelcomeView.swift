
//
//  MeditateWelcomeView.swift
//  Gallery
//
//  Created by Shaheer Khan on 2/16/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct MeditateWelcomeView: View {
    @Binding var immersiveSpaceActive: Bool
    @Binding var prompt: String
   
    @Environment(\.openWindow) private var openWindow
   
    @Environment(\.dismiss) private var dismiss
    var exitEnvironment: () -> Void
    @State private var showBreathingAnimation = false
    
    var body: some View {
                    VStack {
                        Button("Continue") {
                            dismiss();
                            openWindow(id: "Breathing")
                        }
                Button("Exit Environment") {
                    exitEnvironment()
                }
            }
        
    }
}



