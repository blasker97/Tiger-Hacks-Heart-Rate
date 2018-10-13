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
    
    @IBAction func getSongData(_ sender: Any) {
        appDelegate.getPlaylist(dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (playlistData, error) in
            if let error = error {
                return
            }
            guard let playlistData = playlistData else {
                return
            }
            
            for i in 0..<playlistData.items!.count{
                print(playlistData.items![i].name!)
            }
            
            
        })
        
    }
}

