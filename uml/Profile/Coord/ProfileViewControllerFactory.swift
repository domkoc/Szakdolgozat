//
//  ProfileViewControllerFactory.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 12..
//

import Foundation

class ProfileViewControllerFactory {
    typealias Storyboard = StoryboardScene.Profile
    class func makeUserProfileViewController() -> UserProfileViewController {
        Storyboard.userProfileViewController.instantiate()
    }
    class func makeEditProfileViewController() -> EditProfileViewController {
        Storyboard.editProfileViewController.instantiate()
    }
}
