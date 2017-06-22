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
import RxCocoa
import RxSwift

enum Endpoint {
    case getSongs(forTerm: String)
    
    var url: String {
        switch self {
        case .getSongs(let forTerm):
            var forTermTrimmed = forTerm.replacingOccurrences(of: "&", with: "")
            forTermTrimmed = forTermTrimmed.replacingOccurrences(of: "'", with: "")
            forTermTrimmed = forTermTrimmed.replacingOccurrences(of: "!", with: "")
            forTermTrimmed = forTermTrimmed.replacingOccurrences(of: "-", with: "")
            forTermTrimmed = forTermTrimmed.replacingOccurrences(of: "/", with: "")
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

class API {
    // country = pl    because we're in Poland and we want Polish market
    // limit = 50     seems reasonable
    // media = music   we obviously want music only (not musicVideos, software etc)
    // entity = song   we want songs returned (not albums, artist only etc)
    // term = ??       user's input here (with & removed and spaces changed to "&"
    
    static let baseURL = URL(string: "https://itunes.apple.com/search?country=pl&limit=100&entity=song&media=music&term=")
    
    func request(_ endpoint: Endpoint, completion: @escaping ((Bool, [Song]?) -> Void)) -> DataRequest {
        let url = URL(string: "https://itunes.apple.com/search?country=pl&limit=50&entity=song&media=music&term=\(endpoint.url)")!
        print("request for \(url)")
        switch endpoint {
        case .getSongs:
            let request = Alamofire.request(url, method: endpoint.method)
            request.responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON.init(value)
                    var ret = [Song]()
                    print(json)
                    if(json["resultCount"].int! > 0) {
                        for songJSON in json["results"].array! {
                            let artist = songJSON["artistName"].string!
                            let name = songJSON["trackName"].string!
                            let releaseDate = songJSON["releaseDate"].string!
                            let strIndex = releaseDate.index(releaseDate.startIndex, offsetBy: 4)
                            let releaseYear = releaseDate.substring(to: strIndex)
                            let url = (songJSON["trackViewUrl"].string!).replacingOccurrences(of: "\\", with: "")
                            ret.append(Song(name: name, artist: artist, releaseYear: releaseYear, url: url))
                        }
                    }
                    completion(true, ret)
                    
                case .failure(let error):
                    print("ERROR: \(error.localizedDescription)")
                    completion(false, nil)
                }
            }
            return request
        }
    }
    
}

extension API: ReactiveCompatible {}

extension Reactive where Base: API {
    func request(_ endpoint: Endpoint) -> Observable<[Song]> {
        return Observable.create { observer in
            let request = self.base.request( endpoint, completion: { success, songs in
                if(success) {
                    observer.onNext(songs!)
                } else {
                    observer.onNext([Song]())
                }
            })
            return Disposables.create {
                request.cancel()
            }
            }.observeOn(MainScheduler.instance)
    }
}
