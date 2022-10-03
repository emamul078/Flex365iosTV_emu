//
//  AccountViewController.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 13/9/22.
//

import Foundation
import UIKit
import UICKeyChainStore
import LGSideMenuController

class AccountViewController: UIViewController {
    
    @IBOutlet var  lblStatus: UILabel!
  //  @IBOutlet var SubHolder: UIView!
    @IBOutlet var supportbtn: UIButton!
//    @IBOutlet var logoutbtn: UIButton!
    @IBOutlet var lblExpire: UILabel!
    @IBOutlet var lblExpiryDate: UILabel!
    
    
    private var delegate: AppDelegate!
    private var keychain: UICKeyChainStore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
        delegate = UIApplication.shared.delegate as? AppDelegate
        initializeViews()
       // view.backgroundColor = .clear
        
}
    
    override func viewDidAppear(_ animated: Bool) {
       // SubHolder.layer.cornerRadius = 10
       
    }
    
//    @IBAction func btnMailTapped(_ sender: Any){
//        if MFMailComposeViewController.canSendMail() {
//            let mail = MFMailComposeViewController()
//            mail.mailComposeDelegate = self
//            mail.setSubject("Email from Symlex customer")
//            mail.setToRecipients(["support@symlexvpn.com"])
//            mail.setMessageBody("", isHTML: false)
//
//            present(mail, animated: true)
//        } else {
//            self.showToast(message: "No Email Configuared".localized)
//        }
//    }
    
    
    @IBAction func logoutButtonTapped(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }

    @IBAction func closeButtonTapped(){
        dismiss(animated: true)
    }
    
    func initializeViews(){
        let userData = delegate?.getuserData()

        lblStatus.text = userData?.username

        lblExpire.text = "Expired On"
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd-MMMM-yyyy"
        let date = dateFormate.date(from: (userData?.expire_date)!)
        let format = DateFormatter()
        format.dateFormat = "MMMM d, y"
        if(date != nil){
            lblExpiryDate.text = format.string(from: date!)
        }else{
            lblExpiryDate.text = userData?.expire_date
        }
}
    
    
    @IBAction func supportbtntapped(_ sender: Any){
        var dataList = [String]()
        let phoneNumber = UserDefaults.standard.string(forKey: "support_number")
        let numbers = phoneNumber!.components(separatedBy: ",")
        if numbers.count > 0 {
            for i in 0..<numbers.count {
                dataList.append(numbers[i])
            }
        }
        var randomInt = 0
        if(dataList.count > 1){
            randomInt = Int.random(in: 0..<dataList.count-1)
        }

        let url = "https://api.whatsapp.com/send?phone=\(dataList[randomInt])"
        if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

