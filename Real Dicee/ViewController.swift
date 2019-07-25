//
//  ViewController.swift
//  Real Wallpaper
//
//  Created by Cheryl Liao on 7/22/19
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]

        sceneView.autoenablesDefaultLighting = true

      
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        if #available(iOS 11.3, *) {
            configuration.planeDetection = .vertical
        } else {
            // Fallback on earlier versions
        }
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            
            let touchLocation = touch.location(in: sceneView)
            
            let results = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
            
            if let hitResult = results.first {

                // Create a new scene
                let paper = SCNPlane(width: 1, height: 1)
                let material = SCNMaterial()
                
                material.diffuse.contents = UIImage(named: "art.scnassets/wallpaper.jpg")
                
                paper.materials = [material]
                
                

                let node = SCNNode()
                //
               // node.position = SCNVector3(x: 0, y: 0, z: -0.5)
                //
                node.geometry = paper
                //
                sceneView.scene.rootNode.addChildNode(node)
                
                   node.position = SCNVector3(
                        x: hitResult.worldTransform.columns.3.x,
                        y: hitResult.worldTransform.columns.3.y,
                        z: hitResult.worldTransform.columns.3.z
                    )

                    sceneView.scene.rootNode.addChildNode(node)
                    
                
                }
                
            }
            
        }

}
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if anchor is ARPlaneAnchor {
            
            let planeAnchor = anchor as! ARPlaneAnchor

            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(planeAnchor.center.x, 0, planeAnchor.center.z)
            
            let gridMaterial = SCNMaterial()
            gridMaterial.diffuse.contents = UIImage(named: "art.scnassets/grid.png")
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
            
        } else {
            return
        }
        
        //guard let planeAnchor = anchor as? ARPlaneAnchor else {return}
    }



