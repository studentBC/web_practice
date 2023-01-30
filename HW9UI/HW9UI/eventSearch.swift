// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct eventSearch: Codable {
    let embedded: Embedded
    let links: Links
    let page: Page

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
        case links = "_links"
        case page
    }
}

// MARK: - WelcomeEmbedded
struct Embedded: Codable {
    let events: [Event]
}

// MARK: - Event
struct Event: Codable {
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
    let info, pleaseNote: String?
    let priceRanges: [PriceRange]?
    let seatmap: Seatmap?
    let accessibility: Accessibility?
    let ageRestrictions: AgeRestrictions?
    let ticketing: Ticketing?
    let links: EventLinks
    let embedded: EventEmbedded
    let outlets: [Outlet]?
    let description: String?
    let place: Place?
    let products: [Product]?
    let ticketLimit: TicketLimit?

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, images, sales, dates, classifications, promoter, promoters, info, pleaseNote, priceRanges, seatmap, accessibility, ageRestrictions, ticketing
        case links = "_links"
        case embedded = "_embedded"
        case outlets, description, place, products, ticketLimit
    }
}

// MARK: - Accessibility
struct Accessibility: Codable {
    let ticketLimit: Int?
    let info: String?
}

// MARK: - AgeRestrictions
struct AgeRestrictions: Codable {
    let legalAgeEnforced: Bool
}

// MARK: - Classification
struct Classification: Codable {
    let primary: Bool
    let segment, genre, subGenre: Genre
    let family: Bool
    let type, subType: Genre?
}

// MARK: - Genre
struct Genre: Codable {
    let id: String
    let name: String
}


// MARK: - Dates
struct Dates: Codable {
    let start: Start
    let timezone: String?
    let status: Status
    let spanMultipleDays: Bool
    let access: Access?
    let end: End?
    let initialStartDate: InitialStartDate?
}

// MARK: - Access
struct Access: Codable {
    let startApproximate, endApproximate: Bool
}

// MARK: - End
struct End: Codable {
    let localDate, localTime: String?
    let dateTime: String?
    let approximate, noSpecificTime: Bool
}

// MARK: - InitialStartDate
struct InitialStartDate: Codable {
    let localDate, localTime: String?
    let dateTime: String?
}

// MARK: - Start
struct Start: Codable {
    let localDate, localTime: String?
    let dateTime: String?
    let dateTBD, dateTBA, timeTBA, noSpecificTime: Bool
}

// MARK: - Status
struct Status: Codable {
    let code: Code
}

enum Code: String, Codable {
    case offsale = "offsale"
    case onsale = "onsale"
    case rescheduled = "rescheduled"
}

// MARK: - EventEmbedded
struct EventEmbedded: Codable {
    let venues: [Venue]?
    let attractions: [Attraction]?
}

// MARK: - Attraction
struct Attraction: Codable {
    let name: String
    let type: AttractionType
    let id: String
    let test: Bool
    let locale: Locale
    let images: [Image]
    let classifications: [Classification]
    let upcomingEvents: UpcomingEvents
    let links: AttractionLinks
    let url: String?
    let externalLinks: ExternalLinks?

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, locale, images, classifications, upcomingEvents
        case links = "_links"
        case url, externalLinks
    }
}

// MARK: - ExternalLinks
struct ExternalLinks: Codable {
    let facebook, homepage: [Facebook]?
    let youtube, itunes, wiki, spotify: [Facebook]?
    let musicbrainz: [Musicbrainz]?
    let instagram, twitter, lastfm: [Facebook]?
}

// MARK: - Facebook
struct Facebook: Codable {
    let url: String
}

// MARK: - Musicbrainz
struct Musicbrainz: Codable {
    let id: String
}

// MARK: - Image
struct Image: Codable {
    let ratio: String?
    let url: String
    let width, height: Int?
    let fallback: Bool?
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
    case enDe = "en-de"
    case enUs = "en-us"
}

enum AttractionType: String, Codable {
    case attraction = "attraction"
}

// MARK: - UpcomingEvents
struct UpcomingEvents: Codable {
    let total: Int
    let tmr: Int?
    let filtered: Int
    let ticketmaster, moshtix, mfxBe: Int?

    enum CodingKeys: String, CodingKey {
        case total = "_total"
        case tmr
        case filtered = "_filtered"
        case ticketmaster, moshtix
        case mfxBe = "mfx-be"
    }
}

// MARK: - Venue
struct Venue: Codable {
    let name: String
    let type: VenueType
    let id: String
    let test: Bool
    let url: String?
    let locale: Locale
    let postalCode: String
    let timezone: String
    let city: Place
    let state: SState?
    let country: Country
    let address: Address
    let location: Location
    let markets: [Genre]?
    let dmas: [DMA]?
    let upcomingEvents: UpcomingEvents
    let links: AttractionLinks
    let images: [Image]?
    let boxOfficeInfo: BoxOfficeInfo?
    let parkingDetail: String?
    let generalInfo: GeneralInfo?
    let ada: Ada?
    let accessibleSeatingDetail: String?
    let social: Social?
    let aliases: [String]?

    enum CodingKeys: String, CodingKey {
        case name, type, id, test, url, locale, postalCode, timezone, city, state, country, address, location, markets, dmas, upcomingEvents
        case links = "_links"
        case images, boxOfficeInfo, parkingDetail, generalInfo, ada, accessibleSeatingDetail, social, aliases
    }
}

// MARK: - Ada
struct Ada: Codable {
    let adaPhones, adaCustomCopy, adaHours: String
}

// MARK: - Address
struct Address: Codable {
    let line1: String?
    let line2: String?
}

// MARK: - BoxOfficeInfo
struct BoxOfficeInfo: Codable {
    let phoneNumberDetail: String?
    let openHoursDetail: String?
    let acceptedPaymentDetail, willCallDetail: String?
}

// MARK: - Place
struct Place: Codable {
    let name: String
}

// MARK: - Country
struct Country: Codable {
    let name: String
    let countryCode: String
}

// MARK: - DMA
struct DMA: Codable {
    let id: Int
}

// MARK: - GeneralInfo
struct GeneralInfo: Codable {
    let generalRule, childRule: String?
}

// MARK: - Location
struct Location: Codable {
    let longitude, latitude: String
}

// MARK: - Social
struct Social: Codable {
    let twitter: Twitter
}

// MARK: - Twitter
struct Twitter: Codable {
    let handle: String
}

// MARK: - State
struct SState: Codable {
    let name: String
    let stateCode: String
}

enum VenueType: String, Codable {
    case venue = "venue"
}

// MARK: - EventLinks
struct EventLinks: Codable {
    let linksSelf: First
    let venues, attractions: [First]?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case venues, attractions
    }
}

// MARK: - Outlet
struct Outlet: Codable {
    let url: String
    let type: OutletType
}

enum OutletType: String, Codable {
    case tmMarketPlace = "tmMarketPlace"
    case venueBoxOffice = "venueBoxOffice"
}

// MARK: - PriceRange
struct PriceRange: Codable {
    let type: PriceRangeType
    let currency: Currency
    let min, max: Double
}

enum Currency: String, Codable {
    case cad = "CAD"
    case gbp = "GBP"
    case nzd = "NZD"
    case usd = "USD"
}

enum PriceRangeType: String, Codable {
    case standard = "standard"
    case standardIncludingFees = "standard including fees"
}

// MARK: - Product
struct Product: Codable {
    let name, id: String
    let url: String
    let type: String
    let classifications: [Classification]
}

// MARK: - Promoter
struct Promoter: Codable {
    let id: String
    let name: String
    let description: String?
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
    let startDateTime, endDateTime: String?
    let name: String
}

// MARK: - Public
struct Public: Codable {
    let startDateTime: String?
    let startTBD, startTBA: Bool
    let endDateTime: String?
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
struct Links: Codable {
    let first, linksSelf, next, last: First

    enum CodingKeys: String, CodingKey {
        case first
        case linksSelf = "self"
        case next, last
    }
}

// MARK: - Page
struct Page: Codable {
    let size, totalElements, totalPages, number: Int
}
