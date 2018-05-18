//
//  ViewController.swift
//  HealthcareApp
//
//  Created by mac on 5/16/18.
//  Copyright © 2018 mobileappscompany. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var rememberUserNameSwitch: UISwitch!
    let viewModel = LoginViewModel()
    var observations: [NSKeyValueObservation] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()

        activityIndicator.hidesWhenStopped = true
        viewModel.delegate = self
        
        setupBindings()
        loginButton.setTitle(viewModel.buttonText, for: .normal)
        usernameField.text = viewModel.username
        rememberUserNameSwitch.isOn = viewModel.rememberUserName
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setInitialState()
        passwordField.text = ""
        if !rememberUserNameSwitch.isOn {
            usernameField.text = ""
        }
    }
    
    func setupBindings(){
        
        observations.append(viewModel.observe(\.buttonText, options: [.new]) { [weak self] _, change in
            guard let text = change.newValue else { return }
            self?.loginButton.setTitle(text, for: .normal)
        })
        
        observations.append(viewModel.observe(\.username, options: [.new]) { [weak self] _, change in
            guard let text = change.newValue else { return }
            self?.usernameField.text = text
        })
        observations.append(viewModel.observe(\.rememberUserName, options: [.new]) { [weak self] _, change in
            guard let bool = change.newValue else { return }
            self?.rememberUserNameSwitch.isOn = bool
        })
    }

    @IBAction func loginButtonPressed(_ sender: Any) {
        
        guard let username = usernameField.text,
            let password = passwordField.text else {
                return
        }
        
        let rememberUserName: Bool = rememberUserNameSwitch.isOn
        
        viewModel.login(username: username, password: password,rememberUserName: rememberUserName)
    }
}

extension ViewController: LoginViewModelDelegate {
    
    struct Route {
        static let login = "LoginSegue"
    }
    
    func stateChanged(to state: LoginViewModel.State) {
        switch state {
        case .initial:
            setInitialState()
        case .waiting:
            setWaitingState()
        case .invalid:
            setInvalidState()
        case .authenticated:
            setAuthenticatedState()
        }
    }
    
    func setAuthenticatedState(){
        performSegue(withIdentifier: Route.login, sender: nil)
    }
    
    func setInvalidState(){
        activityIndicator.stopAnimating()

        let ac = UIAlertController(title: "Error", message: "Could Not Log In", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(
            title: "Ok", style: .cancel, handler: nil)
        ac.addAction(cancelAction)
        
        present(ac, animated: true, completion: nil)
    }
    
    func setInitialState(){
        activityIndicator.stopAnimating()
    }
    
    func setWaitingState(){
        activityIndicator.startAnimating()
    }
}

