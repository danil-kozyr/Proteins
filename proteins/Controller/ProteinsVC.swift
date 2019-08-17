//
//  ProteinsVC.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class ProteinsVC: UIViewController {

    private var list: [String] = []
    private var filteredData: [String] = []
    private let searchController = UISearchController(searchResultsController: nil)

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "LigandCell", bundle: nil), forCellReuseIdentifier: "ligandCell")
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 180.0
        }
    }
    
    @IBOutlet weak var indicatorBackground: RoundView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        indicatorBackground.isHidden = true

        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        view.setGradientColor(colorOne: UIColor.black,
                              colorTwo: UIColor.Application.darkBlue, update: false)
        
        list = FileReader().reader()
        filteredData = list
        
        setupSearchController()
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.inputAccessoryView = addToolbar()
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
    
    private func addToolbar() -> UIToolbar {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.barTintColor = UIColor(red: 25/255, green: 40/255, blue: 55/255, alpha: 0.5)
        toolbar.isTranslucent = true
        toolbar.backgroundColor = .darkGray
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClicked))
        toolbar.setItems([flexibleSpace, doneButton], animated: false)
        return toolbar
    }
    
    @objc private func doneClicked() {
        searchController.isActive = false
    }
    
}

extension ProteinsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        startLoading()

        RCSBDownloader().downloadConnections(for: filteredData[indexPath.row]) { [weak self] (result) in
            switch result {
            case .success(let atoms, let connections):
                DispatchQueue.main.async {
                    let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "ProteinSceneVC") as! ProteinSceneVC
                    
                    guard let filtered = self?.filteredData[indexPath.row] else {
                        let alert = UIAlertController().createAlert(title: "Error", message: "Search is incorrect", action: "Ok")
                        self?.present(alert, animated: true)
                        self?.stopLoading()
                        return
                    }
                    
                    nextVC.ligand = filtered
                    nextVC.connections = connections
                    nextVC.atoms = atoms
                    
                    let backItem = UIBarButtonItem()
                    backItem.title = " "
                    self?.navigationItem.backBarButtonItem = backItem
                    
                    self?.stopLoading()

                    self?.navigationController?.pushViewController(nextVC, animated: true)
                }
            case .error(let errorString):
                DispatchQueue.main.async {
                    tableView.deselectRow(at: indexPath, animated: true)
                    let alert = UIAlertController().createAlert(title: "Error", message: errorString, action: "Ok")
                    self?.present(alert, animated: true)
                    self?.stopLoading()
                }
                
                return
            }
        }
    }
    
}

extension ProteinsVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ligandCell", for: indexPath) as! LigandCell
        let ligand = filteredData[indexPath.row]
        cell.ligandName.text = ligand
        cell.backgroundColor = .clear
        return cell
    }
    
    
}

extension ProteinsVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filteredData.removeAll()
        
        guard let searchText = searchController.searchBar.text else {
            return
        }
        if searchText.isEmpty {
            filteredData = list
            self.tableView.reloadData()
            return
        }

        for ligand in list {
            if ligand.containsIgnoringCase(find: searchText) {
                filteredData.append(ligand)
            }
        }
        
        self.tableView.reloadData()
    }
}

