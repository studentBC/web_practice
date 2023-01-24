//
//  model.swift
//  HW9UI
//
//  Created by Chin Lung on 1/22/23.
//

import Foundation

struct model {
    //var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "YOUR_API_KEY_HERE"

//    protocol modelDelegate {
//        func didGetURL(url: String)
//        func didFailWithError(error: Error)
//    }
    func get(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    //self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let bitcoinPrice = self.parseJSON(safeData) {
                        let priceString = String(format: "%.2f", bitcoinPrice)
                        //self.delegate?.didUpdatePrice(price: priceString, currency: currency)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            //let decodedData = try decoder.decode(CoinData.self, from: data)
            //let lastPrice = decodedData.rate
            //print(lastPrice)
            //return lastPrice
            return nil
            
        } catch {
            //delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
