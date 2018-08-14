//
//  ViewController.swift
//  Azure iOS Facial Recognition
//
//  Created by Alejandro Cotilla on 8/14/18.
//  Copyright © 2018 Alejandro Cotilla. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let avatarsSection = 0
    
    var avatars: [UIImage]!
    var photos: [UIImage]!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatars = loadImages(at: "/Images/Avatars")
        photos = loadImages(at: "/Images/AllPhotos")
    }
    
    func loadImages(at path: String) -> [UIImage] {
        var images: [UIImage] = []
        
        let fullFolderPath = Bundle.main.resourcePath!.appending(path)
        let imageNames = try! FileManager.default.contentsOfDirectory(atPath: fullFolderPath)
        
        for imageName in imageNames {
            let imageUrl = fullFolderPath.appending("/\(imageName)")
            let image = UIImage.init(contentsOfFile: imageUrl)!
            images.append(image)
        }
        
        return images
    }
    
    // Re-adjust collection view layout on device rotation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        flowLayout.invalidateLayout()
    }
    
    // MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        // Avoid selection on the standard photos section
        return indexPath.section == avatarsSection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Avatar selected!")
        
        let selectedAvatar = avatars[indexPath.item]
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Two sections, avatars and standard photos.
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == avatarsSection {
            return avatars.count
        }
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImageCellView
        
        let image = indexPath.section == avatarsSection ? avatars[indexPath.item] : photos[indexPath.item]
        cell.imageView.image = image
        
        cell.type = indexPath.section == avatarsSection ? .round : .square
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Calculate cell sizes depending on the screen width and the section.
        
        var itemsPerRow = 3
        if indexPath.section == avatarsSection {
            itemsPerRow = avatars.count
        }
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let space = collectionView.frame.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.minimumInteritemSpacing * CGFloat(itemsPerRow - 1)
        let length = floor(space / CGFloat(itemsPerRow))
        
        return CGSize(width: length, height: length)
    }
    
}

