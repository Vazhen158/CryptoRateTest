

import Foundation
import Moya
import UIKit

class CryptoRateGet {
    weak var viewController: CryptocurrencyExchangeRateViewController?
    let provider = MoyaProvider<MoyaAPIService>()
     struct Returned: Codable {
        var data: [CryptoAsset]
    }
    var coinArray: [CryptoAsset] = []

    func fetchAssets(offset: Int, limit: Int, completion: @escaping (Returned?, Error?) -> Void) {
        provider.request(.assets(offset: offset, limit: limit)) { result in
            switch result {
            case let .success(response):
                do {
                    let results = try JSONDecoder().decode(Returned.self, from: response.data)
                    completion(results, nil)
                } catch let error {
                    print("Failed to decode JSON in fetchAssets: \(error)")
                    self.showError(message: "Failed to decode JSON in fetchAssets: \(error)")
                    completion(nil, error)
                }
            case let .failure(error):
                print("Error: \(error)")
                self.showError(message: "Failed to decode JSON in fetchAssets: \(error)")
                completion(nil, error)
            }
        }
    }
    
    func searchAssets(id: String, completion: @escaping (Returned?, Error?) -> Void)  {
        provider.request(.assetsId(id: id)) { result in
                       switch result {
                       case let .success(response):
                           do {
                               let results = try JSONDecoder().decode(Returned.self, from: response.data)
                               completion(results, nil)
                           } catch let error {
                               print("Failed to decode JSON in fetchAssets: \(error)")
                            self.showError(message: "Failed to decode JSON in fetchAssets: \(error)")
                               completion(nil, error)
                           }
                           
                       case let .failure(error):
                           print(error)
                           self.showError(message: "Failed to decode JSON in fetchAssets: \(error)")
                           completion(nil, error)
                       }
                   }
    }
    
    func showError(message: String) {
           DispatchQueue.main.async {
               let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
               let action = UIAlertAction(title: "OK", style: .default, handler: nil)
               alert.addAction(action)
               self.viewController?.present(alert, animated: true, completion: nil)
           }
       }
    
}
