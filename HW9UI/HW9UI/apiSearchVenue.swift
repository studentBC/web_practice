//
//  apiSearchVenue.swift
//  HW9UI
//
//  Created by Chin Lung on 1/31/23.
//

import Foundation

class apiSearchVenue: ObservableObject {
    @Published var venueDetail: VenueS?
    init() {
        
    }
    func goSearch(eve: Event) {
        
        var vid = eve.embedded.venues?[0].id ?? "KovZpZAIF7aA"
        print("----------------------")
        print(vid)
        print("enter to getEventResults")
        let urlString = "https://app.ticketmaster.com/discovery/v2/venues/\(vid).json?apikey=uAFLpjEgT9FAAj213SNDEUVZKB9lw0WJ"

        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    do {
                        let searchResult = try JSONDecoder().decode(VenueS.self, from: safeData);
//                        if (searchResult.venues.count == 0) {
//                            print("we should show no result here")
//                            return;
//                        }
//                        print("------ come come ------")
//                        print(searchResult.embedded.venues.count)
                        self.venueDetail = searchResult
                    } catch {
                        print(error)
                    }
                    
                }
                
            }
            task.resume()
        }
    }
}
