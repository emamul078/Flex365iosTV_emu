//
//  ViewController.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 18/8/22.
//
import UIKit
import AVFoundation
import AVKit
import LGSideMenuController
import UICKeyChainStore

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var check = true

    @IBOutlet var playerView:UIView!
    @IBOutlet var pauseButton:UIButton!
    @IBOutlet var playButton:UIButton!
    @IBOutlet var bigbtn:UIButton!
    @IBOutlet var accountimage:UIImageView!
    @IBOutlet var favouriteimage:UIImageView!
    @IBOutlet var searchimage:UIImageView!
    @IBOutlet var categoryimage: UIImageView!
    @IBOutlet var tvtableview1: UITableView!
    private var dataList = [Categories]()
    
    @IBOutlet var categoryview:UIView!
    @IBOutlet var searchview:UIView!
    @IBOutlet var favouriteview:UIView!
    @IBOutlet var accountview:UIView!
    @IBOutlet var favouritetview:UIView!
    @IBOutlet var playbtn:UIButton!
    @IBOutlet var pausebtn:UIButton!

  
    
 
    let avPlayerViewController = AVPlayerViewController()
    var avPlayer: AVPlayer?
    var choices: [UIView]!
    var label: UILabel!
    var onSelectButtonTapped: (() -> Void)? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvtableview1.delegate = self
        tvtableview1.dataSource = self
        
        self.tvtableview1.estimatedRowHeight = 231.0
        self.tvtableview1.rowHeight = UITableView.automaticDimension
        
        pauseButton.isHidden = true
        self.initList2()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateChannel(notification:)), name: Notification.Name("UpdateChannel"), object: nil)
        try! AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        
        searchimage.image = UIImage(named:"search1")
        accountimage.image = UIImage(named:"account1")
        categoryimage.image = UIImage(named:"category1")
        favouriteimage.image = UIImage(named:"favourite1")
    }
    
    @objc func updateChannel(notification: Notification) {
        self.playChannel()
        dismiss(animated: true)
    }
    
    func initList2(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let response = appDelegate.getCategories()
         dataList = response!.categoriesArray;
         self.tvtableview1.reloadData()
    }
    
    func playChannel(){
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
        let username = keychain.string(forKey: "Username") ?? ""
        let password = keychain.string(forKey: "Password") ?? ""
        let channel_id = UserDefaults.standard.integer(forKey: "CurrentChannelID")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let streamSrc = appDelegate.getuserData()?.stream_src ?? ""
        let movieURL  =  "\(streamSrc)/live/\(username)/\(password)/\(channel_id).m3u8"
        print(movieURL)
        guard let url = URL(string: movieURL) else { return }
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        self.avPlayer = AVPlayer(playerItem: playerItem)
        
        let layer: AVPlayerLayer = AVPlayerLayer(player: avPlayer)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = playerView.bounds
        layer.videoGravity = .resizeAspectFill
        playerView.layer.sublayers?
            .filter { $0 is AVPlayerLayer }
            .forEach { $0.removeFromSuperlayer() }
        playerView.layer.addSublayer(layer)
        
        avPlayer?.play()
        playButton.isHidden = true
        pauseButton.isHidden = false
        pausebtn.isHidden = false
        playbtn.isHidden = true
    }
    
    func pauseChannel(){
        let layer: AVPlayerLayer = AVPlayerLayer(player: avPlayer)
        layer.backgroundColor = UIColor.white.cgColor
        layer.frame = playerView.bounds
        layer.videoGravity = .resizeAspectFill
        playerView.layer.sublayers?
            .filter { $0 is AVPlayerLayer }
            .forEach { $0.removeFromSuperlayer() }
        playerView.layer.addSublayer(layer)
        
        avPlayer?.pause()
        pauseButton.isHidden = true
        playButton.isHidden = false
        pausebtn.isHidden = true
        playbtn.isHidden = false
    }

    @IBAction func playButtonTapped(_ sender: Any) {
        self.playChannel()
 }
    
    @IBAction func pauseButtonTapped(_ sender: Any) {
        self.pauseChannel()
    }
    
    @IBAction func playbtnTapped(_ sender: Any) {
        self.playChannel()
    }
    
    @IBAction func pausebtnTapped(_ sender: Any) {
        self.pauseChannel()
    }
    

    @IBAction func accountButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let avc = storyboard.instantiateViewController(withIdentifier: "AccountViewController")
        avc.modalPresentationStyle = .popover
        
        present(avc, animated: true, completion: nil)
        
        accountview.backgroundColor = .white
        searchview.backgroundColor = .clear
        categoryview.backgroundColor = .clear
        favouriteview.backgroundColor = .clear
        accountimage.image = UIImage(named:"account2")
        categoryimage.image = UIImage(named:"category1")
        searchimage.image = UIImage(named:"search1")
        favouriteimage.image = UIImage(named:"favourite1")
    }
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let svc = storyboard.instantiateViewController(withIdentifier: "SearchViewController")
        
        svc.modalPresentationStyle = .popover
        present(svc, animated: true, completion: nil)
        
        searchview.backgroundColor = .white
        accountview.backgroundColor = .clear
        categoryview.backgroundColor = .clear
        favouriteview.backgroundColor = .clear
        favouriteimage.image = UIImage(named:"favourite1")
        searchimage.image = UIImage(named:"search2")
        accountimage.image = UIImage(named:"account1")
        categoryimage.image = UIImage(named:"category1")
    }
    
    
    @IBAction func categoryButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gvc = storyboard.instantiateViewController(withIdentifier: "GridViewController")
        
        gvc.modalPresentationStyle = .popover
        present(gvc, animated: true, completion: nil)
        
        categoryview.backgroundColor = .white
        accountview.backgroundColor = .clear
        searchview.backgroundColor = .clear
        favouriteview.backgroundColor = .clear
        favouriteimage.image = UIImage(named:"favourite1")
        categoryimage.image = UIImage(named:"category2")
        searchimage.image = UIImage(named:"search1")
        accountimage.image = UIImage(named:"account1")
    }
    
    
    @IBAction func favouriteTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gvc = storyboard.instantiateViewController(withIdentifier: "FavouriteViewController")
        
        gvc.modalPresentationStyle = .popover
        present(gvc, animated: true, completion: nil)
        
        categoryview.backgroundColor = .clear
        accountview.backgroundColor = .clear
        searchview.backgroundColor = .clear
        favouriteview.backgroundColor = .white
        favouriteimage.image = UIImage(named:"favourite2")
        categoryimage.image = UIImage(named:"category1")
        searchimage.image = UIImage(named:"search1")
        accountimage.image = UIImage(named:"account1")
//        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
//        let array:[Int] = UserDefaults.standard.array(forKey: "FavouriteChannelList\(keychain.string(forKey: "Username")!)") as! [Int]
       
    }
    
    @IBAction func menubtnTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let gvc = storyboard.instantiateViewController(withIdentifier: "MenuViewController")
        gvc.modalPresentationStyle = .popover
        present(gvc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell4 = self.tvtableview1.dequeueReusableCell(withIdentifier: "CategoryCell2") as! categorycell2
        
        
        let category = dataList[indexPath.row];
        
        cell4.category2.text = category.category_name
        cell4.initChanlist(index: indexPath)
        cell4.cattoal2.text = category.channels?.count.description
        cell4.tableView = self.tvtableview1;
        cell4.indexPath = indexPath;
  
        return cell4;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("Dynamic Hight22")
        let category = dataList[indexPath.row];
        
        
        
        return UITableView.automaticDimension
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    @IBAction func bigbuttonTapped(){
        if(self.avPlayer != nil){
            let playerViewController = AVPlayerViewController()
            playerViewController.player = avPlayer
            self.present(playerViewController, animated: true) {
                playerViewController.player!.play()
            }
        }
    }
    
    @IBAction func sliderValueChanged(sender: UISlider) {
        var currentValue = Float(sender.value)
        DispatchQueue.main.async {
            if(self.avPlayer != nil){
                self.avPlayer!.volume = currentValue
            }
        }
    }
    
}
