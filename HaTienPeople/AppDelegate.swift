//
//  AppDelegate.swift
//  HaTienPeople
//
//  Created by Apple on 10/12/20.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow? // HERE, add it if it's not available.
    static var shared: AppDelegate { return UIApplication.shared.delegate as! AppDelegate }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setupKeyboardManager()
        self.setupGGMapApis()
        self.turnOffDarkMode()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = setupFirstScreen()
        self.window?.makeKeyAndVisible()


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
    
    func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    
    func setupFirstScreen() -> UIViewController? {
        if let currentUserData = UserDefaults.standard.value(forKey: "CurrentUser") as? Data {
            guard let currentUser = try? JSONDecoder().decode(Account.self, from: currentUserData) else { return nil }
            Account.current = currentUser
//            return  BaseNavigationController(rootViewController: vc)
            return BaseTabBarController()
        } else {
            return  MyStoryboard.main.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        }

    }
    
    func setupGGMapApis() {
        GMSServices.provideAPIKey(GMSApiKey.iosKey)
        GMSPlacesClient.provideAPIKey(GMSApiKey.iosKey)
    }
    
    func turnOffDarkMode() {
        if #available(iOS 13.0, *) {
            self.window?.overrideUserInterfaceStyle = .light
        }
    }

}

