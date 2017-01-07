//
//  popUpViewController.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2017-01-07.
//  Copyright © 2017 ArashAsh. All rights reserved.
//

import UIKit

class popUpViewController: UIViewController{

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tint the background color
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        self.showAnimate()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closePopUp(_ sender: Any) {
        //self.view.removeFromSuperview()
        self.removeAnimate()
    }

    
    // add some animation to the popup VC
    func showAnimate(){
        self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        self.view.alpha = 0.0;
        UIView.animate(withDuration: 0.2, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        })
    }
    
    func removeAnimate(){
        UIView.animate(withDuration: 0.2, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0
        }, completion: {(finished : Bool) in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
            
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
