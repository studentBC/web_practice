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
private var searchResultTable: [business] = []
struct ContentView: View {
    @State var kw: String = ""
    @State var dist: String = ""
    @State var loc: String = ""
    @State var selection = "Default"
    @State var selfLocate = false
    let categories = ["Default", "Arts & Entertainment", "Health & Medical", "Hotels & Travel", "Food","Professional Service"]
    var body: some View {
        // A cell that, when selected, adds a new folder.
        // reserve seat logo
        
        ZStack {
            Button(action: reserve) {
                Label("", systemImage: "calendar.badge.plus")
            }
            NavigationView {
                Form {
                    TextField("key word:", text: $kw)
                    TextField("Distance:", text: $dist)
                    Picker("Category", selection: $selection) {
                        ForEach(categories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    TextField("Address", text: $loc)
                    Toggle("auto detect my location", isOn: $selfLocate)

                    if selfLocate {
                        Text("Hello World!")
                    }
                    HStack {
                        Button(action: {
                            Task {
                                var sbc = submitContent(kw: kw, dist: dist, loc: loc, selfLocate: selfLocate, Category: selection)
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
                }.navigationBarTitle("Business Search")
            }
            
            //https://www.ralfebert.com/ios-examples/uikit/uitableviewcontroller/
            //https://developer.apple.com/documentation/swiftui/table
            let no = 1
//            Table(searchResultTable) {
//                TableColumn("No", no)
//                TableColumn("Image", value: \.imageURL)
//                TableColumn("Business Name", value: \.name)
//                TableColumn("Rating", value: \.rating)
//                TableColumn("Distance", value: \.distance)
//                no+=1
//            }
            
        }
    }
}
func goSearch(suc: submitContent) async {
    print(suc.loc, suc.dist, suc.kw, suc.Category)
    let key = "Bearer 14KXrZ0B_akWx-QGszPZVHBNMj2PKWHxd5FMjNVDHQ5Re_fY1fnJWcSijh66KHdu0Zon6yxIyGXiauJvKaTO29TGAcQJ4TzAYwBXMhvzPnqcIltOaIQxQdwSnge7Y3Yx"
    //send url to API
//    let url = URL(string: "https://reqres.in/api/cupcakes")!
//    var request = URLRequest(url: url)

    let request = NSMutableURLRequest(url: URL(string: "'https://api.yelp.com/v3/businesses/search?limit=50&term=\(suc.kw)&location=\(suc.loc)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!)
    request.setValue(key, forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "GET"
    // fetch data
    URLSession.shared.dataTask(with: request as URLRequest) { (data, response, error) in
        guard let httpResponse = response as? HTTPURLResponse else { return }
        
        if httpResponse.statusCode == 200 {
            // Http success
            do {
                // save json as an object
                let jobj = try JSONDecoder().decode(bEntity.self , from: data!)
//                var name: String = ""
//                var rating: String = ""
//                var id: String = ""
//                var imageURL: String = ""
//                var distance: String = ""

                for bn in jobj.businesses {
                    let tmp = business()
                    tmp.id = bn.id
                    tmp.imageURL = bn.imageURL
                    tmp.distance = String(format: "%.1f", bn.distance)
                    tmp.rating = String(format: "%.1f", bn.rating)
                    searchResultTable.append(tmp)
                }
//
//                DispatchQueue.main.async {
//                    self.autoSuggestTableViewController.tableView.reloadData()
//                }

                
            } catch DecodingError.dataCorrupted(let context) {
                print(context.debugDescription)
            } catch DecodingError.keyNotFound(let key, let context) {
                print("\(key.stringValue) was not found, \(context.debugDescription)")
            } catch DecodingError.typeMismatch(let type, let context) {
                print("\(type) was expected, \(context.debugDescription)")
            } catch DecodingError.valueNotFound(let type, let context) {
                print("no value was found for \(type), \(context.debugDescription)")
            } catch let error {
                print(error)
            }
        } else {
            // Http error
        }
        
    }.resume()
}
func reserve() {
    
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
//extension ContentView: modelDelegate {
//
//    func didGetURL(url: String) {
//
//        DispatchQueue.main.async {
//
//        }
//    }
//
//    func didFailWithError(error: Error) {
//        print(error)
//    }
//}
