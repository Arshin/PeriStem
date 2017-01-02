//
//  PlayerClass.swift
//  PeriStem
//
//  Created by Arash Ashtiani on 2016-11-27.
//  Copyright © 2016 ArashAsh. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerClass: UIViewController {
    
    var player:AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet var songLabel: UILabel!
    
    @IBOutlet var scrubSlider: UISlider!
    
    @IBOutlet var volumeSlider: UISlider!
    
    @IBAction func playButton(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if stemInPlayer != nil{
            
            songLabel.text = stemInPlayer!
            let fileToPlay:NSString = stemInPlayer! as NSString
            let fileName = fileToPlay.deletingPathExtension
            let fileExtension = fileToPlay.pathExtension
            print("filename: \(fileName), extention: \(fileExtension)")
            //let audioPath = Bundle.main.path(forResource: fileName, ofType: fileExtension)
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
