//
//  ProteinSceneVC.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit
import SceneKit


// TODO:  Display the ligand model in 3D
// TODO:  You must use CPK coloring
// TODO:  You should at least represent the ligand using Balls and Sticks model
// TODO:  When clicking on an atom display the atom type (C, H, O, etc.)
// TODO:  Share your modelisation through a ‘Share‘ button
// TODO:  You should be able to ‘play‘ (zoom, rotate...) with the ligand in Scene Kit

class ProteinSceneVC: UIViewController {

    var ligand = String()
    var atoms: [Atom]?
    var connections: [Connections]?

    @IBOutlet weak var sceneKit: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ligand " + ligand
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))

        guard atoms != nil, connections != nil else {
            // TODO: Error
            return
        }
        
        createSceneKit(with: atoms!, with: connections!)
    }
    
    @objc func share() {
//         TODO: Share Button
        let image = UIImage(named: "11560")
        let text = "Study, because your Teacher will ask it tomorrow! @dkozyr"
        let ac = UIActivityViewController(activityItems: [image!, text], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    func createSceneKit(with atoms: [Atom], with connections: [Connections]) {
        let scene = SCNScene()

        // MARK: Createing Atoms
        
        for atom in atoms {
            let sphere = SCNNode(geometry: SCNSphere(radius: 0.5))
            sphere.geometry?.firstMaterial?.diffuse.contents = atom.getColor(type: atom.type)
            sphere.position = SCNVector3(atom.x, atom.y, atom.z)
            scene.rootNode.addChildNode(sphere)
        }
        
        // TODO: Creating Connections
        

        
        // MARK: SceneKit Settings
        
        sceneKit.scene = scene
        sceneKit.autoenablesDefaultLighting = true
        sceneKit.allowsCameraControl = true
        
        /// MARK: Camera
        
        let node = SCNNode()
        node.camera = SCNCamera()
        node.position = SCNVector3Make(0, 0, 25)
        scene.rootNode.addChildNode(node)
    }

}

extension SCNGeometry {
    class func line(from vector1: SCNVector3, to vector2: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]
        let source = SCNGeometrySource(vertices: [vector1, vector2])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)
        return SCNGeometry(sources: [source], elements: [element])
    }
}



