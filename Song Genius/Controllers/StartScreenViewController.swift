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
    
    private let logoImageView = UIImageView(image: UIImage(named: "logo"))
    private let iTunesButton = UIButton()
    private let localStorageButton = UIButton()
    
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
    
    private func setUpConstraints() {
        setUpLogoImageViewConstraints()
        setUpItunesButtonConstraints()
        setUpLocalStorageButtonConstraints()
    }
    
    private func setUpLogoImageViewConstraints() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.widthAnchor.constraint(equalToConstant: 96).isActive = true
        logoImageView.heightAnchor.constraint(equalToConstant: 96).isActive = true
        logoImageView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 26).isActive = true
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    private func setUpItunesButtonConstraints() {
        view.addSubview(iTunesButton)
        iTunesButton.addTarget(self, action: #selector(presentITunesSongsViewController(_:)), for: .touchUpInside)
        iTunesButton.setImage(UIImage(named: "iTunes"), for: .normal)
        iTunesButton.translatesAutoresizingMaskIntoConstraints = false
        iTunesButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 50).isActive = true
        iTunesButton.trailingAnchor.constraint(equalTo: logoImageView.leadingAnchor, constant: -32).isActive = true
    }
    
    private func setUpLocalStorageButtonConstraints() {
        view.addSubview(localStorageButton)
        localStorageButton.setImage(UIImage(named: "localStorage"), for: .normal)
        localStorageButton.addTarget(self, action: #selector(presentLocalStorageViewController), for: .touchUpInside)
        localStorageButton.translatesAutoresizingMaskIntoConstraints = false
        localStorageButton.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 50).isActive = true
        localStorageButton.leadingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 32).isActive = true
    }
    
    private func presentITunesViewController() {
        present(NoRxITunesViewController(), animated: true, completion: nil)
    }
    
    func presentLocalStorageViewController() {
        let vc = LocalSongsViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }
    
    func presentITunesSongsViewController(_ sender: Any) {
        let vc = NoRxITunesViewController()
        let nc = UINavigationController(rootViewController: vc)
        present(nc, animated: true, completion: nil)
    }

}
