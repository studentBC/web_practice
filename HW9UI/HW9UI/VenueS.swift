//
//  VenueS.swift
//  HW9UI
//
//  Created by Chin Lung on 1/29/23.
//
import Foundation

// MARK: - Welcome
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct VenueS: Codable {
    let name, type, id: String
    let test: Bool
    let url: String?
    let locale, postalCode, timezone: String?
    let city: City?
    let state: SState?
    let country: Country?
    let address: Address?
    let location: Location?
    let markets: [Market]?
    let dmas: [DMA]?
    let upcomingEvents: UpcomingEvents?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, postalCode, timezone, city, state, country, address, location, markets, dmas, upcomingEvents
        case links = "_links"
    }
}

// MARK: - SelfClass
struct SelfClass: Codable {
    let href: String
}

// MARK: - Market
struct Market: Codable {
    let name, id: String
}

// MARK: - City
struct City: Codable {
    let name: String
}

