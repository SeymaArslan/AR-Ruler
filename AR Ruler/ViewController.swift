//
//  ViewController.swift
//  AR Ruler
//
//  Created by Seyma on 18.12.2023.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    var dotNodes = [SCNNode]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touchLocation = touches.first?.location(in: sceneView) {
            if let query = sceneView.raycastQuery(from: touchLocation, allowing: .estimatedPlane, alignment: .any) {
                let results = sceneView.session.raycast(query)
                if let raycastResult = results.first {
                    addDot(at: raycastResult)
                }
            }
        }
        
    }
    
    func addDot(at raycastResult: ARRaycastResult) {
        let dotGeometry = SCNSphere(radius: 0.005)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]
        let node = SCNNode(geometry: dotGeometry)
        node.position = SCNVector3(
            x: raycastResult.worldTransform.columns.3.x,
            y: raycastResult.worldTransform.columns.3.y,
            z: raycastResult.worldTransform.columns.3.z)
        sceneView.scene.rootNode.addChildNode(node)
        dotNodes.append(node)
        if dotNodes.count >= 2 {
            calculate()
        }
    }
    
    
    func calculate() {
        let start = dotNodes[0]
        let end = dotNodes[1]
        
        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )
        
        print(abs(distance)) // abs -> mutlak değer 
    }
    
}
 
