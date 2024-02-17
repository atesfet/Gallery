//
//  ImmersiveView.swift
//  Gallery
//
//  Created by Prabaljit Walia on 2/16/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    @ObservedObject private var imageDownloader = ImageDownloader()

    var body: some View {
        Group {
            if let cgImage = imageDownloader.downloadedCGImage {
                RealityView { content in
                    guard let texture = try? TextureResource.generate(from: cgImage, options: TextureResource.CreateOptions(semantic: nil)) else {
                        fatalError("Failed to create texture from downloaded image")
                    }
                    let rootEntity = Entity()
                    var material = UnlitMaterial()
                    material.color = .init(texture: .init(texture))
                    rootEntity.components.set(ModelComponent(mesh: .generateSphere(radius: 1E3), materials: [material]))
                    rootEntity.scale = .init(x: 1, y: 1, z: -1)
                    rootEntity.transform.translation += SIMD3<Float>(0.0, 10.0, 0.0)
                    let angle = Angle.degrees(90)
                    let rotation = simd_quatf(angle: Float(angle.radians), axis: SIMD3<Float>(0, 1, 0))
                    rootEntity.transform.rotation = rotation
                    
                    content.add(rootEntity)
                }
            } else {
                Text("Loading environment...")
            }
        }
        .onAppear {
            imageDownloader.fetchImage(with: "Mountains with ice")
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
