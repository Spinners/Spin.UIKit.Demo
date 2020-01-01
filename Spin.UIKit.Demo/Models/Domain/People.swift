//
//  People.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

struct People: Decodable {
    let name: String
    let birthyear: String
    let eyeColor: String
    let gender: String
    let hairColor: String
    let height: String
    let mass: String
    let skinColor: String
    let homeworld: String
    let films: [String]
    let species: [String]
    let starships: [String]
    let vehicles: [String]
    let url: String
    let created: String
    let edited: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case birthyear = "birth_year"
        case eyeColor = "eye_color"
        case gender
        case hairColor = "hair_color"
        case height
        case mass
        case skinColor = "skin_color"
        case homeworld
        case films
        case species
        case starships
        case vehicles
        case url
        case created
        case edited
    }
}
