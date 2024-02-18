
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
    @State private var choice: String = "Exist"
    @Environment(\.openWindow) private var openWindow
    let choices = ["Exist", "Hear Sound"]
    @Environment(\.dismiss) private var dismiss
    var exitEnvironment: () -> Void
    @State private var showBreathingAnimation = false
    
    var body: some View {
                    VStack {
                Text("Do you want to exist or listen to sound?")
                Picker("Choose an option:", selection: $choice) {
                    ForEach(choices, id: \.self) { choice in
                        Text(choice).tag(choice)
                    }
                }
                .foregroundColor(.white)
                .pickerStyle(SegmentedPickerStyle())
                .padding()
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



