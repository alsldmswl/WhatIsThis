//
//  DetailVCCell.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/09.
//

import UIKit
import CoreData

class DetailCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var detailImageView: UIImageView!
    
}
//
//extension DetailCollectionViewCell: DetailViewControllerDelegate {
//    func fetchImage() {
//        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CustomerList")
//        do {
//            let arrPhotos = try context.fetch(fetchRequest) as? [CustomerList]
//            if let photo = arrPhotos?.last {
//                detailImageView.image = UIImage(data: photo.image!)
//            }
//        } catch let error {
//            print(error.localizedDescription)
//        }
//    }
//}
