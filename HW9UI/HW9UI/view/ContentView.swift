//
//  ContentView.swift
//  HW9UI
//
//  Created by Chin Lung on 1/22/23.
//

import SwiftUI

struct submitContent {
    var kw: String
    var dist: String
    var loc: String
    var selfLocate: Bool
    var Category: String

}
private var searchResultTable: [Event] = []
private var searchAPI = apiSearchModel()
struct ContentView: View {
    @State private var kw: String = ""
    @State private var dist: String = ""
    @State private var loc: String = ""
    @State private var selection: String = "Default"
    @State private var selfLocate: Bool = false
    let categories = ["Default", "Music", "Sports", "Arts & Theatre", "Film","Miscellaneous"]
    var body: some View {
        // A cell that, when selected, adds a new folder.
        // reserve seat logo
        
        VStack {
            Button(action: reserve) { //maybe this one is navigation link on 12
                Label("", systemImage: "calendar.badge.plus")
            }
            NavigationView {
                Form {
                    TextField("Key Word:", text: $kw)
                    TextField("Distance:", text: $dist)
                    Picker("Category", selection: $selection) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    TextField("Address", text: $loc)
                    Toggle("auto detect my location", isOn: $selfLocate)
                    HStack {
                        Button(action: {
                            Task {
                                let sbc = submitContent(kw: kw, dist: dist, loc: loc, selfLocate: selfLocate, Category: selection)
                                await goSearch(suc: sbc)
                            }
                        }) {
                            Text("Submit")
                        }.buttonStyle(.bordered)
                            .tint(.blue)
                        Button(action: {
                            // Closure will be called once user taps your button
                            print("lol")
                        }) {
                            Text("Clear")
                        }.buttonStyle(.bordered)
                            .tint(.red)
                    }
                }.navigationBarTitle("Events Search")
            }
            //https://www.ralfebert.com/ios-examples/uikit/uitableviewcontroller/
            //https://developer.apple.com/documentation/swiftui/table
            //let no = 1
            //https://www.appcoda.com/swiftui-first-look/
//            UITableView tv;
//            HStack {
//                Table(searchResultTable) {
//                    //TableColumn("No", no)
//                    TableColumn("Image", value: \.imageURL)
//                    TableColumn("Business Name", value: \.name)
//                    TableColumn("Rating", value: \.rating)
//                    TableColumn("Distance", value: \.distance)
//                    //no+=1
//                }
//            }
            List(searchResultTable, id: \.name) {
                searchTableCell(es: $0)
            }
            
        }
    }
}
struct searchTableCell: View {
    let es: Event
    var body: some View{
        HStack {
            Text((es.dates.start.localDate ?? "") + "\n" + (es.dates.start.localTime ?? ""))
            AsyncImage(url: URL(string: es.images[0].url))
                .frame(width: 100, height: 100)
            Text(es.name)
            Text(es.classifications[0].segment.name)
            Text((es.embedded.venues?[0].name)!)
        }
    }
}
func goSearch(suc: submitContent) async {
    print(suc.loc, suc.dist, suc.kw, suc.Category)
    var sid = ""
    if (suc.Category == "Default"){
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
    getEventResults(url: url)
//    searchAPI.searchEvent(ss: url, completion: {
//        (searchResult) in
//        if (searchResult == nil) {
//            print("error occur when retrieve data from API")
//            return;
//        }
//        print(searchResult?.embedded.events.count)
//        for i in 0...((searchResult?.embedded.events.count)!-1) {
//            searchResultTable.append((searchResult?.embedded.events[i])!)
//        }
//
//    })
}
func reserve() {
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func getEventResults(url: String) {
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
                        print(i)
                        searchResultTable.append((searchResult.embedded.events[i] as Event))
                    }
                } catch {
                    print(error)
                }
                
            }
            
        }
        task.resume()
    }
}
