//
//  AppDelegate.swift
//  ManagementApp
//
//  Created by maxim kryuchkov on 03.11.2019.
//  Copyright © 2019 maxim kryuchkov. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let coreDataStack = CoreDataStack(modelName: "ManagementApp")
    
    static var shared: AppDelegate! {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = TabBar.Router().initialViewController()
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        _ = coreDataStack.mainContext
        
        if let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as? UIView,
            statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = .black
        }
        return true
    }
    
    func applicationDidReceiveMemoryWarning(_ application: UIApplication) {
        coreDataStack.mainContext.refreshAllObjects()
    }
}
