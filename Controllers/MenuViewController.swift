//
//  MenuViewController.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 22/8/22.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import UICKeyChainStore

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var tvchannel: UITableView!

    private var allchannelArray = [Categories]()
    private var favChannelArray = [Int]()
    private var removeFavChannel = [Int] ()
    private var dataListfav = [Channels]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        tvchannel.delegate = self
        tvchannel.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let response = appDelegate.getCategories()
        allchannelArray = response!.categoriesArray
        
        self.tvchannel.reloadData()
        
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
        favChannelArray = UserDefaults.standard.array(forKey: "FavouriteChannelList\(keychain.string(forKey: "Username")!)") as? [Int] ?? [Int]()
    }
        
    @IBAction func closebtnTapped() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion:nil)
        }
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = self.tvchannel.dequeueReusableCell(withIdentifier: "ModelMenu") as! ModelMenu
        
        let channelList = allchannelArray[indexPath.section].channels!
        let channel = channelList[indexPath.row]
        cell.channelname.text = channel.channel_name

        if(channel.id == UserDefaults.standard.integer(forKey: "SelectedchannelID")){
            cell.containerView.backgroundColor = .brown
            cell.containerView.layer.cornerRadius = 10
        }else{
            cell.containerView.backgroundColor = UIColor.clear
        }
        
        if(channelList[indexPath.row].id == UserDefaults.standard.integer(forKey: "SelectedchannelID")){
            cell.containerView.backgroundColor = .brown
            cell.containerView.layer.cornerRadius = 10
        }else{
            cell.containerView.backgroundColor = UIColor.clear
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if(appDelegate.isFavChannel(id: channel.id)){
            cell.channelfav.setImage(UIImage(named: "favourite2"), for: .normal)
        }else{
            cell.channelfav.setImage(UIImage(named: "favourite1"), for: .normal)
        }

        cell.onSelectButtonTapped = {UserDefaults.standard.set(channel.id, forKey: "CurrentChannelID")
            print("channel id", channel.id)
            NotificationCenter.default.post(name: Notification.Name("UpdateChannel"), object: nil)
        }
        cell.onFavImageTapped = {
            let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
            if let index = self.favChannelArray.firstIndex(of: channel.id) {
                self.favChannelArray.remove(at: index)
                UserDefaults.standard.set(self.favChannelArray, forKey: "FavouriteChannelList\(keychain.string(forKey: "Username")!)")
                cell.channelfav.setImage(UIImage(named: "favourite1"), for: .normal)
            }else{
                self.favChannelArray.append(channel.id)
                cell.channelfav.setImage(UIImage(named: "favourite2"), for: .normal)
                UserDefaults.standard.set(self.favChannelArray, forKey: "FavouriteChannelList\(keychain.string(forKey: "Username")!)")
            }
        }

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return allchannelArray.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var category: Categories!
        
        category = allchannelArray[section]
        
        let width = tvchannel.frame.size.width
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        headerView.tag = section

        let name = UILabel()
        name.translatesAutoresizingMaskIntoConstraints = false
        name.textColor = .white
        name.font = UIFont(name: "Montserrat-Medium", size: 20)
        name.tag = 102
        name.text = category.category_name

        let count = UILabel()
        count.translatesAutoresizingMaskIntoConstraints = false
        count.textColor = .white
        count.font = UIFont(name: "Montserrat-Medium", size: 20)
        count.tag = 105
        count.text = allchannelArray[section].channels!.count.description

        let arrowView = UIImageView()
        arrowView.translatesAutoresizingMaskIntoConstraints = false
        arrowView.contentMode = .scaleAspectFit
        arrowView.tag = 100
        if(category.isExpanded ?? false){
            arrowView.image = UIImage(named: "test1")
        }else{
            arrowView.image = UIImage(named: "test2")
        }
        arrowView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        arrowView.heightAnchor.constraint(equalToConstant: 20).isActive = true

        headerView.addSubview(name)
        headerView.addSubview(arrowView)
        headerView.addSubview(count)


        // Insert Divider Before CountryWise Sections
        
//        let dividerView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: 1.5))
//        dividerView.backgroundColor = .lightGray
//        headerView.addSubview(dividerView)
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[name]-[arrowview]-[count]-10-|", options: [.alignAllCenterY], metrics: nil, views: ["name": name, "arrowview": arrowView, "count": count]))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[name]-10-|", options: [], metrics: nil, views: ["name": name]))
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[count]-10-|", options: [], metrics: nil, views: ["count": count]))
        NSLayoutConstraint.activate(constraints)

        let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.sectionHeaderTapped(_:)))
        headerView.addGestureRecognizer(headerTapped)

        return headerView
    }
    
    @objc func sectionHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer?) {
        let indexPath = IndexPath(row: 0, section: gestureRecognizer?.view?.tag ?? 0)
        var collapsed = false
        collapsed = allchannelArray[indexPath.section].isExpanded ?? false
        allchannelArray[indexPath.section].isExpanded = !collapsed
        tvchannel.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(allchannelArray[section].isExpanded ?? false){
            return allchannelArray[section].channels!.count
        }else{
            return 0
        }
    }
    
}
