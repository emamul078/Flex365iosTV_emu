//
//  channelcell.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 20/9/22.
//

import Foundation
import UIKit


class cahnnelcell: UICollectionViewCell {
    
    @IBOutlet var img1: UIImageView!
    @IBOutlet var chanbutton: UIButton!
  
    var onSelectButtonTapped: (() -> Void)? = nil
    
    
    @IBAction func selectButtonTapped(sender: UIButton) {
        onSelectButtonTapped?()
       
    }
}
