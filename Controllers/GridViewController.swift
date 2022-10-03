//
//  GridViewController.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 19/9/22.
//

import Foundation
import UIKit
import NetworkExtension
import UICKeyChainStore

class GridViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
   // @IBOutlet var closedBtn: UIButton!
    @IBOutlet var tvtableview: UITableView!
    
    private var categoryArray = [String]()
    private var dataList = [Categories]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set tableview
        tvtableview.delegate = self
        tvtableview.dataSource = self
        
        initList()
    }
    
    func initList(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let response = appDelegate.getCategories()
         dataList = response!.categoriesArray;
         self.tvtableview.reloadData()
      

    }
  
    @IBAction func closedButtonTapped(){
        dismiss(animated: true)
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tvtableview.dequeueReusableCell(withIdentifier: "CategoryCell") as! categorycell
        
        
        let category = dataList[indexPath.row];
        
        cell.category1.text = category.category_name
        cell.initChanlist(index: indexPath)
        cell.cattoal1.text = category.channels?.count.description
       

        return cell;
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
