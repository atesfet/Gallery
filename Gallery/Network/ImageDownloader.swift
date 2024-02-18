//
//  ImageDownloader.swift
//  Gallery
//
//  Created by Prabaljit Walia on 2/16/24.
//

import SwiftUI
import Foundation
import UIKit

class ImageDownloader: ObservableObject {
    @Published var downloadedCGImage: CGImage? = nil
    @Published var isLoading: Bool = false

    private let apiKey = "API_KEY"
    private var timer: Timer?
    private let statusBaseUrl = "https://backend.blockadelabs.com/api/v1/imagine/requests/"

    func initiateImageGeneration(with prompt: String) {
        guard let url = URL(string: "https://backend.blockadelabs.com/api/v1/skybox") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        request.addValue("false", forHTTPHeaderField: "enhance_prompt")
        request.addValue("9", forHTTPHeaderField: "skybox_style_id")

        
        let generationRequest = GenerationRequest(prompt: prompt)
        let jsonData = try? JSONEncoder().encode(generationRequest)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { return }
            let generationResponse = try? JSONDecoder().decode(InitiateResponse.self, from: data)
            // Handling the response
            self.checkImageStatus(id: generationResponse!.id)
        }
        task.resume()
    }

    func checkImageStatus(id: Int) {
        let statusCheckUrl = "\(statusBaseUrl)\(id)"
        guard let url = URL(string: statusCheckUrl) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(apiKey, forHTTPHeaderField: "x-api-key")

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "Unknown error")
                return
            }
            let responseString = String(data: data, encoding: .utf8)
                print("Received response: \(responseString ?? "nil")")
            do {
                let statusResponse = try JSONDecoder().decode(TopLevel.self, from: data)
                
                DispatchQueue.main.async {
                    if statusResponse.request.status == "complete" {
                        self?.downloadImage(urlString: statusResponse.request.fileUrl)
                    } else {
                        self?.timer?.invalidate() // Cancel any existing timer
                        self?.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                            self?.checkImageStatus(id: id)
                        }
                    }
                    
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }

    func downloadImage(urlString: String) {
        guard let url = URL(string: urlString) else {
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, let image = UIImage(data: data), let cgImage = image.cgImage else {
                print(error?.localizedDescription ?? "Failed to download image")
                self?.isLoading = false
                return
            }

            DispatchQueue.main.async {
                self?.downloadedCGImage = cgImage
                self?.isLoading = false
            }
        }.resume()
    }
}

