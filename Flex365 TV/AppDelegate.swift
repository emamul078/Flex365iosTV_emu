//
//  AppDelegate.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 18/8/22.
//

import UIKit
import IQKeyboardManagerSwift
import UICKeyChainStore
import Firebase
import LGSideMenuController

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window:UIWindow?
    var sideMenuController: LGSideMenuController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.initIQKeyboard()
        self.initFireStore()
        return true
    }
    func initIQKeyboard(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    func initFireStore(){
        FirebaseApp.configure()
        self.listenFirestoreData()
    }
     //For LoginUser
    func saveUserData(userData: User){
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
        let key = "UserData\(keychain.string(forKey: "Username") ?? "")"
        do{
            let writeData = try JSONEncoder().encode(userData)
            UserDefaults.standard.set(writeData, forKey: key)
        }catch{
            print("Error Saving User Data")
        }
    }
    func getuserData() -> User?{
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
        let key = "UserData\(keychain.string(forKey: "Username") ?? "")"
        if(UserDefaults.standard.object(forKey: key) != nil){
            do{
                let readData: Data = UserDefaults.standard.value(forKey: key) as! Data
                let data : User = try JSONDecoder().decode(User.self, from: readData)
                return data
            }catch{
                return nil
            }
        }else{
            return nil
        }
    }
    
    // For Categories
    func saveCategoris(chann: Response){
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
        let key = "Chann\(keychain.string(forKey: "Username") ?? "")"
        do{
            let writeData = try JSONEncoder().encode(chann)
            UserDefaults.standard.set(writeData, forKey: key)
        }catch{
            print("Error Saving User Data")
        }
    }
    func getCategories() -> Response?{
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
        let key = "Chann\(keychain.string(forKey: "Username") ?? "")"
        if(UserDefaults.standard.object(forKey: key) != nil){
            do{
                let readchann: Data = UserDefaults.standard.value(forKey: key) as! Data
                let chann: Response = try JSONDecoder().decode(Response.self, from: readchann);
                return chann
            }catch{
                return nil
            }
        }else{
            return nil
        }
    }
    
    func listenFirestoreData(){
        let db = Firestore.firestore()
        db.collection("Flex365iOS").document("UvmtGiDD0dYqB0EVNy4q").addSnapshotListener { (snapshot, error) in
            switch (snapshot, error) {
            case (.none, .none):
                print("no data")
            case (.none, .some(let error)):
                print("some error \(error.localizedDescription)")
            case (.some(let snapshot), _):
                print("collection updated, now it contains \(snapshot) documents")
                if let snapshotData = snapshot.data(){
                    if let login64 = snapshotData["baseUrl"] as? String{
                        if(login64.count > 0){
                            UserDefaults.standard.set(self.base64DecodedString(string: login64), forKey: "baseUrl")
                        }else{
                            print("Login URL Field Is Empty")
                        }
                    }else{
                        print("Login URL Field Not Present")
                    }
                    if let wpmultisales = snapshotData["sales_number"] as? String{
                        UserDefaults.standard.set(wpmultisales, forKey: "sales_number")
                    }else{
                        print("wpmultisales Field Not Present")
                    }
                    if let wpmultisupport = snapshotData["support_number"] as? String{
                        UserDefaults.standard.set(wpmultisupport, forKey: "support_number")
                    }else{
                        print("wpmultisupport Field Not Present")
                    }
            }
        }
    }
 }
    func base64DecodedString(string : String) -> (String){
        if let decodedData = Data(base64Encoded: string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters){
            if let decodedString = String(data: decodedData, encoding: String.Encoding.utf8){
                return decodedString
            }
        }
        return ""
    }

    func encryptOrDecrypt(string : NSString) -> (String){
        let staticKey : NSString = "Ts(Trjslas"
        let chars = (0..<string.length).map({
            string.character(at: $0) ^ staticKey.character(at: $0 % staticKey.length)
        })
        return NSString(characters: chars, length: chars.count) as String
    }

    func base64DecodedStringForLogin(string : String) -> (String){
        if let decodedData = Data(base64Encoded: string, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters){
            if let decodedString = String(data: decodedData, encoding: String.Encoding.utf8){
                return encryptOrDecryptForLogin(string: decodedString as NSString)
            }
        }
        return ""
    }

    func encryptOrDecryptForLogin(string : NSString) -> (String){
        let staticKey : NSString = "Jufk8(fds"
        let chars = (0..<string.length).map({
            string.character(at: $0) ^ staticKey.character(at: $0 % staticKey.length)
        })
        return NSString(characters: chars, length: chars.count) as String
    }
    
    func isFavChannel(id:Int) -> (Bool){
        let keychain = UICKeyChainStore(service: "com.kolpolok.flex365.tv")
        let array:[Int] = UserDefaults.standard.array(forKey: "FavouriteChannelList\(keychain.string(forKey: "Username")!)") as! [Int]
        print(array.count)
        if(array.contains(id)){
            return true
        }else{
            return false
        }
    }
    
}

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
