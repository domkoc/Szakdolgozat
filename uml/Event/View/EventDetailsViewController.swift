//
//  EventDetailsViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 16..
//

import Foundation
import MapKit
import UIKit

protocol EventDetailsView: BaseView {
    var presenter: EventDetailsPresenterInput? { get set }
    func loadData(_ presentationModel: EventDetailsPresentationModel)
    func toggleApplyButtonState(didApply: Bool)
    func toggleAppliabilityState(appliable: Bool)
    func updateImage(_ image: UIImage)
}

class EventDetailsViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationMapView: MKMapView!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var contentScrollView: UIScrollView!
    var presenter: EventDetailsPresenterInput?
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.loadEventData()
        presenter?.loadImage()
        contentScrollView.flashScrollIndicators()
    }
    private func customizeViews() {
        customizeApplyButton()
    }
    private func customizeApplyButton() {
        applyButton.setTitle("Apply", for: .normal)
        applyButton.tintColor = Colors.greenColor.color
        applyButton.setTitle("Not applyable", for: .disabled)
    }
    @IBAction func usernameButtonTapped(_ sender: UIButton) {
        presenter?.navigateToOrganizerProfile()
    }
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        guard let isOrganizer = presenter?.isOrganizer() else { return }
        if isOrganizer {
            presenter?.toggleAppliability()
        } else {
            presenter?.applyToEvent()
        }
    }
    @IBAction func listApplicationsButtonTapped(_ sender: UIButton) {
        presenter?.navigateToEventApplications()
    }
    @IBAction func listSubEventsButtonTapped(_ sender: UIButton) {
        presenter?.navigateToSubEvents()
    }
    @IBAction func imageViewLongPressed(_ sender: UILongPressGestureRecognizer) {
        if presenter?.isOrganizer() ?? false {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePickerController = UIImagePickerController()
                imagePickerController.delegate = self
                imagePickerController.sourceType = .photoLibrary
                present(imagePickerController, animated: true, completion: nil)
            } else {
                showErrorAlert(message: "Please give acces to your photos in settings", handler: nil)
            }
        }
    }
    private func imageSelected(_ image: UIImage) {
        presenter?.uploadEventPicture(image)
    }
}

extension EventDetailsViewController: EventDetailsView {
    func loadData(_ presentationModel: EventDetailsPresentationModel) {
        titleLabel.text = presentationModel.event.title
        if let nickname = presentationModel.organizer?.nickname {
            usernameButton.setTitle(nickname, for: .normal)
        } else {
            usernameButton.setTitle(presentationModel.organizer?.fullname, for: .normal)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        dateLabel.text = "\(dateFormatter.string(from: presentationModel.event.startDate)) - \(dateFormatter.string(from: presentationModel.event.endDate))"
        let annotation = MKPointAnnotation()
        let location = presentationModel.event.location.coordinate
        annotation.coordinate = location
        locationMapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        locationMapView.setRegion(region, animated: true)
        if presenter?.isOrganizer() ?? false {
            toggleAppliabilityState(appliable: presentationModel.event.isApplyable)
        } else {
            toggleApplyButtonState(didApply: presentationModel.didApplyToEvent ?? false)
            applyButton.isEnabled = presentationModel.event.isApplyable
        }
    }
    func toggleApplyButtonState(didApply: Bool) {
        if didApply {
            applyButton.setTitle("Un-Apply", for: .normal)
            applyButton.tintColor = Colors.redColor.color
        } else {
            applyButton.setTitle("Apply", for: .normal)
            applyButton.tintColor = Colors.greenColor.color
        }
    }
    func toggleAppliabilityState(appliable: Bool) {
        if appliable {
            applyButton.setTitle("Close applications", for: .normal)
            applyButton.tintColor = Colors.redColor.color
        } else {
            applyButton.setTitle("Open applications", for: .normal)
            applyButton.tintColor = Colors.greenColor.color
        }
    }
    func updateImage(_ image: UIImage) {
        imageView.image = image
        contentScrollView.flashScrollIndicators()
    }
}

extension EventDetailsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
