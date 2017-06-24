//
//  SongsManager.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 24.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

enum Sorting {
    case byNameAscending
    case byNameDescending
    case byArtistAscending
    case byArtistDescending
    case byReleaseYearAscending
    case byReleaseYearDescending
}

final class SongsManager {
    
    private let base = DataAccess.access.getSongs()

    private var songs = [Song]()
    
    public func removeAll() {
        songs.removeAll()
    }
    
    public func loadSongsFromLocal() {
        songs = base
    }
    
    public func sort(_ by: Sorting) {
        switch by {
        case .byNameAscending:
            songs.sort {
                $0.name.lowercased() < $1.name.lowercased()
            }
            break
        case .byNameDescending:
            songs.sort {
                $0.name.lowercased() > $1.name.lowercased()
            }
            break
        case .byArtistAscending:
            songs.sort {
                $0.artist.lowercased() < $1.artist.lowercased()
            }
            break
        case .byArtistDescending:
            songs.sort {
                $0.artist.lowercased() > $1.artist.lowercased()
            }
            break
        case .byReleaseYearAscending:
            songs.sort {
                $0.releaseYear < $1.releaseYear
            }
            break
        case .byReleaseYearDescending:
            songs.sort {
                $0.releaseYear > $1.releaseYear
            }
            break
        }
    }
    
    public func setSongs(_ forTerm: String) { //search "engine"
        songs = base
        if(forTerm != "") {
            songs = songs.filter { (song: Song) -> Bool in
                let term = clearText(forTerm).lowercased()
                let isNameMatching = clearText(song.name).lowercased().contains(term.lowercased())
                let isArtistMatching = clearText(song.artist).lowercased().contains(term.lowercased())
                let isReleaseYearMatching = clearText(song.releaseYear).contains(term)
                return isNameMatching || isArtistMatching || isReleaseYearMatching
            }
        }
    }
    
    public func setSongsFromITunes(_ forTerm: String, completion: @escaping ((Bool) -> Void)) {
        removeAll()
        let keyword = clearText(forTerm)
        
        _ = API.request(.getSongs(forTerm: keyword)){ success, songs in
            if(success) {
                for song in songs! {
                    self.songs.append(song)
                }
            }
            completion(success)
        }
    }
    
    fileprivate func clearText(_ string: String) -> String {
        var ret = string.replacingOccurrences(of: "'", with: "")
        ret = ret.replacingOccurrences(of: "/", with: "")
        ret = ret.replacingOccurrences(of: "!", with: "")
        ret = ret.replacingOccurrences(of: "-", with: "")
        ret = ret.replacingOccurrences(of: "&", with: "")
        return ret
    }
    
    public func getSong(_ on: Int) -> Song {
        return Song(song: songs[on])
    }
    
    public func getCount() -> Int {
        return songs.count
    }
    
}

