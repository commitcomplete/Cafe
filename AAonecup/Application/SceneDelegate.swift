//
//  SceneDelegate.swift
//  AAonecup
//
//  Created by dohankim on 2022/09/20.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        let mainViewController = FindCafeViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {

    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
      
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
       
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        // MARK: to do
        // 나중에 앱 껐다가 다시들어와서 검색하는 버그 방지
        //UserDefaults.standard.set(Date(), forKey: "nowDate")
        
    }
    
    
}

