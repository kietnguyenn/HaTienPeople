//
//  SceneDelegate.swift
//  HaTienPeople
//
//  Created by Apple on 10/12/20.
//

import UIKit
import GoogleMaps
import GooglePlaces


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let winScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: winScene)
//        let rootVc = MyStoryboard.main.instantiateViewController(withIdentifier: "SignInViewController")
        guard let rootVc = self.setupFirstScreen() else { return }
        window?.rootViewController = rootVc
        window?.makeKeyAndVisible()
        AppDelegate.shared.window = window

        self.setupGGMapApis()    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

extension SceneDelegate {
    func setupFirstScreen() -> UIViewController? {
        if let currentUserData = UserDefaults.standard.value(forKey: "CurrentUser") as? Data {
            guard let currentUser = try? JSONDecoder().decode(Account.self, from: currentUserData) else { return nil }
            Account.current = currentUser
//            let vc = MyStoryboard.main.instantiateViewController(withIdentifier: "EventPostingViewController") as! EventPostingViewController
//            return  BaseNavigationController(rootViewController: vc)
            return BaseTabBarController()
        } else {
            return  MyStoryboard.main.instantiateViewController(withIdentifier: "SignInViewController") as! SignInViewController
        }

    }

    func setupGGMapApis() {
        GMSServices.provideAPIKey(GMSApiKey.garageKey)
        GMSPlacesClient.provideAPIKey(GMSApiKey.garageKey)
    }
}
