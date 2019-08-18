//
//  ProteinsVC.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class ProteinsVC: UIViewController {

    // MARK: - Properties
    
    private var ligandList: [String] = []
    private var filteredLigands: [String] = []
    private let searchController = UISearchController(searchResultsController: nil)

    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            setupTableView()
        }
    }
    
    @IBOutlet weak var indicatorBackground: RoundView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadLigandData()
        setupSearchController()
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        indicatorBackground.isHidden = true
        
        configureSearchBarAppearance()
        view.setGradientColor(colorOne: .black, colorTwo: .Application.darkBlue, update: false)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "LigandCell", bundle: nil), forCellReuseIdentifier: "ligandCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 180.0
    }
    
    private func configureSearchBarAppearance() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white
        ]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(
            string: "Search",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
    }
    
    private func loadLigandData() {
        ligandList = FileReader().reader()
        filteredLigands = ligandList
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.inputAccessoryView = createKeyboardToolbar()
        searchController.searchBar.keyboardAppearance = .dark
    }
    
    private func startLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        indicatorBackground.isHidden = false
        indicator.startAnimating()
        view.isUserInteractionEnabled = false
    }
    
    private func stopLoading() {
        view.isUserInteractionEnabled = true
        indicator.stopAnimating()
        indicatorBackground.isHidden = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    private func createKeyboardToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = UIColor(red: 25/255, green: 40/255, blue: 55/255, alpha: 0.5)
        toolbar.isTranslucent = true
        toolbar.backgroundColor = .darkGray
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        
        return toolbar
    }
    
    @objc private func dismissKeyboard() {
        searchController.isActive = false
    }
    
    private func navigateToProteinScene(with ligand: String, atoms: [Atom], connections: [Connections]) {
        guard let storyboard = storyboard,
              let proteinSceneVC = storyboard.instantiateViewController(withIdentifier: "ProteinSceneVC") as? ProteinSceneVC else {
            showErrorAlert(message: "Unable to load protein scene")
            return
        }
        
        proteinSceneVC.ligand = ligand
        proteinSceneVC.connections = connections
        proteinSceneVC.atoms = atoms
        
        let backItem = UIBarButtonItem()
        backItem.title = " "
        navigationItem.backBarButtonItem = backItem
        
        navigationController?.pushViewController(proteinSceneVC, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController().createAlert(title: "Error", message: message, action: "OK")
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDelegate

extension ProteinsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < filteredLigands.count else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        let selectedLigand = filteredLigands[indexPath.row]
        startLoading()

        RCSBDownloader().downloadConnections(for: selectedLigand) { [weak self] result in
            DispatchQueue.main.async {
                self?.stopLoading()
                tableView.deselectRow(at: indexPath, animated: true)
                
                switch result {
                case .success(let atoms, let connections):
                    self?.navigateToProteinScene(with: selectedLigand, atoms: atoms, connections: connections)
                case .error(let errorMessage):
                    self?.showErrorAlert(message: errorMessage)
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension ProteinsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLigands.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCell", for: indexPath) as? LigandCell,
              indexPath.row < filteredLigands.count else {
            return UITableViewCell()
        }
        
        cell.configure(with: filteredLigands[indexPath.row])
        return cell
    }
}

// MARK: - UISearchResultsUpdating

extension ProteinsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        if searchText.isEmpty {
            filteredLigands = ligandList
        } else {
            filteredLigands = ligandList.filter { ligand in
                ligand.lowercased().contains(searchText.lowercased())
            }
        }
        
        tableView.reloadData()
    }
}

