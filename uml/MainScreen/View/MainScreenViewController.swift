//
//  MainScreenViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 07..
//

import Foundation
import UIKit

protocol MainScreenView: BaseView {
    var presenter: MainScreenPresenterInput? { get set }
    func loadProfileData(_ presentationModel: MainScreenPresentationModel)
}

class MainScreenViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    var presenter: MainScreenPresenterInput?
    var presentationModel: MainScreenPresentationModel? {
        didSet {
            guard let presentationModel = self.presentationModel,
            let fullname = presentationModel.profile.fullname else { return }
            label.text = "Welcome to SSSLManager \n \(fullname)!"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter?.loadProfileData()
    }
    private func customizeViews() {
    }
    @IBAction func EventsButtonTapped(_ sender: UIButton) {
        presenter?.navigateToEvents()
    }
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        guard let profile = presentationModel?.profile else { return }
        presenter?.navigateToProfile(with: profile)
    }
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        presenter?.logout()
    }
    
}

extension MainScreenViewController: MainScreenView {
    func loadProfileData(_ presentationModel: MainScreenPresentationModel) {
        self.presentationModel = presentationModel
    }
}
