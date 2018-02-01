//
//  AppDelegate.swift
//  Todoey
//
//  Created by ASJ on 2018. 1. 20..
//  Copyright © 2018년 ASJ. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // print("ASJ \(Realm.Configuration.defaultConfiguration.fileURL)")
        
        do {
            
            let realm = try Realm()
        }
        catch {
            
            print("Error loading Realm, \(error)")
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
        print("application did enter background.")
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

}
