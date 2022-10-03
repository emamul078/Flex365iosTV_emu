//
//  ModelFavourite.swift
//  Flex365 TV
//
//  Created by Joy on 26/9/22.
//

import Foundation
import UIKit

class ModelFavourite: UITableViewCell {
    @IBOutlet var rootView: UIView!
    @IBOutlet var channelname: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var favouritebtn: UIButton!
    
    private var channelList = [Channels]()
    
    var onFavImageTapped: (() -> Void)? = nil
    var onSelectButtonTapped: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func selectButtonTapped(sender: UIButton) {
        onSelectButtonTapped?()
    }
    
    @IBAction func favButtonTapped(sender: UIButton) {
        onFavImageTapped?()
    }
}
