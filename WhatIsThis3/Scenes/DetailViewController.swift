//
//  DetailViewController.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/09.
//

//TODO: 이미지 저장기능, 데이터 베이스 저장기능 수정

import UIKit
import Firebase
import FirebaseStorage

//protocol DetailViewControllerDelegate: AnyObject {
//    func fetchImage()
//}

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var DetailImageView: UIImageView!
    
    
    //    weak var delegate: DetailViewControllerDelegate?
    var selectedCustomerList: Customer?
    var indexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        if let hasData = selectedCustomerList {
            titleLabel.text = hasData.title
            contentLabel.text = hasData.content
            guard let urlString = UserDefaults.standard.string(forKey: "myImageUrl") else {return}
            FirebaseStorageManager.downloadImage(urlString: urlString) { [weak self] image in
                self?.DetailImageView.image = image
            }
        }
      
    }
    
}
