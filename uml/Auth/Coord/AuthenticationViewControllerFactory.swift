//
//  AuthenticationViewControllerFactory.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 05..
//

import Foundation
import UIKit

class AuthenticationViewControllerFactory {
    typealias Storyboard = StoryboardScene.Authentication
    class func makeLoginViewController() -> LoginViewController {
        Storyboard.loginViewController.instantiate()
    }
    class func makeRegisterViewController() -> RegisterViewController {
        Storyboard.registerViewController.instantiate()
    }
}
