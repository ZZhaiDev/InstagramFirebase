//
//  HomeController.swift
//  InstagramFirebase
//
//  Created by Zijia Zhai on 12/4/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    fileprivate let cellId = "cellId"
    fileprivate var posts = [Post]()
    
    deinit {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        collectionView.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        fetchAllPosts()
    }
}


// MARK:- functions
extension HomeController{
    
    fileprivate func setupUI(){
        collectionView.backgroundColor = .white
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        setupNavigationItems()
    }
    
    fileprivate func setupNavigationItems(){
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "camera3"), style: .plain, target: self, action: #selector(handleCamera))
    }
    
    @objc func handleCamera() {
        print("Showing camera")
        
        let cameraController = UIViewController()
        present(cameraController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleUpdateFeed() {
        handleRefresh()
    }
    
    @objc fileprivate func handleRefresh() {
        print("Handling refresh..")
        posts.removeAll()
        fetchAllPosts()
    }
}


// MARK:- firebase call
extension HomeController{
    fileprivate func fetchAllPosts() {
        fetchPosts()
//        fetchFollowingUserIds()
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid) { (user) in
            self.fetchPostsWithUser(user: user)
            
        }
    }
    
    fileprivate func fetchPostsWithUser(user: User){
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionaryies = snapshot.value as? [String: Any] else { return }
            dictionaryies.forEach({ (arg0) in
                let (_, value) = arg0
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            })
            self.posts.sort(by: { (p1, p2) -> Bool in
                return p1.creationDate.compare(p2.creationDate) == .orderedDescending
            })
            
            self.collectionView.reloadData()
            self.collectionView.refreshControl?.endRefreshing()
        }
    }
}


// MARK:- datasource
extension HomeController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        //        cell.backgroundColor = .yellow
        cell.post = posts[indexPath.item]
        return cell
    }
}


// MARK:- delegate
extension HomeController{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 40 + 8 + 8 //username userprofileimageview
        height += view.frame.width
        height += 50
        height += 60
        return CGSize(width: view.frame.width, height: height)
    }
}
