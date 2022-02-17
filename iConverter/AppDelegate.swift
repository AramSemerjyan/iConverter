//
//  AppDelegate.swift
//  iConverter
//
//  Created by Aram Semerjyan on 2/15/22.
//

import UIKit
import Swinject
import SwinjectAutoregistration

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    private var parentAssembler = Assembler([
        ServiceAssembly(),
        MainAssembly()
    ])

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setUp()
        return true
    }
}

private extension AppDelegate {
    func setUp() {
        guard let window = self.window else { return }
        
        window.rootViewController = parentAssembler.resolver ~> MainViewController.self
    }
}

