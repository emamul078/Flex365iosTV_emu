//
//  DynamicHeightCollectionView.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 3/10/22.
//

import UIKit

class DynamicHeightCollectionView: UICollectionView {

override func layoutSubviews() {

    super.layoutSubviews()

    if bounds.size != intrinsicContentSize {

        self.invalidateIntrinsicContentSize()

    }

}

override var intrinsicContentSize: CGSize {

    if let flowLayout = self.collectionViewLayout as? UICollectionViewFlowLayout {
        
        if(flowLayout.scrollDirection == .vertical){
            
            return collectionViewLayout.collectionViewContentSize
            
        }else{
            
            let size = CGSizeMake(self.contentSize.width, 60)
            return size;
        }
        
    }
    return self.contentSize;

}

}
