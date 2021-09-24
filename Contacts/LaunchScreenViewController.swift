//
//  LaunchScreenViewController.swift
//  Contacts
//
//  Created by Harikrishnan S R on 24/09/21.
//

import UIKit
import Lottie

class LaunchScreenViewController: UIViewController {

    private var animationView: AnimationView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView = .init(name: "LaunchScreen")
        
        animationView!.frame = view.bounds
        
        animationView!.contentMode = .scaleAspectFit
        
        animationView!.loopMode = .loop
        
        animationView!.animationSpeed = 0.5
        
        view.addSubview(animationView!)
        
        animationView!.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            
            self.window?.rootViewController =  UIStoryboard(name: "Main", bundle: nil)
                .instantiateViewController(withIdentifier: "ContactList")
        
        }
        
    }
    


}
