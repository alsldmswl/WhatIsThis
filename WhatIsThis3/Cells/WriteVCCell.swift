//
//  WriteVCCell.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/08.
//

import UIKit
import PhotosUI

class WriteVCCell: UICollectionViewCell {
  
    @IBOutlet weak var WriteImageView: UIImageView!
    
    func loadImage(asset: PHAsset) {
        let imageManager = PHImageManager()
        let scale = UIScreen.main.scale
        let imageSize = CGSize(width: 200 * scale, height: 200 * scale)
        
        let options = PHImageRequestOptions()
        options.deliveryMode = .highQualityFormat //고화질만 설정하기
        
        imageManager.requestImage(for: asset, targetSize: imageSize, contentMode: .aspectFill, options: options) { image, info in
            self.WriteImageView.image = image
        }
    }
  
}


