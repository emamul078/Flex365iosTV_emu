//
//  User.swift
//  Flex365 TV
//
//  Created by Emamul Hasan on 4/9/22.
//

import Foundation

struct User: Codable {
    
    let email: String?
    let message: String?
    let expire_date: String?
    let username: String
    let userpass: String
    let stream_src: String?
    let access_token: String?
    
    
    private enum CodingKeys: String, CodingKey {
        
        case email = "email"
        case message = "message"
        case expire_date = "expire_date"
        case username = "username"
        case userpass = "userpass"
        case stream_src = "stream_src"
        case access_token = "access_token"
        
    }
}
