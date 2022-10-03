//
//  LoginViewController.swift
//  Flex365 TV
//  Created by Emamul Hasan on 22/8/22.
//

import Foundation
import UIKit
import UICKeyChainStore
import LGSideMenuController
import Lottie


class LoginViewController: UIViewController {
    
    @IBOutlet var usernameHolder: UIView!
    @IBOutlet var passwordHolder: UIView!
    @IBOutlet var tfUsername: UITextField!
    @IBOutlet var tfPassword: UITextField!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var loginHolder: UIView!
    @IBOutlet var btnLogin: UIButton!
    @IBOutlet var btnShowHide: UIButton!
    @IBOutlet var lblversion: UILabel!
    @IBOutlet weak var supportView: UIView!
    @IBOutlet weak var animationView1: UIView!
    @IBOutlet weak var animationView2: UIView!
    @IBOutlet var Supportbtn: UIButton!
    @IBOutlet var helpbtn: UIButton!
    @IBOutlet var bussinessbtn: UIButton!
    @IBOutlet var spinner: Spinner!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.lblversion.text = appVersion
        self.supportView.isHidden = true
        loadSavedCredential()
       
//        btnLogin.addSubview(loginSpinner)
//            loginSpinner.centerXAnchor.constraint(equalTo: btnLogin.centerXAnchor).isActive = true
//            loginSpinner.centerYAnchor.constraint(equalTo: btnLogin.centerYAnchor).isActive = true
    }

    
    override func viewDidAppear(_ animated: Bool) {
        usernameHolder.layer.cornerRadius = 10
        passwordHolder.layer.cornerRadius = 10
        loginHolder.layer.cornerRadius = 10

        
        let animationViewS = AnimationView(name: "bussiness")
        animationViewS.frame = self.animationView1.bounds
        self.animationView1.addSubview(animationViewS)
        animationViewS.play()
        animationViewS.loopMode = .loop
        
        let animationViewB = AnimationView(name: "help")
        animationViewB.frame = self.animationView2.bounds
        self.animationView2.addSubview(animationViewB)
        animationViewB.play()
        animationViewB.loopMode = .loop
}
    
   func loadSavedCredential(){
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
        tfUsername.text = keychain.string(forKey: "Username")
        tfPassword.text = keychain.string(forKey: "Password")
    }
    
    @IBAction func loginButtonTapped(_ sender: Any){

        let username = tfUsername.text ?? ""
        let password = tfPassword.text ?? ""

        if(username == ""){
            self.lblStatus.isHidden = false
            self.lblStatus.text = "Username cannot be empty";
            return
        }
        if(password == ""){
            self.lblStatus.isHidden = false
            self.lblStatus.text = "Password cannot be empty"
            return
        }

        if(NetworkManager.shared.checkInternetAvailable()){
            startSpinner()
          //  loginSpinner.startAnimating()
            NetworkManager.shared.callLoginAPI(username: username, password: password, completion: { (result, message) in
                print(message)
                self.stopSpinner()
              //  self.loginSpinner.stopAnimating()
                if(result == "Success"){
                    self.lblStatus.isHidden = true
                    NetworkManager.shared.getChannelList(completion: {(result, message) in
                        if(result == "Success"){
                            self.goToMainPage()
                        }else{
                            
                        }
                    })
                }
                else{
                    self.lblStatus.isHidden = false
                    self.lblStatus.text = "Username or Password is incorrect";
                    return
                }
            })
        }else{
            self.lblStatus.isHidden = false
            self.lblStatus.text = "Please Check Your Internet"
        }
    }
    
    @IBAction func showHideButtonTapped(_ sender: Any){
        if(tfPassword.isSecureTextEntry){
            btnShowHide.setImage(UIImage(named: "hide"), for: UIControl.State.normal)
        }else{
            btnShowHide.setImage(UIImage(named: "show"), for: UIControl.State.normal)
        }
        tfPassword.isSecureTextEntry.toggle()
    }
        
    @IBAction func supportTapped(_ sender: Any){
        if supportView.isHidden {
            supportView.isHidden = false
            } else {
                supportView.isHidden = true
            }
    }
    
    @IBAction func bussinessbtntapped(_ sender: Any){
        var dataList = [String]()
        let phoneNumber = UserDefaults.standard.string(forKey: "sales_number")
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
    
    @IBAction func helpbtntapped(_ sender: Any){
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
    
    func goToMainPage(){
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.keyWindow else {
                return
            }
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ViewController")
            let delegate = UIApplication.shared.delegate as? AppDelegate
            window.rootViewController = vc
            let options: UIView.AnimationOptions = .transitionCrossDissolve
            let duration: TimeInterval = 0.3
            UIView.transition(with: window, duration: duration, options: options, animations: {}, completion: nil)
        }
    }
func startSpinner(){
    spinner.startApiLoader()
    view.isUserInteractionEnabled = false
}

func stopSpinner(){
    spinner.stopApiLoader()
    view.isUserInteractionEnabled = true
}

//    let loginSpinner: UIActivityIndicatorView = {
//        let loginSpinner = UIActivityIndicatorView()
//       let view = UIActivityIndicatorView()
//     // view.backgroundColor = UIColor(white: 0, alpha: 0.7)
//        view.backgroundColor = .black
//        loginSpinner.translatesAutoresizingMaskIntoConstraints = false
//        loginSpinner.hidesWhenStopped = true
//        return loginSpinner
//    }()

}
