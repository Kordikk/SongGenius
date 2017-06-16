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
    var bottomText: String { get }
    var image: UIImage { get }
}

struct SongRenderable: SongRenderableType {
    let title: String
    let bottomText: String
    let image: UIImage
    
    init(title: String, bottomText: String, image: UIImage = UIImage()) {
        self.title = title
        self.bottomText = bottomText
        self.image = image
    }
    
    init(song: Song, image: UIImage = UIImage()) {
        self.title = song.name
        self.bottomText = "\(song.artist) / \(song.releaseYear))"
        self.image = image
    }
}
