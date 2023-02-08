//
//  apiSearchVenue.swift
//  HW9UI
//
//  Created by Chin Lung on 1/31/23.
//

import Foundation

class apiSearchVenue: ObservableObject {
    @Published var venueDetail: getVenueDetails?
    init() {
        
    }
    func goSearch(eve: Event) async  {
        
        var vid = eve.venueID ?? "KovZpZAIF7aA"
        print("----------------------")
        print(vid)
        print("enter to getEventResults")
        let urlString = "https://app.ticketmaster.com/discovery/v2/venues/\(vid).json?apikey=uAFLpjEgT9FAAj213SNDEUVZKB9lw0WJ"
        if let url = URL(string: "http://localhost:3000/getVenuesDetails") {
            
            let session = URLSession(configuration: .default)
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            let ur = urlRequest(url: urlString)
            guard let encoded = try? JSONEncoder().encode(ur) else {
                print("Failed to encode order")
                return
            }
            print("=== here you are man ===")
            do {
                let (data, _) = try await URLSession.shared.upload(for: request, from: encoded)
                //print(String(decoding: data, as: UTF8.self))
                // handle the result
                do {
                    print("===== go gog man ====")
                    let eves = try JSONDecoder().decode(getVenueDetails.self, from: data)
                    venueDetail = eves
//                    venueDetail?.vname = eves.vname
//                    venueDetail?.vdaddr = eves.vdaddr
                } catch {
                    print(error)
                }
            } catch {
                print("Checkout failed.")
            }
        }

        
    }
}
