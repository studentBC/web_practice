//
//  eventSearch.swift
//  HW9UI
//
//  Created by Chin Lung on 1/29/23.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct eventSearch: Codable {
    let embedded: embedded
    let links: links
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case links = "_links"
        case page
    }
}

// MARK: - WelcomeEmbedded
struct embedded: Codable {
    let events: [Event]
}

// MARK: - Event
struct Event: Codable, Identifiable {
    let name: String
    let type: EventType
    let id: String
    let test: Bool
    let url: String
    let locale: Locale
    let images: [Image]
    let sales: Sales
    let dates: Dates
    let classifications: [Classification]
    let promoter: Promoter?
    let promoters: [Promoter]?
    let pleaseNote: String?
    let priceRanges: [PriceRange]?
    let products: [Product]?
    let seatmap: Seatmap
    let accessibility: Accessibility?
    let ticketLimit: TicketLimit?
    let ageRestrictions: AgeRestrictions?
    let ticketing: Ticketing?
    let links: EventLinks
    let embedded: EventEmbedded
    let info: String?
    let outlets: [Outlet]?
    let doorsTimes: DoorsTimes?

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, images, sales, dates, classifications, promoter, promoters, pleaseNote, priceRanges, products, seatmap, accessibility, ticketLimit, ageRestrictions, ticketing
        case links = "_links"
        case embedded = "_embedded"
        case info, outlets, doorsTimes
    }
}

// MARK: - Accessibility
struct Accessibility: Codable {
    let info: String?
    let ticketLimit: Int?
}

// MARK: - AgeRestrictions
struct AgeRestrictions: Codable {
    let legalAgeEnforced: Bool
    let ageRuleDescription: String?
}

// MARK: - Classification
struct Classification: Codable {
    let primary: Bool
    let segment, genre, subGenre: Genre
    let type, subType: Genre?
    let family: Bool
}

// MARK: - Genre
struct Genre: Codable {
    let id, name: String
}

// MARK: - Dates
struct Dates: Codable {
    let start: Start
    let timezone: String?
    let status: Status
    let spanMultipleDays: Bool
}

// MARK: - Start
struct Start: Codable {
    let localDate, localTime: String
    let dateTime: Date
    let dateTBD, dateTBA, timeTBA, noSpecificTime: Bool
}

// MARK: - Status
struct Status: Codable {
    let code: Code
}

enum Code: String, Codable {
    case onsale = "onsale"
}

// MARK: - DoorsTimes
struct DoorsTimes: Codable {
    let localDate, localTime: String
    let dateTime: Date
}

// MARK: - EventEmbedded
struct EventEmbedded: Codable {
    let venues: [Venue]
    let attractions: [Attraction]
}

// MARK: - Attraction
struct Attraction: Codable {
    let name: String
    let type: AttractionType
    let id: String
    let test: Bool
    let url: String
    let locale: Locale
    let externalLinks: ExternalLinks?
    let images: [Image]
    let classifications: [Classification]
    let upcomingEvents: UpcomingEvents
    let links: AttractionLinks
    let aliases: [String]?

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, externalLinks, images, classifications, upcomingEvents
        case links = "_links"
        case aliases
    }
}

// MARK: - ExternalLinks
struct ExternalLinks: Codable {
    let twitter, wiki, facebook, instagram: [Facebook]
    let homepage: [Facebook]
}

// MARK: - Facebook
struct Facebook: Codable {
    let url: String
}

// MARK: - Image
struct Image: Codable {
    let ratio: Ratio?
    let url: String
    let width, height: Int
    let fallback: Bool
    let attribution: String?
}

enum Ratio: String, Codable {
    case the16_9 = "16_9"
    case the3_2 = "3_2"
    case the4_3 = "4_3"
}

// MARK: - AttractionLinks
struct AttractionLinks: Codable {
    let linksSelf: First

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
    }
}

// MARK: - First
struct First: Codable {
    let href: String
}

enum Locale: String, Codable {
    case enUs = "en-us"
}

enum AttractionType: String, Codable {
    case attraction = "attraction"
}


// MARK: - Ada
struct Ada: Codable {
    let adaPhones, adaCustomCopy, adaHours: String
}

// MARK: - BoxOfficeInfo
struct BoxOfficeInfo: Codable {
    let phoneNumberDetail, openHoursDetail: String
    let willCallDetail, acceptedPaymentDetail: String?
}

enum CountryCode: String, Codable {
    case us = "US"
}

enum CountryName: String, Codable {
    case unitedStatesOfAmerica = "United States Of America"
}


// MARK: - GeneralInfo
struct GeneralInfo: Codable {
    let childRule: String
    let generalRule: String?
}


// MARK: - Social
struct Social: Codable {
    let twitter: Twitter
}

// MARK: - Twitter
struct Twitter: Codable {
    let handle: String
}

enum VenueType: String, Codable {
    case venue = "venue"
}

// MARK: - EventLinks
struct EventLinks: Codable {
    let linksSelf: First
    let attractions, venues: [First]

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case attractions, venues
    }
}

// MARK: - Outlet
struct Outlet: Codable {
    let url: String
    let type: String
}

// MARK: - PriceRange
struct PriceRange: Codable {
    let type: PriceRangeType
    let currency: Currency
    let min: Double
    let max: Int
}

enum Currency: String, Codable {
    case usd = "USD"
}

enum PriceRangeType: String, Codable {
    case standard = "standard"
}

// MARK: - Product
struct Product: Codable {
    let name, id: String
    let url: String
    let type: ProductType
    let classifications: [Classification]
}

enum ProductType: String, Codable {
    case parking = "Parking"
    case specialEntry = "Special Entry"
    case upsell = "Upsell"
}

// MARK: - Promoter
struct Promoter: Codable {
    let id: String
    let name: PromoterName
    let description: Description
}

enum Description: String, Codable {
    case miscellaneousPromoterNtlUsa = "MISCELLANEOUS PROMOTER / NTL / USA"
    case nbaRegularSeasonNtlUsa = "NBA REGULAR SEASON / NTL / USA"
}

enum PromoterName: String, Codable {
    case miscellaneousPromoter = "MISCELLANEOUS PROMOTER"
    case nbaRegularSeason = "NBA REGULAR SEASON"
}

// MARK: - Sales
struct Sales: Codable {
    let salesPublic: Public
    let presales: [Presale]?

    enum CodingKeys: String, CodingKey {
        case salesPublic = "public"
        case presales
    }
}

// MARK: - Presale
struct Presale: Codable {
    let startDateTime, endDateTime: Date
    let name: String
    let description: String?
}

// MARK: - Public
struct Public: Codable {
    let startDateTime: Date
    let startTBD, startTBA: Bool
    let endDateTime: Date
}

// MARK: - Seatmap
struct Seatmap: Codable {
    let staticURL: String

    enum CodingKeys: String, CodingKey {
        case staticURL = "staticUrl"
    }
}

// MARK: - TicketLimit
struct TicketLimit: Codable {
    let info: String
}

// MARK: - Ticketing
struct Ticketing: Codable {
    let safeTix: SafeTix
}

// MARK: - SafeTix
struct SafeTix: Codable {
    let enabled: Bool
}

enum EventType: String, Codable {
    case event = "event"
}

// MARK: - WelcomeLinks
struct links: Codable {
    let first, linksSelf, next, last: First

    enum CodingKeys: String, CodingKey {
        case first
        case linksSelf = "self"
        case next, last
    }
}
