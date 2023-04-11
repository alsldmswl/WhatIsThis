//
//  WriteViewController.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/08.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import PhotosUI

protocol WriteViewControllerDelegate1: AnyObject {
    func didFinishSaveData()
}


class WriteViewController: UIViewController {
    
    let db = Database.database().reference()
    var customers: [Customer] = []
    
    var fetchResults: PHFetchResult<PHAsset>?

    weak var delegate1: WriteViewControllerDelegate1?
  
    @IBOutlet weak var writeCollectionView: UICollectionView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        writeCollectionView.collectionViewLayout = layout()
        writeCollectionView.delegate = self
        writeCollectionView.dataSource = self
    
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", image: nil, target: self, action: #selector(saveStory))
        
    }
    
    @objc func saveStory() {
        let myCustomer = Customer(id: "\(Customer.id)", title: titleTextField.text ?? "", content: contentTextView.text ?? "")
        Customer.id += 1
        db.child("myCustomer").child(myCustomer.id).setValue(myCustomer.toDic)
        delegate1?.didFinishSaveData()
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func inputImageButton(_ sender: UIButton) {
        checkPermission()
    }
    
    func checkPermission() {
        if PHPhotoLibrary.authorizationStatus() == .authorized || PHPhotoLibrary.authorizationStatus() == .limited {
            DispatchQueue.main.async {
                self.showGallery()
            }
           
        } else if PHPhotoLibrary.authorizationStatus() == .denied {
            DispatchQueue.main.async {
                self.showAuthorizationDeniedAlert()
            }
            
        } else if PHPhotoLibrary.authorizationStatus() == .notDetermined {
            PHPhotoLibrary.requestAuthorization { status in
                self.checkPermission()
            }
        }
    }
    
    func showAuthorizationDeniedAlert() {
        let alert = UIAlertController(title: "포토라이브러리 접근 권한을 활성화 해주세요.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "닫기", style: .cancel))
        alert.addAction(UIAlertAction(title: "설정으로 가기", style: .default, handler: { action in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {return}
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }))
        
        self.present(alert, animated: true)
    }
    
    func showGallery() {
        let library = PHPhotoLibrary.shared()
        
        var configuration = PHPickerConfiguration(photoLibrary: library)
        configuration.selectionLimit = 10
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    
    private func layout() -> UICollectionViewCompositionalLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(200))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension WriteViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.fetchResults?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WriteVCCell", for: indexPath) as! WriteVCCell
        if let asset = self.fetchResults?[indexPath.row] {
            cell.loadImage(asset: asset)
        }
        return cell
    }
    
    
}

extension WriteViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let identifiers = results.map { $0.assetIdentifier ?? "" }
        self.fetchResults = PHAsset.fetchAssets(withLocalIdentifiers: identifiers, options: nil)
        self.writeCollectionView.reloadData()
        self.dismiss(animated: true)
    }
  
}
extension WriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage,
              let user = Auth.auth().currentUser else {return}
        
        FirebaseStorageManager.uploadImage(image: selectedImage, pathRoot: user.uid) { url in
            if let url = url {
                UserDefaults.standard.set(url.absoluteString, forKey: "myImageUrl")
            }
        }
        picker.dismiss(animated: true)
        
    }
}
struct Customer: Codable {
    let id: String
    let title: String
    let content: String
    
    
    var toDic: [String : Any] {
        let dic: [String : Any] = ["id": id, "title" : title, "content": content]
        return dic
    }
    
    static var id: Int = 0
}
