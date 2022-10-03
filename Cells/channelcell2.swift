//
//  channelcell2.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 22/9/22.
//

import Foundation
import UIKit


class cahnnelcell2: UICollectionViewCell {
    
    @IBOutlet var img2: UIImageView!
    @IBOutlet var chanbutton2: UIButton!
  
    var onSelectButtonTapped: (() -> Void)? = nil
    
    
    @IBAction func selectButtonTapped(sender: UIButton) {
        onSelectButtonTapped?()
    }
}
