//
//  ITunesSongCell.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 17.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Foundation
import UIKit

protocol SongCellRendering {
    func render(songRenderable renderable: SongRenderableType)
}

class ITunesSongsCell: UITableViewCell, SongCellRendering {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var releaseYear: UILabel!
    
    func render(songRenderable renderable: SongRenderableType) {
        title.text = renderable.title
        releaseYear.text = renderable.releaseYear
    }
    
}
