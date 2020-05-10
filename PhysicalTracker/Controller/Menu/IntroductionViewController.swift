//
//  IntroductionViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 13/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import AVFoundation

class IntroductionViewController: UIViewController {
    //MARK: - Properties
    override var prefersStatusBarHidden: Bool { return true }
  
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Idle Timer
        UIApplication.shared.isIdleTimerDisabled = true
        
        // NavigationBar setup method
        setupNavigationBarIsHidden(true, false)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)

        // AVPlayer setup method
        setupAVPlayer()
        
    }
    
    //MARK: - Methods
    private func createSkipButton() {
        let skipButton = UIButton(frame: CGRect(x: 320, y: 820, width: 63, height: 33))
        
        self.view.addSubview(skipButton)
        
        let horizontalConstraint = skipButton.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -45)
        let verticalConstraint = skipButton.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -45)
        
        skipButton.titleLabel?.textColor = .white
        skipButton.titleLabel?.font = UIFont(name: Constants.Fonts.rubikLight, size: 17)
        skipButton.setTitle(Constants.Labels.skipTitleButton, for: .normal)
        
        skipButton.addTarget(self, action: #selector(setupSkipIntroductionVideo), for: .touchUpInside)
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([horizontalConstraint, verticalConstraint])
    }
    
    @objc private func setupSkipIntroductionVideo() {
        let storyboard = UIStoryboard(name: Constants.StoryboardsIdentifiers.mainStoryboardIdentifier, bundle: nil)
        let introductionVCisFirstLaunched = UserDefaults.standard.bool(forKey: Constants.RessourcesStrings.introVCisFirstLaunched)

        if #available(iOS 13.0, *) {
            let mainPageVC = storyboard.instantiateViewController(identifier: Constants.ViewControllersIdentifiers.mainPageViewControllerIdentifier)

            if introductionVCisFirstLaunched {
                navigationController?.popToRootViewController(animated: true)

            } else {
                navigationController?.pushViewController(mainPageVC, animated: true)
                navigationController?.viewControllers.remove(at: 0)

                UserDefaults.standard.set(true, forKey: Constants.RessourcesStrings.introVCisFirstLaunched)
            }
            
            if navigationController?.viewControllers.count == 3 {
                navigationController?.viewControllers.remove(at: 1)
            }
            
        } else {
            if introductionVCisFirstLaunched {
                navigationController?.popToRootViewController(animated: true)

            } else {
                performSegue(withIdentifier: Constants.SeguesIdentifiers.mainPageSegue, sender: self)
                navigationController?.viewControllers.remove(at: 0)
                
                UserDefaults.standard.set(true, forKey: Constants.RessourcesStrings.introVCisFirstLaunched)
            }
            
            if navigationController?.viewControllers.count == 3 {
                navigationController?.viewControllers.remove(at: 1)
            }
        }
    }

    private func setupAVPlayer() {
        let videoURL = Bundle.main.url(forResource: Constants.Videos.videoInterview, withExtension: Constants.RessourcesStrings.videoWithExtensionMp4) // Get video url
        let avAssets = AVAsset(url: videoURL!) // Create assets to get duration of video.
        let avPlayer = AVPlayer(url: videoURL!) // Create avPlayer instance
        let avPlayerLayer = AVPlayerLayer(player: avPlayer) // Create avPlayerLayer instance
        
        avPlayerLayer.frame = self.view.bounds // Set bounds of avPlayerLayer
        
        self.view.layer.addSublayer(avPlayerLayer) // Add avPlayerLayer to view's layer.
        
        createSkipButton()
        
        avPlayer.play() // Play video
        
        // Add observer for every second to check video completed or not,
        // If video play is completed then redirect to desire view controller.
        avPlayer.addPeriodicTimeObserver(forInterval: CMTime(seconds: 1, preferredTimescale: 1) , queue: .main) { [weak self] time in
            
            if time == avAssets.duration {
                let mainStoryboard = UIStoryboard(name: Constants.StoryboardsIdentifiers.mainStoryboardIdentifier, bundle: nil)
                
                if #available(iOS 13.0, *) {
                    let mainPageVC = mainStoryboard.instantiateViewController(identifier: Constants.ViewControllersIdentifiers.mainPageViewControllerIdentifier)
                    
                    if UserDefaults.standard.bool(forKey: Constants.RessourcesStrings.launchedBefore) == true {
                        self?.navigationController?.pushViewController(mainPageVC, animated: true)
                        self?.navigationController?.viewControllers.remove(at: 0)
                    }
                    
                    if self?.navigationController?.viewControllers.count == 3 {
                        self?.navigationController?.viewControllers.remove(at: 1)
                    }
                    
                } else {
                    if UserDefaults.standard.bool(forKey: Constants.RessourcesStrings.launchedBefore) == true {
                        self?.performSegue(withIdentifier: Constants.SeguesIdentifiers.mainPageSegue, sender: self)
                        self?.navigationController?.viewControllers.remove(at: 0)
                    }
                    
                    if self?.navigationController?.viewControllers.count == 3 {
                        self?.navigationController?.viewControllers.remove(at: 1)
                    }
                }
            }
        }
    }
    
}
