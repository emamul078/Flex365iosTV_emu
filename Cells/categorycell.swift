//
//  categorycell.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 20/9/22.
//

import Foundation
import UIKit

class categorycell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet var category1: UILabel!
    @IBOutlet var cattoal1: UILabel!
    @IBOutlet var vertical1image: UIImageView!
    @IBOutlet var horizontal1image: UIImageView!
//    @IBOutlet var verticalbuttton: UIButton!
//    @IBOutlet var horizontalbutton: UIButton!
    @IBOutlet var tvcollectionView: UICollectionView!
    
    private var dataList2 = [Channels]()
    private  var onSelectButtonTapped: (() -> Void)? = nil
    
    
    
    override func awakeFromNib (){
        
        super.awakeFromNib()
        tvcollectionView.delegate = self
        tvcollectionView.dataSource = self
        
    }
    
    func initChanlist(index : IndexPath){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let response = appDelegate.getCategories()
        dataList2 = response!.categoriesArray[index.row].channels!
        self.tvcollectionView.reloadData()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.tvcollectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell2 = self.tvcollectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for: indexPath) as? cahnnelcell else{return UICollectionViewCell()}
        
        let channel = dataList2[indexPath.row]
        
        cell2.img1.downloaded(from: channel.channel_image_app)
        
        cell2.onSelectButtonTapped = {
            UserDefaults.standard.set(channel.id, forKey: "CurrentChannelID")
            print(channel.id)
            NotificationCenter.default.post(name: Notification.Name("UpdateChannel"), object: nil)
            
            NotificationCenter.default.post(name: Notification.Name("UpdateChannel"), object: nil)
}
        
        return cell2;
        
    }
    
    @IBAction func horizontalbuttonTapped() {
        print("h1tapped")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        self.tvcollectionView.collectionViewLayout = layout
        horizontal1image.image = UIImage(named:"arrowreddown")
        vertical1image.image = UIImage(named:"arrowwhiteright")
    }
    
    
        @IBAction func verticalbutttonTapped() {
        print("v1tapped")

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.tvcollectionView.collectionViewLayout = layout
        vertical1image.image = UIImage(named:"arrowredright")
        horizontal1image.image = UIImage(named:"arrowwhitedown")
    }
}
