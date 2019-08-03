//
//  ProteinsVC.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

// TODO: List all the ligands provided in ligands.txt (see resources)
// TODO: You should be able to search a ligand through the list
// TODO: If you cannot load the ligand through the website display a warning popup
// TODO: When loading the ligand you should display the spinning wheel of the activity monitor


class ProteinsVC: UIViewController {

    private var list: [String] = []
    private var filteredData: [String] = []
    private let fileReader = FileReader()
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.register(UINib(nibName: "LigandCell", bundle: nil), forCellReuseIdentifier: "ligandCell")
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 180.0
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        list = fileReader.reader()
        filteredData = list
        
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if list[0] == "Error" {
            print("Error")
            navigationController?.popViewController(animated: true)
            return
        }
    }
}

extension ProteinsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "ProteinSceneVC") as! ProteinSceneVC
        nextVC.ligand = filteredData[indexPath.row]
        self.navigationController?.pushViewController(nextVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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

extension String {
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
