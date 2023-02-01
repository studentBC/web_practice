//
//  eventModel.swift
//  HW9UI
//
//  Created by Chin Lung on 1/29/23.
//

import Foundation
// check v38
class apiSearchModel: ObservableObject {
    @Published var searchResultTable: [Event] = []
    var venue: apiSearchVenue = apiSearchVenue()
    init() {
        
    }
    func goSearch(suc: submitContent) async {
        print(suc.loc, suc.dist, suc.kw, suc.Category)
        var sid = ""
        if (suc.Category == "Default") {
            sid = "KZFzniwnSyZfZ7v7nJ,%20KZFzniwnSyZfZ7v7nE,%20KZFzniwnSyZfZ7v7na,%20KZFzniwnSyZfZ7v7nn,%20KZFzniwnSyZfZ7v7n1"
        } else if (suc.Category == "Music") {
            sid = "KZFzniwnSyZfZ7v7nJ"
        } else if (suc.Category == "Sports") {
            sid = "KZFzniwnSyZfZ7v7nE"
        } else if (suc.Category == "Arts & Theatre") {
            sid = "KZFzniwnSyZfZ7v7na"
        } else if (suc.Category == "Film") {
            sid = "KZFzniwnSyZfZ7v7nn"
        } else {
            sid = "KZFzniwnSyZfZ7v7n1"
        }
        
        let url = "&keyword=" + suc.kw + "&segmentId=" + sid + "&size=200&unit=miles&radius=" + suc.dist;
        print("enter to getEventResults")
        let urlString = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=uAFLpjEgT9FAAj213SNDEUVZKB9lw0WJ" + url

        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    
                    do {
                        let searchResult = try JSONDecoder().decode(eventSearch.self, from: safeData);
                        print("we should have data")
                        if (searchResult.embedded.events.count == 0) {
                            print("we should show no result here")
                            return;
                        }
                        print("------ come come ------")
                        print(searchResult.embedded.events.count)
                        for i in 0...(searchResult.embedded.events.count-1) {
                            DispatchQueue.main.async {
                                self.searchResultTable.append((searchResult.embedded.events[i] as Event))
                            }
                        }
                    } catch {
                        print(error)
                    }
                    
                }
                
            }
            task.resume()
        }
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
