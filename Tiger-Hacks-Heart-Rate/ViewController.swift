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
                print(error)
                return
            }
            guard let playlistData = playlistData else {
                print("no data")
                return
            }
            let group = DispatchGroup()
            group.enter()
            trackBPM1(playlistData.items![0], dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (playlistTrackData, error) in
                if let error = error{
                    print(error)
                    return
                }
                guard var playlistTrackData = playlistTrackData else{
                    print("no data")
                    return
                }
                for i in 0..<playlistTrackData.count{
                    self.appDelegate.getAnalysis(urlId: playlistTrackData[i].id, dispatchQueueForHandler: DispatchQueue.main, completionHandler: { (tempo, error) in
                        if let error = error {
                            print(error)
                            return
                        }
                        guard let tempo = tempo else {
                            print("no data")
                            return
                        }
                        playlistTrackData[i].bpm = tempo
                        print(tempo)
                    })
                }
                group.leave()
                group.notify(queue: .main){
                    for i in 0..<playlistTrackData.count{
                        print(playlistTrackData[i].name + ", " + String(playlistTrackData[i].bpm))
                    }
                }
            })
        })
    }
}

