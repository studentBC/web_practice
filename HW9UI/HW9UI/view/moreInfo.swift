//
//  moreInfo.swift
//  HW9UI
//
//  Created by Chin Lung on 1/31/23.
//

import SwiftUI
//struct moreInfoPreviews: PreviewProvider {
//    static var previews: some View {
//        moreInfo(event: <#T##Event#>)
//    }
//}

struct moreInfo: View {
    let event : Event
//    @ObservedObject private var getVenue = apiSearchVenue()
    @State private var getVenue = apiSearchVenue()
    
    var body: some View {
        VStack {
            Text((event.venue ?? "lol"))
            HStack {
                VStack(alignment: .leading) {
                    Text("Date").aspectRatio(contentMode: .fit)
                    Text(event.date ?? "?"+" " + (event.time ?? "")).multilineTextAlignment(.leading).aspectRatio(contentMode: .fit)
                    Text("Artist/Team").aspectRatio(contentMode: .fit).multilineTextAlignment(.leading)
                    //we need to change venue json obj to get the link ...
                    //Text("[\(event.embedded.attractions[0]?.name)](\())")
                    Text("Genres").aspectRatio(contentMode: .fit).multilineTextAlignment(.leading)
                    Text(event.genre).aspectRatio(contentMode: .fit).multilineTextAlignment(.leading)
                    Text("Price Ranges").aspectRatio(contentMode: .fit).multilineTextAlignment(.leading)
                    Text("\(event.pMin)-\(event.pMax) \(event.currency)").aspectRatio(contentMode: .fit).multilineTextAlignment(.leading)
                    Group {
                        Text("Ticket Status")
                        if (event.ticketStatus == "onsale") {
                            Text("On Sale").padding(5).cornerRadius(8).backgroundStyle(.red)
                        } else if (event.ticketStatus == "offsale") {
                            Text("Off Sale").padding(5).cornerRadius(8).backgroundStyle(.green)
                        } else {
                            Text("Rescheduled").padding(5).cornerRadius(8).backgroundStyle(.yellow)
                        }
                    }.aspectRatio(contentMode: .fit).multilineTextAlignment(.leading)
                    Text("Buy TicketAt:").aspectRatio(contentMode: .fit).multilineTextAlignment(.leading)
                    //Link("Ticketmaster", destination: URL(string: event.url)!)
                    Text(.init("[Ticketmaster](\(event.buyTicketURL))")).aspectRatio(contentMode: .fit).multilineTextAlignment(.leading)
                    
                    
                    //                    Text("Ticketmaster").onTapGesture {
                    //                        UIApplication.shared.open(URL(string: event.url)!)
                    //                    }
                }
                AsyncImage(url: URL(string: event.seatmap ?? ""),
                           content: {
                    image in image.resizable().aspectRatio(contentMode: .fit)
                },
                           placeholder: {
                    ProgressView()
                })
            }
        }.onAppear(perform: self.lol)
    }
    func lol() {
        print("=== enter  \(event.name) ===")
        getVenue.goSearch(eve: event)
        //print(getVenue.venueDetail?.name)
        print("------------------------")
    }
}

