

import UIKit

class CryptoViewModel: NSObject {
    
    let crypto = CryptoRateGet()
    var filteredAssets = [CryptoAsset]()
    var cryptoRait: [CryptoAsset] = []
    var page = 1
    var limit = 10
    var checkPrice: Bool = false
    var isFetching = false
    var isLoading = false
    
    override init() {
        super.init()
    }
    
    func fetchCrypto(tableView: UITableView) {
        guard !isFetching else { return }
        let offset = (page - 1) * 10
        isFetching = true
        crypto.fetchAssets(offset: offset, limit: limit) { [weak self] result, error in
            self?.isFetching = false
            self?.cryptoRait += result?.data ?? [CryptoAsset]()
            self?.page += 1
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            if (error != nil) == true {
               
            }
        }
    }
    
    func fetchAllAssets(tableView: UITableView) {
        guard !isLoading else { return }
           isLoading = true
        crypto.fetchAssets(offset: 1, limit: 100) { [weak self] result, error in
            self?.isLoading = false
            self?.isFetching = false
            self?.cryptoRait += result?.data ?? [CryptoAsset]()
            
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
        self.cryptoRait = []
    }
    
    func searchAsset(id: String, tableView: UITableView) {
        crypto.searchAssets(id: id) { [weak self] result, error in
            self?.cryptoRait.append(contentsOf: result?.data ?? [CryptoAsset]())
            self?.filteredAssets = self?.cryptoRait ?? [CryptoAsset]()
            DispatchQueue.main.async {
                tableView.reloadData()
            }
        }
    }
    
    func formatNumberWithCommas(number: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: number)) else {return ""}
        return "\(formattedNumber)"
    }
    
    func percentSum(sum: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let percent = sum / 1000000000
        guard let formattedNumber = numberFormatter.string(from: NSNumber(value: percent)) else {return ""}
        return "\(formattedNumber)"
    }
    
    func displayNetworkErrorAlert(on viewController: UIViewController, message: String) {
        let alertController = UIAlertController(title: "Network Error",
                                                message: message,
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
        
        }
        alertController.addAction(retryAction)
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
