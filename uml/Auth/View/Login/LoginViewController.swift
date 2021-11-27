//
//  LoginViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import AuthenticationServices
import UIKit

protocol LoginView: BaseView {
    var presenter: LoginPresenterInput? { get set }
    func credentials() -> LoginPresentationModel
}

class LoginViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    var presenter: LoginPresenterInput?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
        emailTextField.becomeFirstResponder()
        emailTextField.text = "kocka98@gmail.com"
        passwordTextField.text = "Ab123456"
    }
    private func customizeViews() {
        
    }
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        presenter?.navigateToRegister()
    }
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        presenter?.login()
    }
}

extension LoginViewController: LoginView {
    func credentials() -> LoginPresentationModel {
        let presentationModel = LoginPresentationModel(email: emailTextField.text ?? "",
                                                       password: passwordTextField.text ?? "")
        passwordTextField.text = nil
        return presentationModel
    }
}
