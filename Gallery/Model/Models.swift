//
//  Models.swift
//  Gallery
//
//  Created by Prabaljit Walia on 2/18/24.
//

import Foundation

// Response models
struct InitiateResponse: Codable {
    let id: Int
}

struct StatusResponse: Codable {
    let status: String
    let file_url: String
}

// Define the Request model
struct Request: Codable {
    let id: Int
    let obfuscatedId: String
    let userId: Int
    let apiKeyId: Int
    let title: String
    let seed: Int
    let negativeText: String?
    let prompt: String
    let username: String
    let status: String
    let queuePosition: Int
    let fileUrl: String
    let thumbUrl: String
    let depthMapUrl: String
    let remixImagineId: Int?
    let remixObfuscatedId: String?
    let isMyFavorite: Bool
    let createdAt: String
    let updatedAt: String
    let errorMessage: String?
    let pusherChannel: String
    let pusherEvent: String
    let type: String
    let skyboxStyleId: Int
    let skyboxId: Int
    let skyboxStyleName: String
    let skyboxName: String
    let dispatchedAt: String
    let processingAt: String
    let completedAt: String

    enum CodingKeys: String, CodingKey {
        case id
        case obfuscatedId = "obfuscated_id"
        case userId = "user_id"
        case apiKeyId = "api_key_id"
        case title
        case seed
        case negativeText = "negative_text"
        case prompt
        case username
        case status
        case queuePosition = "queue_position"
        case fileUrl = "file_url"
        case thumbUrl = "thumb_url"
        case depthMapUrl = "depth_map_url"
        case remixImagineId = "remix_imagine_id"
        case remixObfuscatedId = "remix_obfuscated_id"
        case isMyFavorite = "isMyFavorite"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case errorMessage = "error_message"
        case pusherChannel = "pusher_channel"
        case pusherEvent = "pusher_event"
        case type
        case skyboxStyleId = "skybox_style_id"
        case skyboxId = "skybox_id"
        case skyboxStyleName = "skybox_style_name"
        case skyboxName = "skybox_name"
        case dispatchedAt = "dispatched_at"
        case processingAt = "processing_at"
        case completedAt = "completed_at"
    }
}

// Define the top-level JSON structure
struct TopLevel: Codable {
    let request: Request
}

struct GenerationRequest: Codable {
    let prompt: String
}

struct GenerationResponse: Codable {
    let id: Int
    let status: String
    let file_url: String
}
