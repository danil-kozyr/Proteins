//
//  LigandCell.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class LigandCell: UITableViewCell {

    // MARK: - IBOutlets
    
    @IBOutlet weak var ligandName: UILabel!
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    // MARK: - Configuration
    
    func configure(with ligand: String) {
        ligandName.text = ligand
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
    }
}
