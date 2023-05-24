

import Foundation
import Moya
import Alamofire

enum MoyaAPIService {
    case assets(offset: Int, limit: Int)
    case assetsId(id: String)
}

extension MoyaAPIService: TargetType {
    var baseURL: URL { return URL(string: "https://api.coincap.io/v2")! }

    var path: String {
        switch self {
        case .assets:
            return "/assets"
        case .assetsId(let id):
            return "/assets/\(id)"
        }
    }

    var method: Moya.Method {
        switch self {
        case .assets,
                .assetsId:
            return .get
        }
    }

    var sampleData: Data {
        return Data()
    }

    var task: Task {
        switch self {
        case let .assets(offset, limit):
                    return .requestParameters(parameters: ["offset": offset, "limit": limit], encoding: URLEncoding.default)
        case .assetsId:
                    return .requestPlain
        }
    }

    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
