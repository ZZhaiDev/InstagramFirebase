//
//  SharePhotoController.swift
//  InstagramFirebase
//
//  Created by Zijia Zhai on 11/15/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage?{
        didSet{
            imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(shareButtonClicked))
        setupImagesAndTextViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImagesAndTextViews(){
        let containView = UIView()
        containView.backgroundColor = .white
        
        view.addSubview(containView)
        containView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containView.addSubview(imageView)
        imageView.anchor(top: containView.topAnchor, left: containView.leftAnchor, bottom: containView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 0)
        
        containView.addSubview(textView)
        textView.anchor(top: containView.topAnchor, left: imageView.rightAnchor, bottom: containView.bottomAnchor, right: containView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    @objc fileprivate func shareButtonClicked(){
        
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
