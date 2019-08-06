//
//  ProteinSceneVC.swift
//  proteins
//
//  Created by Daniil KOZYR on 8/3/19.
//  Copyright © 2019 Daniil KOZYR. All rights reserved.
//

import UIKit
import SceneKit

// TODO:  When clicking on an atom display the atom type (C, H, O, etc.)

class ProteinSceneVC: UIViewController, UIApplicationDelegate {

    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
   
    var ligand = String()
    var atoms: [Atom]?
    var connections: [Connections]?

    @IBOutlet weak var sceneKit: SCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Ligand " + ligand
        appDelegate.blockRotation = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(share))
        
        sceneKit.backgroundColor = UIColor.Application.darkBlue
        view.setGradientColor(colorOne: UIColor.Application.darkBlue, colorTwo: UIColor.Application.lightBlue)
        createSceneKit(with: atoms!, with: connections!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // TODO: from landscape to back - bugfix
        appDelegate.blockRotation = true
    }
    
    @objc func share() {
        let image = sceneKit.snapshot()
        let text = "Bro, look at this piece of art. It's named Ligand + \(ligand)"
        let ac = UIActivityViewController(activityItems: [image, text], applicationActivities: nil)
        present(ac, animated: true)
    }
    
    private func createSceneKit(with atoms: [Atom], with connections: [Connections]) {
        let scene = SCNScene()
        let node = SCNNode()
        
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
    
    @objc func handleTap(sender:UITapGestureRecognizer) {
        let location = sender.location(in: sceneKit)
        let hits = sceneKit.hitTest(location, options: nil)
        if !hits.isEmpty {
            let tapNode = hits.first?.node
            // TODO: Check if geometry is sphere using tapNode.geometry

            let position = tapNode!.position
            
            let atom = atoms?.filter({ $0.x == position.x && $0.y == position.y }).first
            let atomics = atoms?.filter( { $0.x == position.x } )
            print(atom!.id)
            for atomic in atomics! {
                print(atomic.id)
            }
        } else {
            // TODO: Hide labels
            
        }
    }
}



extension SCNNode {
    
    func normalizeVector(_ iv: SCNVector3) -> SCNVector3 {
        let length = sqrt(iv.x * iv.x + iv.y * iv.y + iv.z * iv.z)
        if length == 0 {
            return SCNVector3(0.0, 0.0, 0.0)
        }
        
        return SCNVector3( iv.x / length, iv.y / length, iv.z / length)
        
    }
    
    func buildLineInTwoPointsWithRotation(from startPoint: SCNVector3,
                                          to endPoint: SCNVector3,
                                          radius: CGFloat,
                                          color: UIColor) -> SCNNode {
        let w = SCNVector3(x: endPoint.x-startPoint.x,
                           y: endPoint.y-startPoint.y,
                           z: endPoint.z-startPoint.z)
        let l = CGFloat(sqrt(w.x * w.x + w.y * w.y + w.z * w.z))
        
        if l == 0.0 {
            // two points together.
            let sphere = SCNSphere(radius: radius)
            sphere.firstMaterial?.diffuse.contents = color
            self.geometry = sphere
            self.position = startPoint
            return self
            
        }
        
        let cyl = SCNCylinder(radius: radius, height: l)
        cyl.firstMaterial?.diffuse.contents = color
        
        self.geometry = cyl
        
        //original vector of cylinder above 0,0,0
        let ov = SCNVector3(0, l/2.0,0)
        //target vector, in new coordination
        let nv = SCNVector3((endPoint.x - startPoint.x)/2.0, (endPoint.y - startPoint.y)/2.0,
                            (endPoint.z-startPoint.z)/2.0)
        
        // axis between two vector
        let av = SCNVector3( (ov.x + nv.x)/2.0, (ov.y+nv.y)/2.0, (ov.z+nv.z)/2.0)
        
        //normalized axis vector
        let av_normalized = normalizeVector(av)
        let q0 = Float(0.0) //cos(angel/2), angle is always 180 or M_PI
        let q1 = Float(av_normalized.x) // x' * sin(angle/2)
        let q2 = Float(av_normalized.y) // y' * sin(angle/2)
        let q3 = Float(av_normalized.z) // z' * sin(angle/2)
        
        let r_m11 = q0 * q0 + q1 * q1 - q2 * q2 - q3 * q3
        let r_m12 = 2 * q1 * q2 + 2 * q0 * q3
        let r_m13 = 2 * q1 * q3 - 2 * q0 * q2
        let r_m21 = 2 * q1 * q2 - 2 * q0 * q3
        let r_m22 = q0 * q0 - q1 * q1 + q2 * q2 - q3 * q3
        let r_m23 = 2 * q2 * q3 + 2 * q0 * q1
        let r_m31 = 2 * q1 * q3 + 2 * q0 * q2
        let r_m32 = 2 * q2 * q3 - 2 * q0 * q1
        let r_m33 = q0 * q0 - q1 * q1 - q2 * q2 + q3 * q3
        
        self.transform.m11 = r_m11
        self.transform.m12 = r_m12
        self.transform.m13 = r_m13
        self.transform.m14 = 0.0
        
        self.transform.m21 = r_m21
        self.transform.m22 = r_m22
        self.transform.m23 = r_m23
        self.transform.m24 = 0.0
        
        self.transform.m31 = r_m31
        self.transform.m32 = r_m32
        self.transform.m33 = r_m33
        self.transform.m34 = 0.0
        
        self.transform.m41 = (startPoint.x + endPoint.x) / 2.0
        self.transform.m42 = (startPoint.y + endPoint.y) / 2.0
        self.transform.m43 = (startPoint.z + endPoint.z) / 2.0
        self.transform.m44 = 1.0
        return self
    }
}
