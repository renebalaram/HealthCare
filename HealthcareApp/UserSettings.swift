//
//  UserSettings.swift
//  HealthcareApp
//
//  Created by mac on 5/16/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import Foundation


class UserSettings {
    
    struct Keys {
        static let service = "MyService"
        static let username = "username"
        static let rememberUserName = "rememberUserName"
    }
    
    class func storedUserName()->String? {
        return UserDefaults.standard.object(forKey: Keys.username) as? String
    }
    
    class func storedRrememberUserName()->Bool? {
        return UserDefaults.standard.object(forKey: Keys.rememberUserName) as? Bool
    }
    
    class func login(username: String, password: String, rememberUserName: Bool) -> Bool {
        
        // read the stored username and make sure it matches
        guard let storedUsername = storedUserName(),
            username == storedUsername else { return false }
        
        // read the stored password
        guard let storedPassword = try? KeychainPasswordItem(service: Keys.service, account: username).readPassword() else { return false }
        
        UserDefaults.standard.set(
            rememberUserName,
            forKey: Keys.rememberUserName)
        
        // return true if the given password matches and false otherwise
        return (password == storedPassword)
    }
    
//    class func saveUsername(_ username: String){
//        UserDefaults.standard.set(username, forKey: Keys.username)
//    }
    
    class func saveLogin(username: String, password: String, rememberUserName: Bool){
        //UserDefaults.standard.set(, forKey: <#T##String#>)
        do {
            // store username
            UserDefaults.standard.set(
                username,
                forKey: Keys.username)
            UserDefaults.standard.set(
                rememberUserName,
                forKey: Keys.rememberUserName)

            // encrypt and store password, associate with username
            try KeychainPasswordItem(
                service: Keys.service,
                account: username).savePassword(password)
        }catch {
            print("Could not save login info")
        }
    }
    
}
