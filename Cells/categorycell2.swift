//
//  categorycell2.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 22/9/22.
//

import Foundation
import UIKit

class categorycell2: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var category2: UILabel!
    @IBOutlet var cattoal2: UILabel!
    @IBOutlet var vertical2image: UIImageView!
    @IBOutlet var horizontal2image: UIImageView!
//    @IBOutlet var vertical2buttton: UIButton!
//    @IBOutlet var horizontal2button: UIButton!
    @IBOutlet var tvcollectionView2: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var dataList3 = [Channels]()
    var tableView: UITableView!
    var indexPath: IndexPath!
    private  var onSelectButtonTapped: (() -> Void)? = nil
    
    
    
    override func awakeFromNib (){
        super.awakeFromNib()
        tvcollectionView2.delegate = self
        tvcollectionView2.dataSource = self
        cattoal2.layer.cornerRadius = 10
        
    }
    
    func initChanlist(index : IndexPath){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let response = appDelegate.getCategories()
        dataList3 = response!.categoriesArray[index.row].channels!
        self.tvcollectionView2.reloadData()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.tvcollectionView2.collectionViewLayout = layout
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList3.count

}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell3 = self.tvcollectionView2.dequeueReusableCell(withReuseIdentifier: "ChannelCell2", for: indexPath) as? cahnnelcell2 else{return UICollectionViewCell()}
        
        let channel = dataList3[indexPath.row]
        
        cell3.img2.downloaded(from: channel.channel_image_app)
        
        cell3.onSelectButtonTapped = {
            UserDefaults.standard.set(channel.id, forKey: "CurrentChannelID")
            print(channel.id)
            NotificationCenter.default.post(name: Notification.Name("UpdateChannel"), object: nil)
        }
        
        return cell3;
    }
    
    @IBAction func horizontal2buttonTapped() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.tvcollectionView2.collectionViewLayout = layout
        horizontal2image.image = UIImage(named:"arrowreddown")
        vertical2image.image = UIImage(named:"arrowwhiteright")
        
        self.tableView.reloadRows(at: [self.indexPath], with: .automatic)
}
    
    @IBAction func vertical2butttonTapped() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.tvcollectionView2.collectionViewLayout = layout
        vertical2image.image = UIImage(named:"arrowredright")
        horizontal2image.image = UIImage(named:"arrowwhitedown")
        self.tableView.reloadRows(at: [self.indexPath], with: .automatic)
    }
    
    
}
