//
//  CryptoAssetModel.swift
//  CryptoRate
//
//  Created by Андрей Важенов on 20.05.2023.
//

import Foundation


struct CryptoAsset: Codable {
    let id: String?
    let rank: String?
    let symbol: String?
    let name: String?
    let supply: String?
    let maxSupply: String?
    let marketCapUsd: String?
    let volumeUsd24Hr: String?
    let priceUsd: String?
    let changePercent24Hr: String?
    let vwap24Hr: String?
}
