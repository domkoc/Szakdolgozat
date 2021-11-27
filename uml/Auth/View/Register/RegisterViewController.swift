//
//  RegisterViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 14..
//

import Foundation
import UIKit

protocol RegisterView: BaseView {
    var presenter: RegisterPresenterInput? { get set }
    func enableRegisterButton()
}

class RegisterViewController: UIViewController {
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var fullNameTextField: UITextField!
    @IBOutlet weak var groupTextField: UITextField!
    @IBOutlet weak var nicknameTextField: UITextField!
    private let schGroupPicker = UIPickerView()
    var presenter: RegisterPresenterInput?
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
    }
    private func customizePicker() {
        schGroupPicker.dataSource = self
        schGroupPicker.delegate = self
        schGroupPicker.selectRow(SCHgroup.allCases.count, inComponent: 0, animated: false)
    }
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        registerButton.isEnabled = false
        guard verifyInputs() else { return }
        let profileDto = ProfileUploadDto(username: emailTextField.text!,
                                          password: passwordTextField.text!,
                                          fullname: fullNameTextField.text!,
                                          nickname: nicknameTextField.text,
                                          schgroup: groupTextField.text.isEmpty ? nil : SCHgroup.init(rawValue: groupTextField.text!))
        presenter?.register(with: profileDto)
    }
    private func verifyInputs() -> Bool {
        guard !emailTextField.text.isEmpty,
              !passwordTextField.text.isEmpty,
              !fullNameTextField.text.isEmpty else {
                  showErrorAlert(message: "You need to fill all marked fields!") { _ in
                      self.registerButton.isEnabled = true
                  }
                  return false
              }
        return true
    }
}

extension RegisterViewController: RegisterView {
    func enableRegisterButton() {
        registerButton.isEnabled = true
    }
}

extension RegisterViewController: UIPickerViewDataSource {
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

extension RegisterViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row >= SCHgroup.allCases.count {
            groupTextField.text = nil
        } else {
            groupTextField.text = SCHgroup.allCases[row].rawValue
        }
    }
}
