//
//  ReceiptsController.swift
//  ReceiptsDiaryTabbedApp 1.0
//
//  Created by Nikolas on 30/05/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import UIKit


class ReceiptsController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var receiptsCollectionView: UICollectionView!
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    
    var receiptImages = [UIImage]()
    
    let receiptsCollectionViewCellIdentifier = "receiptsCollectionViewCellId"
    
    static let sharedInstance = ReceiptsController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DatabaseService.sharedInstance.connectToDatabase()
        setupMenuBarButtonItem()
        setupViewsConstraints()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        ReceiptsController.sharedInstance.receiptImages = DatabaseService.sharedInstance.getAllReceiptImages()
        receiptsCollectionView.reloadData()
    }
    
    
    private func setupMenuBarButtonItem() {
        
        menuBarButtonItem.tintColor = .white
        menuBarButtonItem.imageInsets = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 88)
    }
    
    
    private func setupViewsConstraints() {
        
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        receiptsCollectionView.translatesAutoresizingMaskIntoConstraints = false
        receiptsCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        receiptsCollectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 8).isActive = true
        receiptsCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        receiptsCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return ReceiptsController.sharedInstance.receiptImages.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let receiptsCollectionViewCell = receiptsCollectionView.dequeueReusableCell(withReuseIdentifier: receiptsCollectionViewCellIdentifier, for: indexPath) as! ReceiptsCollectionViewCell
        receiptsCollectionViewCell.receiptImageView.image = ReceiptsController.sharedInstance.receiptImages[indexPath.item]
        
        return receiptsCollectionViewCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 130)
    }
}
