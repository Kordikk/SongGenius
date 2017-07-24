//
//  StartScreenViewController.swift
//  Song Genius
//
//  Created by Kordian Ledzion on 15.06.2017.
//  Copyright © 2017 KordianLedzion. All rights reserved.
//

import Foundation
import UIKit
import Swiftstraints

class StartScreenViewController: UIViewController {
    
    private let logoImageView = UIImageView(image: UIImage(named: "logo"))
    private let iTunesButton = UIButton()
    private let localStorageButton = UIButton()
    private let betaRxButton = UIButton()
    
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
        setUpConstraints()
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
    
    private func setUpConstraints() {
        setUpLogoImageViewConstraints()
        setUpItunesButtonConstraints()
        setUpLocalStorageButtonConstraints()
        setUpBetaRxButtonConstraints()
    }
    
    private func setUpLogoImageViewConstraints() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.addConstraint((logoImageView.widthAnchor == 96))
        logoImageView.addConstraint((logoImageView.heightAnchor == 96))
        view.addConstraint((logoImageView.topAnchor == topLayoutGuide.bottomAnchor + 26))
        view.addConstraint((logoImageView.centerXAnchor == view.centerXAnchor))
    }
    
    private func setUpItunesButtonConstraints() {
        view.addSubview(iTunesButton)
        iTunesButton.setImage(UIImage(named: "iTunes"), for: .normal)
        iTunesButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint((iTunesButton.topAnchor == topLayoutGuide.bottomAnchor + 50))
        view.addConstraint((iTunesButton.trailingAnchor == logoImageView.leadingAnchor - 32))
    }
    
    private func setUpLocalStorageButtonConstraints() {
        view.addSubview(localStorageButton)
        localStorageButton.setImage(UIImage(named: "localStorage"), for: .normal)
        localStorageButton.addTarget(self, action: #selector(presentLocalStorageViewController), for: .touchUpInside)
        localStorageButton.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraint((localStorageButton.topAnchor == topLayoutGuide.bottomAnchor + 50))
        view.addConstraint((localStorageButton.leadingAnchor == logoImageView.trailingAnchor + 32))
    }
    
    private func setUpBetaRxButtonConstraints() {
        betaRxButton.setTitle("betaRx", for: .normal)
        betaRxButton.titleLabel!.adjustsFontSizeToFitWidth = true
        view.addSubview(betaRxButton)
        betaRxButton.translatesAutoresizingMaskIntoConstraints = false
        betaRxButton.addConstraint(betaRxButton.widthAnchor == 33)
        betaRxButton.addConstraint((betaRxButton.heightAnchor == 11))
        view.addConstraint((betaRxButton.trailingAnchor == view.trailingAnchor - 16))
        view.addConstraint((betaRxButton.bottomAnchor == bottomLayoutGuide.topAnchor - 20))
    }
    
    @objc private func presentBetaRxViewController() {
        Sound.play(file: "xfiles.mp3")
        present(ITunesSongsViewController(), animated: true, completion: nil)
    }
    
    private func presentITunesViewController() {
        present(NoRxITunesViewController(), animated: true, completion: nil)
    }
    
    @objc private func presentLocalStorageViewController() {
        present(LocalSongsViewController(), animated: true, completion: nil)
    }

}
