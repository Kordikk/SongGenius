//
//  StartScreenViewController.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 15.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Foundation
import UIKit

class StartScreenViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let pastelView = PastelView(frame: CGRect(x: 0, y: 0, width: 800, height: 800))
        view.insertSubview(pastelView, at: 0)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 1.0
        pastelView.setColors([
            UIColor(red: 248/255, green: 187/255, blue: 208/255, alpha: 1.0),
            UIColor(red: 244/255, green: 143/255, blue: 177/255, alpha: 1.0),
            UIColor(red: 240/255, green: 98/255, blue: 146/255, alpha: 1.0),
            UIColor(red: 236/255, green: 64/255, blue: 122/255, alpha: 1.0),
            UIColor(red: 240/255, green: 98/255, blue: 146/255, alpha: 1.0),
            UIColor(red: 244/255, green: 143/255, blue: 177/255, alpha: 1.0)
            ])
        pastelView.startAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        (view.subviews[0] as! PastelView).startAnimation()
    }
    

    @IBAction func goToLocalSongsButton(_ sender: Any) {
        performSegue(withIdentifier: "showLocalSongsViewController", sender: sender)
    }
    
    @IBAction func goToITunesSongsButton(_ sender: Any) {
        Sound.play(file: "xfiles.mp3")
        performSegue(withIdentifier: "showITunesSongsViewController", sender: sender)
    }
    
    @IBAction func showNoRxITunesViewController(_ sender: Any) {
        performSegue(withIdentifier: "showNoRxITunesViewController", sender: sender)
    }

}
