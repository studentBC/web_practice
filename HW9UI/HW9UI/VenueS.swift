//
//  VenueS.swift
//  HW9UI
//
//  Created by Chin Lung on 1/29/23.
//

import Foundation

struct VenueS: Codable {
    let embedded: Embedded
    let links: Links
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case links = "_links"
        case page
    }
}

// MARK: - Embedded
struct Embedded: Codable {
    let venues: [Venue]
}

// MARK: - Venue
struct Venue: Codable {
    let name, type, id: String
    let test: Bool
    let url: String
    let locale: String
    let aliases: [String]
    let postalCode, timezone: String
    let city: City
    let state: state
    let country: Country
    let address: Address
    let location: Location
    let markets: [Market]
    let dmas: [DMA]
    let upcomingEvents: UpcomingEvents
    let links: Links

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, aliases, postalCode, timezone, city, state, country, address, location, markets, dmas, upcomingEvents
        case links = "_links"
    }
}

// MARK: - Address
struct Address: Codable {
    let line1: String
}

// MARK: - City
struct City: Codable {
    let name: String
}

// MARK: - Country
struct Country: Codable {
    let name, countryCode: String
}

// MARK: - DMA
struct DMA: Codable {
    let id: Int
}

// MARK: - Links
struct Links: Codable {
    let linksSelf: SelfClass

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - SelfClass
struct SelfClass: Codable {
    let href: String
}

// MARK: - Location
struct Location: Codable {
    let longitude, latitude: String
}

// MARK: - Market
struct Market: Codable {
    let name, id: String
}

// MARK: - State
struct state: Codable {
    let name, stateCode: String
}

// MARK: - UpcomingEvents
struct UpcomingEvents: Codable {
    let total, ticketmaster, filtered: Int

    enum CodingKeys: String, CodingKey {
        case total = "_total"
        case ticketmaster
        case filtered = "_filtered"
    }
}

// MARK: - Page
struct Page: Codable {
    let size, totalElements, totalPages, number: Int
}
