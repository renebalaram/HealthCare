//
//  LoginViewModel.swift
//  HealthcareApp
//
//  Created by mac on 5/16/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol LoginViewModelDelegate: class {
    
    func stateChanged(to state: LoginViewModel.State)
}

@objcMembers class LoginViewModel: NSObject {
    
    @objc enum State: Int {
        case initial
        case waiting
        case invalid
        case authenticated
    }
    
    @objc dynamic var buttonText: String = "Login"
    @objc dynamic var username: String = ""
    @objc dynamic var rememberUserName: Bool = true
    
    var registered: Bool = false {
        didSet {
            if registered {
                handledRegistered()
            }else {
                handleUnRegistered()
            }
        }
    }
    
    weak var delegate: LoginViewModelDelegate?
    
    var state: State {
        didSet{
            delegate?.stateChanged(to: state)
        }
    }
    
    override init() {
        
        self.state = .initial
        registered = (UserSettings.storedUserName() != nil)
        if let remember = UserSettings.storedRrememberUserName() {
            rememberUserName = remember
        }
        
        super.init()
        
        if registered {
            handledRegistered()
        }else {
            handleUnRegistered()
        }
        
        
    }
    
    
    func handledRegistered(){
        buttonText = "Login"
        username = rememberUserName ? UserSettings.storedUserName() ?? "" : ""
    }
    
    func handleUnRegistered(){
        buttonText = "Register"
    }
    
    func login(username: String, password: String,rememberUserName: Bool){
        state = .waiting
        if !registered {
            // user is signing up
            UserSettings.saveLogin(username: username, password: password, rememberUserName: rememberUserName)
        }else {
            // user is trying to log in
            if UserSettings.login(username: username, password: password,rememberUserName: rememberUserName){
                state = .authenticated
            }else {
                state = .invalid
            }
        }
    }
}
