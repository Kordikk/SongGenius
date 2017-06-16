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
        let pastelView = PastelView(frame: view.bounds)
        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        pastelView.animationDuration = 1.0
        pastelView.setColors(PastelGradient.youngPassion.colors())
        pastelView.startAnimation()
        view.insertSubview(pastelView, at: 0)
    }
    
    @IBAction func goToLocalSongsButton(_ sender: Any) {
        performSegue(withIdentifier: "showLocalSongsViewController", sender: sender)
    }
    
    @IBAction func goToITunesSongsButton(_ sender: Any) {
        performSegue(withIdentifier: "showITunesSongsViewController", sender: sender)
    }

}
