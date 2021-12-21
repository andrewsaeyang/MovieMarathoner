//
//  BingNewsAPI.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import Foundation

// MARK: - BingTopLevelObject
struct BingTopLevelObject: Codable {
    let type: String?
    let totalEstimatedMatches: Int
    let articles: [Article]
    
    enum CodingKeys: String, CodingKey{
        case type = "_type"
        case totalEstimatedMatches
        case articles = "value"
    }
}

// MARK: - Article
struct Article: Codable {
    let type, name: String
    let url: String
    let articleImage: ArticleImage?
    let description: String
    let provider: [Provider]
    let datePublished: String
    
    enum CodingKeys: String, CodingKey{
        case type = "_type"
        case articleImage = "image"
        case name, url, description, provider, datePublished
    }
}

// MARK: - ArticleImage
struct ArticleImage: Codable {
    let thumbnail: ArticleThumbnail
}

// MARK: - ArticleThumbnail
struct ArticleThumbnail: Codable {
    let contentUrl: String
    let width: Int
    let height: Int
}

// MARK: - Provider
struct Provider: Codable {
    let type, name: String
    let image: ProviderImage?
    
    enum CodingKeys: String, CodingKey{
        case type = "_type"
        case name, image
    }
}

// MARK: - ProviderImage
struct ProviderImage: Codable {
    let thumbnail: ProviderThumbnail
}

// MARK: - ProviderThumbnail
struct ProviderThumbnail: Codable {
    let contentUrl: String
}
