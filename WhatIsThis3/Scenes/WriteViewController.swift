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
    
    //    var fetchResults: PHFetchResult<PHAsset>?
    
    weak var delegate1: WriteViewControllerDelegate1?
    
//    @IBOutlet weak var writeCollectionView: UICollectionView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        presentPhotoPicker()
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
}


extension WriteViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage,
              let user = Auth.auth().currentUser else {return}
        self.imageView.image = selectedImage
        
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
