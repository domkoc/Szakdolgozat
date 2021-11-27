//
//  UserProfileViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 12..
//

import Foundation
import UIKit

protocol UserProfileView: BaseView {
    var presenter: UserProfilePresenterInput? { get set }
    func updateImage(_ image: UIImage)
}

class UserProfileViewController: UIViewController {
    @IBOutlet weak var profilePictureImageView: UIImageView!
    @IBOutlet weak var userDetailsTableView: UITableView!
    @IBOutlet weak var editButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var editButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var editButton: UIButton!
    var presenter: UserProfilePresenterInput?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.loadPicture()
    }
    private func customizeViews() {
        customizeImageView()
        customizeTableView()
        customizeEditButton()
    }
    private func customizeImageView() {
    }
    private func customizeTableView() {
        userDetailsTableView.dataSource = self
        userDetailsTableView.registerCell(UserProfileTableViewCell.self)
    }
    private func customizeEditButton() {
        if !(presenter?.isMyProfile() ?? false) {
            editButtonHeightConstraint.constant = 0
            editButtonTopConstraint.constant = 0
            editButton.isHidden = true
        }
    }
    @IBAction func editButtonTapped(_ sender: UIButton) {
        presenter?.navigateToEditProfile()
    }
    @IBAction func usersEventsButtonTapped(_ sender: UIButton) {
        presenter?.navigateToUsersEvents()
    }
    @IBAction func profileImageLongPressed(_ sender: UILongPressGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        } else {
            showErrorAlert(message: "Please give acces to your photos in settings", handler: nil)
        }
    }
    private func imageSelected(_ image: UIImage) {
        presenter?.uploadProfilePicture(image)
    }
}

extension UserProfileViewController: UserProfileView {
    func updateImage(_ image: UIImage) {
        profilePictureImageView.image = image
    }
}

extension UserProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter?.presentationModel.profile.getRepresentableValues().count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UserProfileTableViewCell = tableView.dequeueReusableCell()
        cell.configure(with: (presenter?.presentationModel.profile.getRepresentableValues()[indexPath.row])!)
        return cell
    }
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else { return }
        imageSelected(image)
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
