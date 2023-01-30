//
//  VenueS.swift
//  HW9UI
//
//  Created by Chin Lung on 1/29/23.
//
import Foundation

// MARK: - Welcome
struct VenueS: Codable {
    let embedded: vEmbedded
    let links: Links
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case links = "_links"
        case page
    }
}
// MARK: - Embedded
struct vEmbedded: Codable {
    let venues: [vVenue]
}

// MARK: - Venue
struct vVenue: Codable {
    let name, type, id: String
    let test: Bool
    let url: String
    let locale: String
    let aliases: [String]
    let postalCode, timezone: String
    let city: City
    let state: SState
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

// MARK: - City
struct City: Codable {
    let name: String
}

// MARK: - SelfClass
struct SelfClass: Codable {
    let href: String
}

// MARK: - Market
struct Market: Codable {
    let name, id: String
}


