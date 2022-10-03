//
//  NetworkManager.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 4/9/22.
//

import Foundation
import UICKeyChainStore
import OneSignal
import StoreKit
import Firebase
import Alamofire
import LGSideMenuController


class NetworkManager{
    
    static let shared = NetworkManager()
   var firestoreURL = "https://firestore.googleapis.com/v1/projects/flex365-app/databases/(default)/documents/Flex365iOS/UvmtGiDD0dYqB0EVNy4q"

    private init(){
        
    }
    
    func checkInternetAvailable() -> Bool {
        if let manager = NetworkReachabilityManager(){
            return manager.isReachable
        }else{
            return false
        }
    }
    
    func getFireStoreData(completion: @escaping (String) -> Void) {
        AF.request(firestoreURL, method: .get).responseString { response in
            switch response.result {
            case .success(let value):
                completion(value)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    func refreshUserData(){
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")

        var udid = keychain.string(forKey: "Udid") ?? ""
        if udid.count == 0 {
            udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
            keychain.setString(udid, forKey: "Udid")
        }

        let url = UserDefaults.standard.string(forKey: "baseUrl") ?? ""

        let params : Parameters = [
            "user_name" : keychain.string(forKey: "username") ?? "",
            "password" : keychain.string(forKey: "password") ?? "",
            "udid" : udid,
        ]

        AF.request(url, method: .post, parameters: params).responseString { response in
            switch response.result {
            case .success(let value):
                let delegate = UIApplication.shared.delegate as? AppDelegate
                let responseString = delegate?.base64DecodedStringForLogin(string: value) ?? ""
                if let jsonData = responseString.data(using: .utf8) {
                  do {
                      let userData: User = try JSONDecoder().decode(User.self, from: jsonData)
                      delegate?.saveUserData(userData: userData)
                  } catch {
                    print("Refresh Parse Error : \(error.localizedDescription)")
                  }
                }
            case .failure(let error):
                print("Refresh API Error : \(error.localizedDescription)")
            }
        }
    }
    
    func callLoginAPI(username: String, password: String, completion: @escaping (String, String) -> Void) {
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")

        var udid = keychain.string(forKey: "Udid") ?? ""
        if udid.count == 0 {
            udid = UIDevice.current.identifierForVendor?.uuidString ?? ""
            keychain.setString(udid, forKey: "Udid")
        }
        
        let url = UserDefaults.standard.string(forKey: "baseUrl") ?? ""
        print(url)

        let params : Parameters = [
            "user_name" : username,
            "password" : password,
            "udid" : udid
        ]

        AF.request(url, method: .post, parameters: params).responseString { response in
            switch response.result {
            case .success(let value):
                let delegate = UIApplication.shared.delegate as? AppDelegate
                if let jsonData = value.data(using: .utf8) {
                  do {
                      let userData: User = try JSONDecoder().decode(User.self, from: jsonData)
                      keychain.setString(username, forKey: "Username")
                      keychain.setString(password, forKey: "Password")
                      delegate?.saveUserData(userData: userData)
                      completion("Success", userData.message ?? "")
                  } catch {
                      print("Login Parse Error : \(error)")
                      completion("Failed", "JSON Parsing Error, Contact Admin")
                  }
                }else{
                    completion("Failed", "Invalid Response, Contact Admin")
                }
            case .failure(let error):
                print("Login API Error : \(error)")
                completion("Failed", "Could not connect to server")
            }
        }
    }
    
    func getChannelList(completion: @escaping (String, String) -> Void) {

            
            let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
            let username = keychain.string(forKey: "Username")
            let url :String = "http://api.flex365.tv/tv/get-category-wise-channel?username=" + username!

            AF.request(url, method: .get, parameters: nil).responseString { response in
                switch response.result {

                case .success(let value):
                    let delegate = UIApplication.shared.delegate as? AppDelegate

                    if let response = value.data(using: .utf8){
                        print("response", response)
                      do {
                          let chann: Response = try JSONDecoder().decode(Response.self, from: response)
                          delegate?.saveCategoris(chann: chann)
                          completion("Success", "Success")
                      } catch {
                          print("Channel Parse Error : \(error)")
                          completion("Failed", "JSON Parsing Error, Contact Admin")
                      }
                    }else{
                        print("called543vvv")
                        completion("Failed", "Invalid Response, Contact Admin")
                    }
                case .failure(let error):
                    print("Channel API Error : \(error)")
                    completion("Failed", "Could not connect to server")
                }
            }
        }
    
}
 


