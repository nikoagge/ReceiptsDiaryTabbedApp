//
//  MenuController.swift
//  ReceiptsDiaryTabbedApp 1.0
//
//  Created by Nikolas on 28/05/2019.
//  Copyright © 2019 Nikolas Aggelidis. All rights reserved.
//


import UIKit


class MenuController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var menuBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var typeOfServiceCollectionView: UICollectionView!
    @IBOutlet weak var grabAReceiptImageView: UIImageView!
    @IBOutlet weak var grabAReceiptLabel: UILabel!
    
    
    let typeOfServiceCollectionViewCellsImageName = ["stack-of-coins_20pixels", "car_20pixels", "company-car_20pixels", "watch_20pixels"]
    let typeOfServiceCollectionViewCellsLabel = ["Purchase", "Personal\n     Car", "Company\n     Car", "   Time"]
    let typeOfServiceCollectionViewCellIdentifier = "typeOfServiceCollectionViewCellId"
    
    let imagePickerController = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
        
        setupMenuBarButtonItem()
        setupViewsConstraints()
        setupGrabAReceiptImageView()
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
        
        typeOfServiceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        typeOfServiceCollectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
        typeOfServiceCollectionView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 8).isActive = true
        typeOfServiceCollectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
        typeOfServiceCollectionView.bottomAnchor.constraint(equalTo: grabAReceiptImageView.topAnchor).isActive = true
        
        grabAReceiptImageView.translatesAutoresizingMaskIntoConstraints = false
        grabAReceiptImageView.centerXAnchor.constraint(equalTo: typeOfServiceCollectionView.centerXAnchor).isActive = true
      grabAReceiptImageView.bottomAnchor.constraint(equalTo: grabAReceiptLabel.topAnchor, constant: -23).isActive = true
      grabAReceiptImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
      grabAReceiptImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        grabAReceiptLabel.translatesAutoresizingMaskIntoConstraints = false
        grabAReceiptLabel.centerXAnchor.constraint(equalTo: grabAReceiptImageView.centerXAnchor).isActive = true
        grabAReceiptLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        grabAReceiptLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        grabAReceiptLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    
    private func setupGrabAReceiptImageView() {
        
        grabAReceiptImageView?.isUserInteractionEnabled = true
        grabAReceiptImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(grabAReceiptImageViewTapped)))
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return typeOfServiceCollectionViewCellsImageName.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let typeOfServiceCollectionViewCell = typeOfServiceCollectionView.dequeueReusableCell(withReuseIdentifier: typeOfServiceCollectionViewCellIdentifier, for: indexPath) as! TypeOfServiceCollectionViewCell
        typeOfServiceCollectionViewCell.typeOfServiceImageView.image = UIImage(named: typeOfServiceCollectionViewCellsImageName[indexPath.item])
        typeOfServiceCollectionViewCell.typeOfServiceLabel.text = typeOfServiceCollectionViewCellsLabel[indexPath.item]
        
        return typeOfServiceCollectionViewCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(typeOfServiceCollectionViewCellsLabel[indexPath.item])
    }
    
    
    func selectPhotoFromLibrary() {
        
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        
        //In order to have the same functionality on iPad must add following lines of code so to have a popover to pick a photo:
        //imagePickerController.modalPresentationStyle = .popover
        //imagePickerController.popoverPresentationController?.barButtonItem = sender
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func shootPhotoFromCamera() {
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = .camera
            imagePickerController.cameraCaptureMode = .photo
            imagePickerController.modalPresentationStyle = .fullScreen
            
            present(imagePickerController, animated: true, completion: nil)
        } else {
            
            noCameraAlert()
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let chosenImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        grabAReceiptImageView?.contentMode = .scaleAspectFit
        grabAReceiptImageView?.image = chosenImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func noCameraAlert() {
        
        let alertViewController = UIAlertController(title: "No camera", message: "This device has no camera.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alertViewController.addAction(okAction)
        
        present(alertViewController, animated: true, completion: nil)
    }
    
    
    @objc func grabAReceiptImageViewTapped() {
        
        let grabAReceiptButtonTappedAlertController = UIAlertController(title: "Grab a receipt button tapped", message: "Please select an action to load a new receipt.", preferredStyle: .alert)
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (photoLibraryAction) in
            
            self.selectPhotoFromLibrary()
        }
        
        let shootPhotoFromCameraAction = UIAlertAction(title: "Take Photo", style: .default) { (shootPhotoFromCameraAction) in
            
            self.shootPhotoFromCamera()
        }
        
        grabAReceiptButtonTappedAlertController.addAction(photoLibraryAction)
        grabAReceiptButtonTappedAlertController.addAction(shootPhotoFromCameraAction)
        
        present(grabAReceiptButtonTappedAlertController, animated: true, completion: nil)
    }
}
