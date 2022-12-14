//
//  AppDelegate.swift
//  Garage
//
//  Created by Amjad Ali on 6/10/18.
//  Copyright © 2018 Amjad Ali. All rights reserved.
//

import UIKit

@UIApplicationMain
  class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
     var navigationVC: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        UIApplication.shared.statusBarStyle = .lightContent
       RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.5))
        showDashboard()
       
        // Override point for customization after application launch.
//        window = UIWindow()
//        window?.makeKeyAndVisible()
//        let navController = UINavigationController(rootViewController: WelcomeView())
//        window?.rootViewController = navController
        
        //Loader.loadLoader()
        return true
    }
    
    
   
    
     func showDashboard() {
        
        
       
        // Setting kitchen and checkout printers
        PrintJobHelper.setPrinters()
        
        // Setting receipt configuration in model
        PrintJobHelper.setReceiptConfigurationModel()
        
    }
    
    func showDash() {
    let storyboard = UIStoryboard(name: "CheckoutView", bundle: nil)
    let rootController = storyboard.instantiateViewController(withIdentifier: "CheckoutVc") as! CheckoutView
    
    navigationVC = UINavigationController(rootViewController: rootController)
    rootController.navigationController?.isNavigationBarHidden = true
    
    if let window = self.window {
        window.rootViewController = navigationVC
        window.makeKeyAndVisible()
    }
    }
    
    
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

