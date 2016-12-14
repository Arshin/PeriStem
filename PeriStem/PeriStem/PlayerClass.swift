//
//  PlayerClass.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2016-11-27.
//  Copyright © 2016 ArashAsh. All rights reserved.
//

import UIKit

class PlayerClass: UIViewController {

    @IBOutlet var songLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if stemInPlayer != nil{
            songLabel.text = stemInPlayer!
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
