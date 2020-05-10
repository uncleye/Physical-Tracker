//
//  VideoViewController.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 09/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import AVKit

class VideoViewController: AVPlayerViewController {
    //MARK: - Properties
    var exerciseKey: String?
    override var prefersStatusBarHidden: Bool { return true }

    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable Idle Timer
        UIApplication.shared.isIdleTimerDisabled = true
        
        // NavigationBar setup method
        setupNavigationBarIsHidden(true, false)
        
        playVideo()
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(true)
        
         // NavigationBar setup method
         setupNavigationBarIsHidden(true, true)

     }
    
    //MARK: - Methods
    // Video setup method
    private func playVideo() {
        guard let path = Bundle.main.path(forResource: Constants.RessourcesStrings.video + (exerciseKey ?? ""), ofType: Constants.RessourcesStrings.videoWithExtensionMp4) else {
            debugPrint("Video not found!")
        
            performSegue(withIdentifier: Constants.SeguesIdentifiers.getReadySegue, sender: self)
            
            return
        }

        let player = AVPlayer(url: URL(fileURLWithPath: path))
        self.player = player
        
        self.disableGestureRecognition(view: view)

        videoViewSetup()
        
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(showExerciseVC))
        leftSwipe.direction = .left
        self.view.addGestureRecognizer(leftSwipe)
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        rightSwipe.direction = .right
        self.view.addGestureRecognizer(rightSwipe)
        
        player.play()
    }
    
    @objc private func showExerciseVC() {
        performSegue(withIdentifier: Constants.SeguesIdentifiers.getReadySegue, sender: self)
    }
    
    @objc private func dismissVC() {
        navigationController?.popViewController(animated: true)

        dismiss(animated: true, completion: nil)
    }
    
    
    private func videoViewSetup() {
        let videoView = UIView()
        
        self.view.frame.size.height = videoView.frame.size.height
        self.view.frame.size.width = videoView.frame.size.width
        self.view.addSubview(videoView)

        createSkipLabel(videoView: videoView)
    }
    
    // Skip Label setup method
    private func createSkipLabel(videoView: UIView) {
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 335, height: 21))
        
        videoView.addSubview(label)
        videoView.layer.zPosition = 1
        
        let horizontalConstraint = label.centerXAnchor.constraint(equalTo: view.trailingAnchor, constant: -50)
        let verticalConstraint = label.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -30)
        
        let attributedWithTextColor: NSAttributedString = "Passer  >>".attributedStringWithColor([">>"], color: Constants.Colors.redUIColor)

        label.textColor = .white
        label.attributedText = attributedWithTextColor
        label.font = UIFont(name: Constants.Fonts.rubikRegular, size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
                
        view.addConstraints([horizontalConstraint, verticalConstraint])
    }
    
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.SeguesIdentifiers.getReadySegue,
            let destinationVC = segue.destination as? GetReadyViewController {
            destinationVC.exerciseKey = exerciseKey
        }
    }
    
}
