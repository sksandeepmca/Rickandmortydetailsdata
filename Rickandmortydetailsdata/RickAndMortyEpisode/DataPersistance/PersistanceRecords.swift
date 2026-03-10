//
//  PersistanceRecords.swift
//  RickAndMortyEpisode
//
//  Created by Sandeep on 3/6/26.
//

import Foundation
import SwiftData

@Model
public final class PersistanceRecords {
    @Attribute(.unique) public var id: Int
    public var name: String?
    public var status: String?
    public var species: String?
    public var type: String?
    public var gender: String?
    public var image: String?
    public var episode: [String]?
    public var url: String?
    public var created: String?
    public var savedAt: Date
    public init
    (id: Int,
     name: String? = nil,
     status: String? = nil,
     species: String? = nil,
     type: String? = nil,
     gender: String? = nil,
     image: String? = nil,
     episode: [String]? = nil,
     url: String? = nil,
     created: String? = nil) {
            self.id = id
            self.name = name
            self.status = status
            self.species = species
            self.type = type
            self.gender = gender
            self.image = image
            self.episode = episode
            self.url = url
            self.created = created
            self.savedAt = Date()
        }
    // Convenience init to convert from server data record to persistance records
    public convenience init(from apiRecords: Results) {
        self.init(
            id: apiRecords.id,
            name: apiRecords.name,
            status: apiRecords.status,
            species: apiRecords.species,
            type: apiRecords.type,
            gender: apiRecords.gender,
            image: apiRecords.image,
            episode: apiRecords.episode,
            url: apiRecords.url,
            created: apiRecords.created,
        )
    }
    // Convert back to Domain APIJob
    public func convertpersistanceRecordsToAPIRecords() -> Results {
        return Results(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            image: image,
            episode: episode,
            url: url,
            created: created,
        )
    }
}
