//
//  ProteinSceneVC.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit
import SceneKit

class ProteinSceneVC: UIViewController, UIApplicationDelegate {

    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var ligand = String()
    var atoms: [Atom]?
    var connections: [Connections]?

    @IBOutlet weak var sceneKit: SCNView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var atomNumberLabel: UILabel!
    @IBOutlet weak var atomMassLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isLabelHidden(true, element: nil)
        self.title = "Ligand " + ligand
        appDelegate.blockRotation = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        sceneKit.backgroundColor = .clear
        createSceneKit(with: atoms!, with: connections!)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setGradientColor(colorOne: UIColor.black,
                              colorTwo: UIColor.Application.darkBlue,
                              update: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if UIDevice.current.orientation.isLandscape {
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }

        appDelegate.blockRotation = true
    }
    
    @objc private func share() {
        let image = sceneKit.snapshot()
        let text = "Bro, look at this piece of art. It's named Ligand + \(ligand)"
        let ac = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    private func createSceneKit(with atoms: [Atom], with connections: [Connections]) {
        let node = SCNNode()
        let scene = SCNScene()
        
        // MARK: Drawing Atoms
        
        for atom in atoms {
            let sphere = SCNNode(geometry: SCNSphere(radius: 0.5))
            sphere.geometry?.firstMaterial?.diffuse.contents = atom.getColor(type: atom.type)
            sphere.position = SCNVector3(atom.x, atom.y, atom.z)
            scene.rootNode.addChildNode(sphere)
        }
        
        // MARK: Drawing Connections

        for connection in connections {
            guard let startAtom = atoms.filter( { $0.id == connection.mainId } ).first else {
                return
            }
            
            let startPosition = SCNVector3(startAtom.x, startAtom.y, startAtom.z)
            for end in connection.ids {
                guard let endAtom = atoms.filter( { $0.id == end } ).first else {
                    return
                }
                let endPosition = SCNVector3(endAtom.x, endAtom.y, endAtom.z)
                let twoPointsNode = SCNNode()
                scene.rootNode.addChildNode(twoPointsNode.buildLineInTwoPointsWithRotation(from: startPosition, to: endPosition, radius: 0.2, color: .cyan))
            }
        }

        // MARK: SceneKit Settings
        
        sceneKit.scene = scene
        sceneKit.autoenablesDefaultLighting = true
        sceneKit.allowsCameraControl = true
        node.camera = SCNCamera()
        node.position = SCNVector3Make(0, 0, 25)
        scene.rootNode.addChildNode(node)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        sceneKit.addGestureRecognizer(tap)
        
    }
    
    @objc private func handleTap(sender:UITapGestureRecognizer) {
        let location = sender.location(in: sceneKit)
        let hits = sceneKit.hitTest(location, options: nil)
        if !hits.isEmpty {
            let parser = JSONParser()
            let tapNode = hits.first?.node
            let position = tapNode!.position
            
            guard let atom = atoms?.filter({ $0.x == position.x && $0.y == position.y }).first else {
                return
            }
            let chemicalElement = parser.parse(elementType: atom.type)
            
            isLabelHidden(false, element: chemicalElement)
        } else {
            isLabelHidden(true, element: nil)
        }
    }
    
    private func isLabelHidden(_ isHidden: Bool, element: ChemicalElement?) {
        symbolLabel.isHidden = isHidden
        nameLabel.isHidden = isHidden
        atomNumberLabel.isHidden = isHidden
        atomMassLabel.isHidden = isHidden
        summaryLabel.isHidden = isHidden
        
        if !isHidden {
            setupLabels(element: element!)
        }
    }
    
    private func setupLabels(element: ChemicalElement) {
        symbolLabel.text = element.symbol
        nameLabel.text = element.name
        atomNumberLabel.text = "Atomic Number: \(element.atomicNumber)"
        atomMassLabel.text = "Atomic Mass: \(element.atomicMass)"
        summaryLabel.text = element.summary
    }
    
    
}
