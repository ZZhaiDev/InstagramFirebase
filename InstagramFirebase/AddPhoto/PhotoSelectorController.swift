//
//  PhotoSelectorController.swift
//  InstagramFirebase
//
//  Created by Zijia Zhai on 11/15/18.
//  Copyright © 2018 cognitiveAI. All rights reserved.
//

import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var selectedImage: UIImage?
    var images = [UIImage]()
    var assets = [PHAsset]()
    var permissionStatus: Bool?
    
    lazy var warningLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enable Photo"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        label.backgroundColor = .red
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationButtons()
        
        collectionView.backgroundColor = .white
        collectionView.register(PhoteSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(PhotoSelectorHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkPhotoStatus()
    }
    
    fileprivate func warningUI(){
        DispatchQueue.main.async {
            let bgView = UIView()
            bgView.backgroundColor = .white
            self.collectionView.addSubview(bgView)
            self.collectionView.bringSubviewToFront(bgView)
            bgView.anchor(top: self.collectionView.topAnchor, left: self.collectionView.leftAnchor, bottom: self.collectionView.bottomAnchor, right: self.collectionView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            bgView.addSubview(self.warningLabel)
            self.warningLabel.centerXAnchor.constraint(equalTo: self.collectionView.centerXAnchor).isActive = true
            self.warningLabel.anchor(top: self.collectionView.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 100, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 0)
        }
        
    }
    
    fileprivate func checkPhotoStatus(){
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized){
            permissionStatus = true
            fetchPhotos()
        }else if status == PHAuthorizationStatus.denied{
            print("permission deny")
            permissionStatus = false
            warningUI()
        }else if status == PHAuthorizationStatus.notDetermined{
            PHPhotoLibrary.requestAuthorization { (newStatus) in
                if newStatus == PHAuthorizationStatus.authorized{
                    self.permissionStatus = true
                    self.fetchPhotos()
                }else{
                    self.permissionStatus = false
                    self.warningUI()
                }
            }
        }
    }
    
    
    fileprivate func fetchPhotos(){
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptor]
        let allPhotes = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        DispatchQueue.global(qos: .background).async {
            allPhotes.enumerateObjects { (asset, count, stop) in
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: nil, resultHandler: { (image, info) in
                    if let image = image{
                        self.images.append(image)
                        self.assets.append(asset)
                        if self.selectedImage == nil{
                            self.selectedImage = image
                        }
                    }
                    if count == allPhotes.count - 1{
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                        
                    }
                })
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedImage = images[indexPath.item]
        self.collectionView.reloadData()
        
        let indexpath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexpath, at: .bottom, animated: true)
        print(selectedImage)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    var selectedheader: PhotoSelectorHeader?
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeader
        //        header.photeImageView.image = self.selectedImage
        selectedheader = header
        //load large image
        if let selectedImage = selectedImage{
            if let index = self.images.index(of: selectedImage){
                let selectedAsset = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    header.photeImageView.image = image
                }
            }
        }
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width - 3)/4
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhoteSelectorCell
        cell.photeImageView.image = images[indexPath.item]
        //        cell.backgroundColor = .red
        return cell
    }
    
    fileprivate func setUpNavigationButtons(){
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonClicked))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextButtonClicked))
    }
    
    @objc fileprivate func nextButtonClicked(){
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = self.selectedheader?.photeImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
    @objc fileprivate func cancelButtonClicked(){
        self.dismiss(animated: true, completion: nil)
    }
}
