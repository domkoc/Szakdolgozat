//
//  EditProfileViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 14..
//

import Foundation
import UIKit

protocol EditProfileView: BaseView {
    var presenter: EditProfilePresenterInput? { get set }
    func enableSaveButton()
}

class EditProfileViewController: UIViewController {
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    private let schGroupPicker = UIPickerView()
    var presenter: EditProfilePresenterInput?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
    }
    private func customizeViews() {
        customizeTextFields()
        customizePicker()
    }
    private func customizeTextFields() {
        groupTextField.inputView = schGroupPicker
        emailTextField.text = presenter?.getPresentationModel().profile.username
        fullNameTextField.text = presenter?.getPresentationModel().profile.fullname
        groupTextField.text = presenter?.getPresentationModel().profile.schgroup?.rawValue
        nicknameTextField.text = presenter?.getPresentationModel().profile.nickname
    }
    private func customizePicker() {
        schGroupPicker.dataSource = self
        schGroupPicker.delegate = self
        schGroupPicker.selectRow(SCHgroup.allCases.count, inComponent: 0, animated: false)
    }
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        saveButton.isEnabled = false
        guard verifyInputs(),
        let userid = presenter?.getIdOfUser() else { return }
        let changedProfile = EditedProfileCredentials(id: userid,
                                                      email: emailTextField.text!,
                                                      fullname: fullNameTextField.text!,
                                                      group: groupTextField.text.isEmpty ? nil : SCHgroup.init(rawValue: groupTextField.text!),
                                                      nickname: nicknameTextField.text)
        presenter?.saveChanges(with: changedProfile)
    }
    private func verifyInputs() -> Bool {
        guard !emailTextField.text.isEmpty,
              !fullNameTextField.text.isEmpty else {
                  showErrorAlert(message: "You need to fill all marked fields!") { _ in
                      self.saveButton.isEnabled = true
                  }
                  return false
              }
        return true
    }
}

extension EditProfileViewController: EditProfileView {
    func enableSaveButton() {
        saveButton.isEnabled = true
    }
}

extension EditProfileViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        SCHgroup.allCases.count + 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row >= SCHgroup.allCases.count {
            return "-"
        } else {
            return SCHgroup.allCases[row].stringValue
        }
    }
}

extension EditProfileViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row >= SCHgroup.allCases.count {
            groupTextField.text = nil
        } else {
            groupTextField.text = SCHgroup.allCases[row].rawValue
        }
    }
}
