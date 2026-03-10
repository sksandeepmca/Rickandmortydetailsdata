//
//  Records.swift
//  RickAndMortyEpisode
//
//  Created by Sandeep on 3/6/26.
//

import Foundation
// MARK: - Model object to map JSON API episode records to codable object.
public struct Records: Codable {
    let info: Info?
    public let results: [Results]?
}
struct Info: Codable {
    let count: Int?
    let pages: Int?
    let next: String?
    let prev: String?
}
public struct Results: Codable, Identifiable, Hashable {
    public let id: Int
    public  let name: String?
    public  let status: String?
    public let species: String?
    public let type: String?
    public let gender: String?
    //   let origin : Origin?
    //   let location : Location?
    public  let image: String?
    public  let episode: [String]?
    public  let url: String?
    public  let created: String?
}
