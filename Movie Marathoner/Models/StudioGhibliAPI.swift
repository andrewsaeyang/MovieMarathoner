//
//  TmdbAPI.swift
//  Movie Marathoner
//
//  Created by Andrew Saeyang on 12/20/21.
//

import Foundation

// MARK: - Film
struct Film: Codable {
    let id, title, originalTitle, originalTitleRomanised: String
    let filmDescription, director, producer, releaseDate: String
    let runningTime, rtScore: String
    let people, species, locations, vehicles: [URL]
    let url: URL
    var isFavorite: Bool = false
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case originalTitle = "original_title"
        case originalTitleRomanised = "original_title_romanised"
        case filmDescription = "description"
        case director, producer
        case releaseDate = "release_date"
        case runningTime = "running_time"
        case rtScore = "rt_score"
        case people, species, locations, vehicles, url
    }
}

// MARK: - Person
struct Person: Decodable {
    let id, name: String
    let gender: String
    let age, eye_color, hair_color: String
    let films: [URL]
    let species, url: URL
}

// MARK: - Species
struct Species: Codable {
    let id, name, classification, eyeColors: String
    let hairColors: String
    let people, films: [URL]
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case id, name, classification
        case eyeColors = "eye_colors"
        case hairColors = "hair_colors"
        case people, films, url
    }
}

// MARK: - Location
struct Location: Decodable {
    let locationId: String
    let locationName: String
    let climate: String
    let terrain: String
    let surfaceWater: String
    let locationResidents: [URL]
    let locationAppearance: [URL]
    let locationURL: URL
    
    enum CodingKeys: String, CodingKey{
        case locationId = "id"
        case locationName = "name"
        case climate = "climate"
        case terrain = "terrain"
        case surfaceWater = "surface_water"
        case locationResidents =  "residents"
        case locationAppearance = "films"
        case locationURL = "url"
    }
}

// MARK: - Vehicle
struct Vehicle: Decodable {
    let vehicleId: String
    let vehicleName: String
    let vehicleDescription: String
    let vehicleClass: String
    let vehicleLength: String
    let pilot: URL
    let vehicleAppearance: [URL]
    let vehicleURL: URL
    
    enum CodingKeys: String, CodingKey{
        case vehicleId = "id"
        case vehicleName = "name"
        case vehicleDescription = "description"
        case vehicleClass = "vehicle_class"
        case vehicleLength = "length"
        case pilot = "pilot"
        case vehicleAppearance = "films"
        case vehicleURL = "url"
    }
}
