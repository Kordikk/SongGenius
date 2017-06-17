//
//  SongRenderable.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 16.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Foundation
import UIKit

protocol SongRenderableType {
    var title: String { get }
    var releaseYear: String { get }
}

struct SongRenderable: SongRenderableType {
    let title: String
    let releaseYear: String
    
    init(title: String, bottomText: String) {
        self.title = title
        self.releaseYear = bottomText
    }
    
    init(song: Song) {
        self.title = song.name
        self.releaseYear = "\(song.artist) / \(song.releaseYear))"
    }
}
