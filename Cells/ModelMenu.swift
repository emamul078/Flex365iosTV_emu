import Foundation
import UIKit

class ModelMenu: UITableViewCell {
    
    @IBOutlet var rootView: UIView!
    @IBOutlet var channelname: UILabel!
    @IBOutlet var channelfav: UIButton!
    @IBOutlet var containerView: UIView!

    private var channelList = [Channels]()
//    private var favChannelArray = [Int]()
//    private var dataListfav = [Channels]()
    var onFavImageTapped: (() -> Void)? = nil
    var onSelectButtonTapped: (() -> Void)? = nil
   
    
    override func awakeFromNib (){
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
