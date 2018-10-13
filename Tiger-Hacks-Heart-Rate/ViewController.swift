//
//  ViewController.swift
//  Tiger-Hacks-Heart-Rate
//
//  Created by Lasker, Brian (MU-Student) on 10/13/18.
//  Copyright © 2018 Lasker, Brian (MU-Student). All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBAction func pressedSkipSong(_ sender: Any) {
        appDelegate.skipToNext(appDelegate.appRemote)
    
    }
    
}

