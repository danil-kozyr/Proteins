//
//  ProteinSceneVC.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit
import SceneKit

class ProteinSceneVC: UIViewController {

    // MARK: - Properties
    
    private var appDelegate: AppDelegate? {
        return UIApplication.shared.delegate as? AppDelegate
    }
    
    var ligand = String()
    var atoms = [Atom]()
    var connections = [Connections]()

    // MARK: - IBOutlets
    
    @IBOutlet weak var sceneKit: SCNView!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var atomNumberLabel: UILabel!
    @IBOutlet weak var atomMassLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSceneKit()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.setGradientColor(colorOne: .black, colorTwo: .Application.darkBlue, update: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        resetOrientationToPortrait()
        appDelegate?.blockRotation = true
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        hideElementLabels(true, element: nil)
        title = "Ligand \(ligand)"
        appDelegate?.blockRotation = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonTapped)
        )
        
        sceneKit.backgroundColor = .clear
    }
    
    private func setupSceneKit() {
        create3DScene(with: atoms, connections: connections)
    }
    
    private func resetOrientationToPortrait() {
        if UIDevice.current.orientation.isLandscape {
            let portraitOrientation = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(portraitOrientation, forKey: "orientation")
        }
    }
    
    @objc private func shareButtonTapped() {
        let image = sceneKit.snapshot()
        let text = "Check out this protein visualization: Ligand \(ligand)"
        let activityViewController = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
        present(activityViewController, animated: true)
    }
    
    private func create3DScene(with atoms: [Atom], connections: [Connections]) {
        let scene = SCNScene()
        
        // Add atoms to scene
        addAtomsToScene(scene, atoms: atoms)
        
        // Add connections to scene
        addConnectionsToScene(scene, atoms: atoms, connections: connections)
        
        // Configure scene settings
        configureSceneSettings(scene)
        
        // Add tap gesture
        addTapGesture()
    }
    
    private func addAtomsToScene(_ scene: SCNScene, atoms: [Atom]) {
        for atom in atoms {
            let sphere = SCNNode(geometry: SCNSphere(radius: 0.5))
            sphere.geometry?.firstMaterial?.diffuse.contents = atom.getColor(type: atom.type)
            sphere.position = SCNVector3(atom.x, atom.y, atom.z)
            scene.rootNode.addChildNode(sphere)
        }
    }
    
    private func addConnectionsToScene(_ scene: SCNScene, atoms: [Atom], connections: [Connections]) {
        for connection in connections {
            guard let startAtom = atoms.first(where: { $0.id == connection.mainId }) else {
                continue
            }
            
            let startPosition = SCNVector3(startAtom.x, startAtom.y, startAtom.z)
            
            for endId in connection.ids {
                guard let endAtom = atoms.first(where: { $0.id == endId }) else {
                    continue
                }
                
                let endPosition = SCNVector3(endAtom.x, endAtom.y, endAtom.z)
                let connectionNode = SCNNode()
                let lineNode = connectionNode.buildLineInTwoPointsWithRotation(
                    from: startPosition,
                    to: endPosition,
                    radius: 0.2,
                    color: .cyan
                )
                scene.rootNode.addChildNode(lineNode)
            }
        }
    }
    
    private func configureSceneSettings(_ scene: SCNScene) {
        sceneKit.scene = scene
        sceneKit.autoenablesDefaultLighting = true
        sceneKit.allowsCameraControl = true
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3Make(0, 0, 25)
        scene.rootNode.addChildNode(cameraNode)
    }
    
    private func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSceneTap))
        sceneKit.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleSceneTap(_ gestureRecognizer: UIGestureRecognizer) {
        let location = gestureRecognizer.location(in: sceneKit)
        let hitResults = sceneKit.hitTest(location, options: [:])
        
        guard let result = hitResults.first else {
            hideElementLabels(true, element: nil)
            return
        }
        
        let position = result.worldCoordinates
        
        // Find the atom at this position
        if let atom = findAtom(at: position) {
            displayAtomInformation(for: atom)
        } else {
            hideElementLabels(true, element: nil)
        }
    }
    
    private func findAtom(at position: SCNVector3) -> Atom? {
        let tolerance: Float = 1.0
        
        return atoms.first { atom in
            let distance = sqrt(
                pow(atom.x - position.x, 2) +
                pow(atom.y - position.y, 2) +
                pow(atom.z - position.z, 2)
            )
            return distance <= tolerance
        }
    }
    
    private func displayAtomInformation(for atom: Atom) {
        guard let element = JSONParser().parse(elementType: atom.type) else {
            hideElementLabels(true, element: nil)
            return
        }
        
        hideElementLabels(false, element: element)
    }
    
    private func hideElementLabels(_ isHidden: Bool, element: ChemicalElement?) {
        symbolLabel.isHidden = isHidden
        nameLabel.isHidden = isHidden
        atomNumberLabel.isHidden = isHidden
        atomMassLabel.isHidden = isHidden
        summaryLabel.isHidden = isHidden
        
        guard let element = element, !isHidden else { return }
        
        symbolLabel.text = element.symbol
        nameLabel.text = element.name
        atomNumberLabel.text = "Atomic Number: \(element.atomicNumber)"
        atomMassLabel.text = "Atomic Mass: \(element.atomicMass)"
        summaryLabel.text = element.summary
    }
}
