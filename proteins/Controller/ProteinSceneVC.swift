//
//  ProteinSceneVC.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit

class ProteinSceneVC: UIViewController {

    var ligand = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "Ligand " + ligand
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
    }

    @objc func share() {
//        let items = [UIImage(named: "touchID")]
//        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
//        present(ac, animated: true)
    }
    
}
