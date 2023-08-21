//
//  imagesCollectionViewCell.swift
//  GallereyProject
//
//  Created by Артём Черныш on 20.08.23.
//

import UIKit
import SnapKit

class imagesCollectionViewCell: UICollectionViewCell {
    static let cellIdentifier = "imagesCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "xmark.circle")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true 
        return imageView
    }()
    
    public func configure(image: UIImage, imageSize: Double) {
        imageView.image = image
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.left.equalTo(contentView).offset(2)
            make.right.bottom.equalTo(contentView).inset(2)
        }
        contentView.snp.makeConstraints { make in
            make.height.width.equalTo(imageSize)
        }
    }
}
