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

struct ContentView: View {
    @State var kw: String = ""
    @State var dist: String = ""
    @State var loc: String = ""
    @State var selection = "Default"
    @State var selfLocate = false
    let categories = ["Default", "Arts & Entertainment", "Health & Medical", "Hotels & Travel", "Food","Professional Service"]
    private var searchResultTable = [business.self]
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
    //send url to API
    let url = URL(string: "https://reqres.in/api/cupcakes")!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
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
