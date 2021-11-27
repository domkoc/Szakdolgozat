//
//  NewEventViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 16..
//

import Foundation
import LocationPicker
import UIKit

protocol NewEventView: BaseView {
    var presenter: NewEventPresenterInput? { get set }
    func enableDoneButton()
}

class NewEventViewController: UIViewController {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var endDateTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    private let locationPicker = LocationPickerViewController()
    private let endDatePicker = UIDatePicker()
    private let startDatePicker = UIDatePicker()
    private let dateFormatter = DateFormatter()
    private var selectedLocation: Location? {
        didSet {
            guard let _ = selectedLocation else { return }
            if let locationName = selectedLocation?.name {
                locationLabel.text = locationName
            } else {
                locationLabel.text = selectedLocation?.address
            }
        }
    }
    var presenter: NewEventPresenterInput?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
    }
    private func customizeViews() {
        customizeLocationPicker()
        customizeTextFields()
        customizeDatePicker()
        customizeDateFormatter()
    }
    private func customizeLocationPicker() {
        locationPicker.completion = { self.selectedLocation = $0 }
        locationPicker.mapType = .standard
    }
    private func customizeTextFields() {
        startDateTextField.inputView = startDatePicker
        endDateTextField.inputView = endDatePicker
    }
    private func customizeDatePicker() {
        startDatePicker.addTarget(self, action: #selector(startDateSelected), for: .allEvents)
        endDatePicker.addTarget(self, action: #selector(endDateSelected), for: .allEvents)
        if #available(iOS 13.4, *) {
            startDatePicker.preferredDatePickerStyle = .wheels
            endDatePicker.preferredDatePickerStyle = .wheels
        }
    }
    private func customizeDateFormatter() {
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
    }
    @objc private func startDateSelected() {
        startDateTextField.text = dateFormatter.string(from: startDatePicker.date)
    }
    @objc private func endDateSelected() {
        endDateTextField.text = dateFormatter.string(from: endDatePicker.date)
    }
    @IBAction func selectLocationButtonTapped(_ sender: UIButton) {
        self.navigationController?.pushViewController(locationPicker, animated: true)
    }
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        doneButton.isEnabled = false
        guard verifyInputs() else { return }
        let event = NewEvent(title: titleTextField.text!,
                             description: descriptionTextView.text,
                             startDate: startDatePicker.date,
                             endDate: endDatePicker.date,
                             location: selectedLocation!)
        presenter?.saveNewEvent(event)
    }
    private func verifyInputs() -> Bool {
        guard selectedLocation != nil,
              !titleTextField.text.isEmpty,
              !startDateTextField.text.isEmpty,
              !endDateTextField.text.isEmpty else {
                  showErrorAlert(message: "You need to fill all fields except description!") { _ in
                      self.doneButton.isEnabled = true
                  }
                  return false
              }
        return true
    }
}

extension NewEventViewController: NewEventView {
    func enableDoneButton() {
        doneButton.isEnabled = true
    }
}
