//
//  FavouriteViewController.swift
//  Flex365 TV
//
//  Created by Joy on 26/9/22.
//

import Foundation
import UIKit
import AVFoundation
import AVKit
import UICKeyChainStore

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet var searchchannel: UITableView!
    @IBOutlet var searchView: UIView!
    @IBOutlet var tfSearch: UITextField!
    
    private var allchannelArray = [Categories]()
    private var searchchannelArray = [Categories]()
    private var isInSearchMode = false
    private var searchText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tfSearch.delegate = self
        searchchannel.delegate = self
        searchchannel.dataSource = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let response = appDelegate.getCategories()
        allchannelArray = response!.categoriesArray
        initializeRegularTableView()
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let oldText = textField.text, let range = Range(range, in: oldText) else {
            return true
        }
        
        let newText = oldText.replacingCharacters(in: range, with: string)
        searchText = newText.lowercased()
        if(searchText == ""){
            isInSearchMode = false
            initializeRegularTableView()
        }else{
            isInSearchMode = true
            initializeSearchTableView()
        }
        searchchannel.reloadData()
        return true
    }
    
    
    @IBAction func closebtnTapped() {
        dismiss(animated: true)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var searchchannel: Categories!
        if(isInSearchMode){
            searchchannel = searchchannelArray[indexPath.section]
            let cell = self.searchchannel.dequeueReusableCell(withIdentifier: "ModelSearch") as! ModelSearch
            
            let channelList = searchchannelArray[indexPath.section].channels!
            let channel = channelList[indexPath.row]
            cell.channellbl.text = channel.channel_name

            if(channel.id == UserDefaults.standard.integer(forKey: "SelectedchannelID")){
                cell.ContainerView.backgroundColor = .brown
                cell.ContainerView.layer.cornerRadius = 10
            }else{
                cell.ContainerView.backgroundColor = UIColor.clear
            }
            
            if(channelList[indexPath.row].id == UserDefaults.standard.integer(forKey: "SelectedchannelID")){
                cell.ContainerView.backgroundColor = .brown
                cell.ContainerView.layer.cornerRadius = 10
            }else{
                cell.ContainerView.backgroundColor = UIColor.clear
            }

            cell.onSelectButtonTapped = {
                
                UserDefaults.standard.set(channel.id, forKey: "CurrentChannelID")
                print("channel id", channel.id)
                NotificationCenter.default.post(name: Notification.Name("UpdateChannel"), object: nil)
            }
            return cell
        }else{
            searchchannel = allchannelArray[indexPath.section]
            let cell = self.searchchannel.dequeueReusableCell(withIdentifier: "ModelSearch") as! ModelSearch
            
            let channelList = allchannelArray[indexPath.section].channels!
            let channel = channelList[indexPath.row]
            cell.channellbl.text = channel.channel_name

            if(channel.id == UserDefaults.standard.integer(forKey: "SelectedchannelID")){
                cell.ContainerView.backgroundColor = .brown
                cell.ContainerView.layer.cornerRadius = 10
            }else{
                cell.ContainerView.backgroundColor = UIColor.clear
            }
            
            if(channelList[indexPath.row].id == UserDefaults.standard.integer(forKey: "SelectedchannelID")){
                cell.ContainerView.backgroundColor = .brown
                cell.ContainerView.layer.cornerRadius = 10
            }else{
                cell.ContainerView.backgroundColor = UIColor.clear
            }

            cell.onSelectButtonTapped = {
                
                UserDefaults.standard.set(channel.id, forKey: "CurrentChannelID")
                print("channel id", channel.id)
                NotificationCenter.default.post(name: Notification.Name("UpdateChannel"), object: nil)
            }
            return cell
        }
        
//        let cell = self.searchchannel.dequeueReusableCell(withIdentifier: "ModelSearch") as! ModelSearch
//
//        let channelList = allchannelArray[indexPath.section].channels!
//        let channel = channelList[indexPath.row]
//        cell.channellbl.text = channel.channel_name
//
//        if(channel.id == UserDefaults.standard.integer(forKey: "SelectedchannelID")){
//            cell.ContainerView.backgroundColor = .brown
//            cell.ContainerView.layer.cornerRadius = 10
//        }else{
//            cell.ContainerView.backgroundColor = UIColor.clear
//        }
//
//        if(channelList[indexPath.row].id == UserDefaults.standard.integer(forKey: "SelectedchannelID")){
//            cell.ContainerView.backgroundColor = .brown
//            cell.ContainerView.layer.cornerRadius = 10
//        }else{
//            cell.ContainerView.backgroundColor = UIColor.clear
//        }
//
//        cell.onSelectButtonTapped = {
//
//            UserDefaults.standard.set(channel.id, forKey: "CurrentChannelID")
//            print("channel id", channel.id)
//            NotificationCenter.default.post(name: Notification.Name("UpdateChannel"), object: nil)
//        }
//        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if(isInSearchMode){
            return searchchannelArray.count
        }else{
            return allchannelArray.count
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var category: Categories!
        
        if(isInSearchMode){
            category = searchchannelArray[section]
        }else{
            category = allchannelArray[section]
        }
        
        
        let width = searchchannel.frame.size.width
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
        
        var constraints = [NSLayoutConstraint]()
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "|-10-[name]-[arrowview]-[count]-10-|", options: [.alignAllCenterY], metrics: nil, views: ["name": name, "arrowview": arrowView, "count": count]))
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[name]-10-|", options: [], metrics: nil, views: ["name": name]))
        
        constraints.append(contentsOf: NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[count]-10-|", options: [], metrics: nil, views: ["count": count]))
        NSLayoutConstraint.activate(constraints)

        let headerTapped = UITapGestureRecognizer(target: self, action: #selector(self.sectionHeaderTapped(_:)))
        headerView.addGestureRecognizer(headerTapped)

        return headerView
    }
    
//    @objc func sectionHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer?) {
//        let indexPath = IndexPath(row: 0, section: gestureRecognizer?.view?.tag ?? 0)
//        var collapsed = false
//        collapsed = allchannelArray[indexPath.section].isExpanded ?? false
//        allchannelArray[indexPath.section].isExpanded = !collapsed
//        searchchannel.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
//    }
    
    @objc func sectionHeaderTapped(_ gestureRecognizer: UITapGestureRecognizer?) {
        let indexPath = IndexPath(row: 0, section: gestureRecognizer?.view?.tag ?? 0)
        var collapsed = false
        if(isInSearchMode){
            collapsed = searchchannelArray[indexPath.section].isExpanded ?? false
            searchchannelArray[indexPath.section].isExpanded = !collapsed
        }else{
            collapsed = allchannelArray[indexPath.section].isExpanded ?? false
            allchannelArray[indexPath.section].isExpanded = !collapsed
        }
        searchchannel.reloadSections(NSIndexSet(index: indexPath.section) as IndexSet, with: .automatic)
    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(allchannelArray[section].isExpanded ?? false){
//            return allchannelArray[section].channels!.count
//        }else{
//            return 0
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(isInSearchMode){
                return searchchannelArray[section].channels!.count
            }
        else{
            if(allchannelArray[section].isExpanded ?? false){
                return allchannelArray[section].channels!.count
            }else{
                return 0
            }
        }
    }
    
    func initializeSearchTableView(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let response = appDelegate.getCategories()
        let array = response!.categoriesArray
        var categoryArray = [Categories]()
        for category in array {
            var categoryTemp = category
            var channelArray = [Channels]()
            let channels = category.channels
            for channel in channels!{
                let channelName = channel.channel_name
                if channelName.lowercased().contains(searchText.lowercased()) {
                    channelArray.append(channel)
                }
            }
            if(channelArray.count > 0){
                categoryTemp.channels = channelArray
                categoryArray.append(categoryTemp)
            }
        }
        searchchannelArray = categoryArray
        self.searchchannel.reloadData()
    }
    
    func initializeRegularTableView(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let response = appDelegate.getCategories()
        allchannelArray = response!.categoriesArray
        self.searchchannel.reloadData()
    }
    
}
