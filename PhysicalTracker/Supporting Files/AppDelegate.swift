//
//  AppDelegate.swift
//  PhysicalTracker
//
//  Created by Christophe DURAND on 06/01/2020.
//  Copyright © 2020 Christophe DURAND. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Audio-Video Session
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
        
        // First Launch Configure
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        let mainStoryboard = UIStoryboard(name: Constants.StoryboardsIdentifiers.mainStoryboardIdentifier, bundle: nil)
        
        if #available(iOS 13.0, *) {
            // In iOS 13, setup is done in SceneDelegate
        } else {
            if launchedBefore {
                print("Not first launch.")
                
                let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.ViewControllersIdentifiers.mainPageViewControllerIdentifier)
                
                self.window?.rootViewController = UINavigationController(rootViewController: initialViewController)
                self.window?.makeKeyAndVisible()
            } else {
                print("First launch, setting UserDefault.")
                
                let initialViewController = mainStoryboard.instantiateViewController(withIdentifier: Constants.ViewControllersIdentifiers.introductionViewControllerIdentifier)
                
                self.window?.rootViewController = UINavigationController(rootViewController: initialViewController)
                self.window?.makeKeyAndVisible()
                
                UserDefaults.standard.set(true, forKey: "launchedBefore")
            }
        }
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
