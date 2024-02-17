//
//  ImageDownloader.swift
//  Gallery
//
//  Created by Prabaljit Walia on 2/16/24.
//

import SwiftUI

class ImageDownloader: ObservableObject {
    @Published var downloadedCGImage: CGImage? = nil
    @Published var isLoading: Bool = false


    func fetchImage(with prompt: String) {
        self.isLoading = true // Indicate that loading has started
        let urlString = "https://api-inference.huggingface.co/models/stabilityai/stable-diffusion-xl-base-1.0"
        guard let url = URL(string: urlString) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("Bearer API_KEY", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["inputs": prompt]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                    guard let data = data, error == nil else {
                        print("Error during the request: \(error?.localizedDescription ?? "Unknown error")")
                        return
                    }
                    
                    DispatchQueue.main.async {
                        guard let uiImage = UIImage(data: data), let cgImage = uiImage.cgImage else {
                            print("Error: Could not convert data to UIImage or CGImage")
                            return
                        }
                        self?.downloadedCGImage = cgImage
                        self?.isLoading = false // Reset loading state once the fetch is complete

                        
                        print("PBJ:\(self?.downloadedCGImage?.width)")
                    }
                }.resume()
    }
}
