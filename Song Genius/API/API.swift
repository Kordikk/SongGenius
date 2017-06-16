//
//  API.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 15.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Endpoint {
    case getSongs(forTerm: String)
    
    var url: String {
        switch self {
        case .getSongs(let forTerm):
            let forTermTrimmed = forTerm.replacingOccurrences(of: "&", with: "")
            return forTermTrimmed.replacingOccurrences(of: " ", with: "+")
        }
    }
    
    //We'll be covering only one HTTP method but WHO KNOWS?! growth potential for the win
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getSongs:
            return .get
        }
    }
}

final class API {
    // country = pl    because we're in Poland and we want Polish market
    // limit = 100     seems reasonable
    // media = music   we obviously want music only (not musicVideos, software etc)
    // entity = song   we want songs returned (not albums, artist only etc)
    // term = ??       user's input here (with & removed and spaces changed to "&"
    
    static let baseURL = URL(string: "https://itunes.apple.com/search?country=pl&limit=100&entity=song&media=music&term=")
    
    class func request(_ endpoint: Endpoint, completion: @escaping ((Bool, JSON?) -> Void)) {
        guard let url = URL(string: endpoint.url, relativeTo: API.baseURL) else { fatalError() }
        
        switch endpoint {
        case .getSongs:
            Alamofire.request(url, method: endpoint.method).responseJSON { response in
                switch response.result {
                case .success(let value):
                    guard let json = value as? JSON
                        else { return completion(false, nil) }
                    completion(true, json)
                    
                case .failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completion(false, nil)
                }
            }
        }
    }
    
}
