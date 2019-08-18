//
//  HomeVC.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/2/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    // MARK: - Properties
    
    private let biometricAuth = BiometricIDAuth()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var loginButton: RoundButton!
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setGradientColor(colorOne: .black, colorTwo: .Application.darkBlue, update: false)
    }
    
    // MARK: - IBActions
    
    @IBAction private func loginTapped(_ sender: RoundButton) {
        authenticateUser()
    }
    
    // MARK: - Private Methods
    
    private func authenticateUser() {
        biometricAuth.authenticateUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.navigateToProteinsViewController()
                case .error:
                    self?.showAuthenticationFailedAlert()
                }
            }
        }
    }
    
    private func navigateToProteinsViewController() {
        guard let storyboard = storyboard,
              let proteinsVC = storyboard.instantiateViewController(withIdentifier: "ProteinsVC") as? ProteinsVC else {
            showGenericErrorAlert()
            return
        }
        navigationController?.pushViewController(proteinsVC, animated: true)
    }
    
    private func showAuthenticationFailedAlert() {
        let alert = UIAlertController().createAlert(
            title: "Authentication Failed",
            message: "Please authorize using\nFaceID or TouchID",
            action: "OK"
        )
        present(alert, animated: true)
    }
    
    private func showGenericErrorAlert() {
        let alert = UIAlertController().createAlert(
            title: "Error",
            message: "Unable to navigate to proteins view",
            action: "OK"
        )
        present(alert, animated: true)
    }
}

