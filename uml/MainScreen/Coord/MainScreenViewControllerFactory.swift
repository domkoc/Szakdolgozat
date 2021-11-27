//
//  MainScreenViewControllerFactory.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 07..
//

import Foundation
import UIKit

class MainScreenViewControllerFactory {
    typealias Storyboard = StoryboardScene.MainScreen
    class func makeMainScreenViewController() -> MainScreenViewController {
        Storyboard.mainScreenViewController.instantiate()
    }
}
