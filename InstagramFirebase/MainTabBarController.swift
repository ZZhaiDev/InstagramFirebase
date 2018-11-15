//
//  MainTabBarController.swift
//  InstagramFirebase
//
//  Created by Zijia Zhai on 11/5/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ZJPrint("MainTabBarController----viewWillAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ZJPrint("MainTabBarController----viewWillDisappear")
    }
    
    deinit {
        ZJPrint("MainTabBarController----deinit")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        if index == 2{
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let nav = UINavigationController(rootViewController: photoSelectorController)
            self.present(nav, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        if Auth.auth().currentUser == nil{
            
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
                
            }
//            return
        }
        
        setupViewControllers()
        
        
    }
    
    func setupViewControllers(){
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1)
        let homeVC = UserProfileController(collectionViewLayout: layout)
        let homeNavVC = UINavigationController(rootViewController: homeVC)
        homeNavVC.tabBarItem.selectedImage = UIImage(named: "home_selected")
        homeNavVC.tabBarItem.image = UIImage(named: "home_unselected")
        
        let searchVC = UIViewController()
        let searchNavVC = UINavigationController(rootViewController: searchVC)
        searchNavVC.tabBarItem.selectedImage = UIImage(named: "search_selected")
        searchNavVC.tabBarItem.image = UIImage(named: "search_unselected")
        
        let plusVC = UIViewController()
        let plusNavVC = UINavigationController(rootViewController: plusVC)
        plusNavVC.tabBarItem.selectedImage = UIImage(named: "plus_selected")
        plusNavVC.tabBarItem.image = UIImage(named: "plus_unselected")
        
        let likeVC = UIViewController()
        likeVC.view.backgroundColor = .red
        let likeNavVc = UINavigationController(rootViewController: likeVC)
        likeNavVc.tabBarItem.image = UIImage(named: "like_unselected")
        likeNavVc.tabBarItem.selectedImage = UIImage(named: "like_selected")
        
        
        let userProfileVC = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let userProfileNavVC = UINavigationController(rootViewController: userProfileVC)
        userProfileNavVC.tabBarItem.image = UIImage(named: "profile_unselected")
        userProfileNavVC.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        
        
        viewControllers = [homeNavVC, searchNavVC, plusNavVC, likeNavVc, userProfileNavVC]
        
        guard let items = tabBar.items else{return}
        for item in items{
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        }
        
        
    }
}
