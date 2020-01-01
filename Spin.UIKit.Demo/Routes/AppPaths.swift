//
//  AppPaths.swift
//  Spin.UIKit.Demo
//
//  Created by Thibault Wittemberg on 2020-01-01.
//  Copyright © 2020 Spinners. All rights reserved.
//

public enum VersatilePath {
    case path(path: String)
}

public enum PeoplePath {
    case peoples
    case people(id: String)
    case peopleSearch(query: String)
}

public enum FilmsPath {
    case films
    case film(id: String)
    case filmSearch(query: String)
}

public enum StarshipsPath {
    case starships
    case starship(id: String)
    case starshipSearch(query: String)
}

public enum VehiclesPath {
    case vehicles
    case vehicle(id: String)
    case vehicleSearch(query: String)
}

public enum SpeciesPath {
    case species
    case specie(id: String)
    case specieSearch(query: String)
}

public enum PlanetsPath {
    case planets
    case planet(id: String)
    case planetSearch(query: String)
}

// MARK: - String representation of paths
extension VersatilePath: Path {
    public var description: String {
        switch self {
        case .path(let path):
            return path
        }
    }
}

extension PeoplePath: Path {
    public var description: String {
        switch self {
        case .peoples:
            return "/people/"
        case .people(let id):
            return "/people/\(id)/"
        case .peopleSearch(let query):
            return "/people/?search=\(query)/"
        }
    }
}

extension FilmsPath: Path {
    public var description: String {
        switch self {
            
        case .films:
            return "/films/"
        case .film(let id):
            return "/films/\(id)/"
        case .filmSearch(let query):
            return "/films/?search=\(query)/"
        }
    }
}

extension StarshipsPath: Path {
    public var description: String {
        switch self {
            
        case .starships:
            return "/starships/"
        case .starship(let id):
            return "/starships/\(id)/"
        case .starshipSearch(let query):
            return "/starships/?search=\(query)/"
        }
    }
}

extension VehiclesPath: Path {
    public var description: String {
        switch self {
            
        case .vehicles:
            return "/vehicles/"
        case .vehicle(let id):
            return "/vehicles/\(id)/"
        case .vehicleSearch(let query):
            return "/vehicles/?search=\(query)/"
        }
    }
}

extension SpeciesPath: Path {
    public var description: String {
        switch self {
        case .species:
            return "/species/"
        case .specie(let id):
            return "/species/\(id)/"
        case .specieSearch(let query):
            return "/species/?search=\(query)/"
        }
    }
}

extension PlanetsPath: Path {
    public var description: String {
        switch self {
        case .planets:
            return "/planets/"
        case .planet(let id):
            return "/planets/\(id)/"
        case .planetSearch(let query):
            return "/planets/?search=\(query)/"
        }
    }
}
