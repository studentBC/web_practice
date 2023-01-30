//
//  eventModel.swift
//  HW9UI
//
//  Created by Chin Lung on 1/29/23.
//

import Foundation
// check v38
class apiSearchModel {
    init() {
        
    }
    
    func searchEvent (ss: String, completion: @escaping(eventSearch?)->()) {
        guard let url = URL(string: "https://app.ticketmaster.com/discovery/v2/events.json?apikey=uAFLpjEgT9FAAj213SNDEUVZKB9lw0WJ"+ss) else {
            completion(nil);
            return;
        }
        URLSession.shared.dataTask(with: url) {
            data, response, error in
            guard let res = data, error == nil else {
                completion(nil);
                return;
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print("error occur we get http status code")
                completion(nil);
                return
            }
            print("our url is \(url)")
            
            let es = try? JSONDecoder().decode(eventSearch.self, from: res);
            print("try to get links")
            print(es?.links)
            print(es?.embedded)
            if let events = es {
                completion(events);
            } else {
                print("we did not get our es")
                completion(nil);
            }
        }.resume();
    }
    func getVenue (venueId: String, completion: @escaping(VenueS?)->()) {
        guard let url = URL(string: "https://app.ticketmaster.com/discovery/v2/venues/\(venueId).json?apikey=uAFLpjEgT9FAAj213SNDEUVZKB9lw0WJ&id=KovZpZA7AAEA") else {
            completion(nil);
            return;
        }
        URLSession.shared.dataTask(with: url) {
            data, response, error in guard let data = data, error == nil else {
                completion(nil);
                return;
            }
            let venue = try? JSONDecoder().decode(VenueS.self, from: data);
            if let venue = venue {
                completion(venue);
            } else {
                completion(nil);
            }
        }.resume();
    }
}
