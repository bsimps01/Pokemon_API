//
//  Pokemon.swift
//  Pokemon_API
//
//  Created by Benjamin Simpson on 4/20/20.
//  Copyright © 2020 Benjamin Simpson. All rights reserved.
//

import Foundation

struct Pokemon: Codable {
    let name: String
    let url: String
}

struct List: Codable {
    let count: Int
    let next: String?
    let results: [Pokemon]
}

struct PokemonImage: Codable {
    let sprites: Image
}

struct Image: Codable {
    let frontDefault: String
}
