//
//  WriteVCCell.swift
//  WhatIsThis3
//
//  Created by eun-ji on 2023/04/08.
//

import UIKit
import SnapKit

class WriteVCCell: UICollectionViewCell {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.borderWidth = 0.5
        imageView.layer.borderColor = UIColor.separator.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    func setup() {
        addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
}
