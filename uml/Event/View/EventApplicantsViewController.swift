//
//  EventApplicantsViewController.swift
//  SSSLManager_iOS
//
//  Created by Kocka Dominik Csaba on 2021. 11. 21..
//

import Foundation
import UIKit

protocol EventApplicantsView: BaseView {
    var presenter: EventApplicantsPresenterInput? { get set }
    func loadData()
}

class EventApplicantsViewController: UIViewController {
    @IBOutlet weak var applicantsTableView: UITableView!
    @IBOutlet weak var workersTableView: UITableView!
    @IBOutlet weak var acceptButtonTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var profileButton: UIButton!
    var presenter: EventApplicantsPresenterInput?
    private var selectedProfile: Profile? {
        didSet {
            profileButton.isEnabled = !(selectedProfile == nil)
            acceptButton.isEnabled = !(selectedProfile == nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        customizeViews()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter?.loadData()
        selectedProfile = nil
    }
    private func customizeViews() {
        customizeTableViews()
    }
    private func customizeTableViews() {
        applicantsTableView.delegate = self
        applicantsTableView.dataSource = self
        applicantsTableView.registerCell(EventApplicantsTableViewCell.self)
        workersTableView.delegate = self
        workersTableView.dataSource = self
        workersTableView.registerCell(EventApplicantsTableViewCell.self)
    }
    @IBAction func acceptButtonTapped(_ sender: UIButton) {
        guard let profile = self.selectedProfile else { return }
        presenter?.acceptApplicant(profile)
    }
    @IBAction func profileButtonTapped(_ sender: UIButton) {
        guard let profile = self.selectedProfile else { return }
        presenter?.navigateToProfile(of: profile)
    }
}

extension EventApplicantsViewController: EventApplicantsView {
    func loadData() {
        applicantsTableView.reloadData()
        workersTableView.reloadData()
        if !(presenter?.isOrganizer() ?? false) {
            acceptButtonTopConstraint.constant = 0
            acceptButtonHeightConstraint.constant = 0
            acceptButton.isHidden = true
        }
    }
}

extension EventApplicantsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            switch tableView {
            case applicantsTableView:
                return "Applicants"
            case workersTableView:
                return "Workers"
            default:
                return nil
            }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView {
        case applicantsTableView:
            return presenter?.presentationModel?.applicants.count ?? 0
        case workersTableView:
            return presenter?.presentationModel?.workers.count ?? 0
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableView {
        case applicantsTableView:
            let cell: EventApplicantsTableViewCell = tableView.dequeueReusableCell()
            guard let applicant = presenter?.presentationModel?.applicants[indexPath.row] else { return cell }
            cell.configure(with: EventApplicantsTableViewCellConfig(profile: applicant))
            return cell
        case workersTableView:
            let cell: EventApplicantsTableViewCell = tableView.dequeueReusableCell()
            guard let worker = presenter?.presentationModel?.workers[indexPath.row] else { return cell }
            cell.configure(with: EventApplicantsTableViewCellConfig(profile: worker))
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension EventApplicantsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch tableView {
        case applicantsTableView:
            guard let applicant = presenter?.presentationModel?.applicants[indexPath.row] else { return }
            selectedProfile = applicant
        case workersTableView:
            guard let worker = presenter?.presentationModel?.workers[indexPath.row] else { return }
            selectedProfile = worker
            acceptButton.isEnabled = false
        default:
            return
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedProfile = nil
    }
}
