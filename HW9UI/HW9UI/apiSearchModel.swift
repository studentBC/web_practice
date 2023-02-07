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
    func locateMyself() async -> String {

        print("enter to locateMyself")
        let urlString = "https://ipinfo.io"
        var ans: String = "Taipei"
        let url = URL(string:"https://ipinfo.io")
        do {
            let (data, response) = try await URLSession.shared.data(from: url!)
            let answer = try? JSONDecoder().decode(ipInfo.self, from: data);
            ans = answer!.region + " " + answer!.city
        } catch {
            print("error occur when we retrieve ipinfo")
        }
        return ans
    }
    func goSearch(suc: submitContent) async {
        print(suc.loc, suc.dist, suc.kw, suc.Category)
        var sid = ""
        var keyword: String
        if (suc.selfLocate) {
            print("enter here man !!!!!")
            let lol = await locateMyself()
            let tmp = lol.replacingOccurrences(of: " ", with: "%20")
            let temp = suc.kw.replacingOccurrences(of: " ", with: "%20")
            keyword = temp+"%20"+tmp
        } else {
            keyword = suc.kw.replacingOccurrences(of: " ", with: "%20")
        }
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
        
        let url = "&keyword=" + keyword + "&segmentId=" + sid + "&size=200&unit=miles&radius=" + suc.dist;
        print("enter to getEventResults")
        let urlString = "https://app.ticketmaster.com/discovery/v2/events.json?apikey=uAFLpjEgT9FAAj213SNDEUVZKB9lw0WJ" + url
        
        print(urlString)
        if let url = URL(string: "http://localhost:3000/getEvents") {
            
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
                // handle the result
                do {
                    print("=== before decoding ===")
                    
                    do {
                        // make sure this JSON is in the format we expect
                        if let eves : [[String]] = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String]] {
                            // try to read out a string array
                            print(eves)
                            
                        }
                    } catch {
                        print("Failed to load: \(error.localizedDescription)")
                    }
                    
//                    let array = try JSONSerialization.jsonObject(with: data) as! [String]
//                    print(array)
                    
                    //let eves = try JSONSerialization.jsonObject(with: data, options: []) as! [[String]]
                    print("===== go gog man ====")
                    //let eves = try JSONDecoder().decode(getevents.self, from: data)
//                    for eve in eves {
//                        DispatchQueue.main.async {
//                            let temp = Event(name: eve[3], date: eve[0], time: eve[1], eventID: eve[6], genre: eve[4], imgUrl: eve[2], venue: eve[5], seatmap: eve[7], ticketStatus: eve[8], buyTicketURL: eve[9], pMin: eve[10], pMax: eve[11], currency: eve[12], venueID: eve[13])
//                            self.searchResultTable.append((temp))
//                        }
//                    }
                } catch {
                    print(error)
                }
            } catch {
                print("Checkout failed.")
            }
        }
    }
//    func searchEvent (ss: String, completion: @escaping(eventSearch?)->()) {
//        guard let url = URL(string: "https://app.ticketmaster.com/discovery/v2/events.json?apikey=uAFLpjEgT9FAAj213SNDEUVZKB9lw0WJ"+ss) else {
//            completion(nil);
//            return;
//        }
//        URLSession.shared.dataTask(with: url) {
//            data, response, error in
//            guard let res = data, error == nil else {
//                completion(nil);
//                return;
//            }
//            guard let httpResponse = response as? HTTPURLResponse,
//                (200...299).contains(httpResponse.statusCode) else {
//                print("error occur we get http status code")
//                completion(nil);
//                return
//            }
//            print("our url is \(url)")
//            
//            let es = try? JSONDecoder().decode(eventSearch.self, from: res);
//            print("try to get links")
//            print(es?.links)
//            print(es?.embedded)
//            if let events = es {
//                completion(events);
//            } else {
//                print("we did not get our es")
//                completion(nil);
//            }
//        }.resume();
//    }
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
