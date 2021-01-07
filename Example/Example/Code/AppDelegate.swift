//
//  AppDelegate.swift
//  Example
//
//  Created by viktor.volkov on 25.12.2019.
//  Copyright © 2019 viktor.volkov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let presenter = EntitiesPresenter()
        let vc = ScheduleViewController()
        vc.title = "Entities"
        vc.output = presenter
        presenter.view = vc
        window?.rootViewController = UINavigationController(rootViewController: vc)
        window?.makeKeyAndVisible()
        return true
    }
}

