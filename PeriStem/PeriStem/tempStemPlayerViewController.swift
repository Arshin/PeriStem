//
//  tempStemPlayerViewController.swift
//  PeriStem
//
//  Created by Sogol Moezzi on 2017-01-16.
//  Copyright © 2017 ArashAsh. All rights reserved.
//

import UIKit


class tempStemPlayerViewController: UIViewController {
    
    var selectedDict: Dictionary<String, Any>?
    
    //@IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initStem(stem:Dictionary<String, Any>){
        selectedDict = stem
        initiateStemPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // view will appear, reserved for animations if any
    }
    
    func initiateStemPlayer() {
        print(selectedDict as Any)
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
