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
        var playlists = PagingPlaylist()
        var chosenPlaylist = PlaylistObject()
        var playlistTrackData: [TrackDataBPM] = []
        
        guard appDelegate.sessionManager.session != nil else{
            print("no session")
            return
        }
        let at = appDelegate.sessionManager.session!.accessToken
        
        //Fetches playlists from given user account
        let playlistOp = BlockOperation {
            let group = DispatchGroup()
            
            group.enter()
            getPlaylist(token: at, completionHandler: { (playlistData, error) in
                if let error = error {
                    print(error)
                    return
                }
                guard let playlistData = playlistData else {
                    print("no data")
                    return
                }
                playlists = playlistData
                group.leave()
            })
            group.wait()
        }
        
        //Pulls track data for given playlist
        let trackOp = BlockOperation{
            let group = DispatchGroup()
            
            guard let items = playlists.items else{
                print("no playlists")
                return
            }
            //Picks first playlist, todo: add ability for user to choose
            chosenPlaylist = items[0]
            guard let tracks = chosenPlaylist.tracks else{
                print("Couldn't get tracks")
                return
            }
            guard let href = tracks.href else{
                print("Couldn't get track href")
                return
            }
            
            group.enter()
            getTracks(token: at, urlString: href, completionHandler:{ (trackData, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let trackData = trackData else{
                        print("no track data")
                        return
                    }
                    guard let items = trackData.items else{
                        print("no tracks")
                        return
                    }
                    if items.count > 0 {
                        for i in 0..<items.count{
                            if let t = items[i].track {
                                if let name = t.name{
                                    if let id = t.id{
                                        playlistTrackData.append(TrackDataBPM(name: name, bpm: 0, id: id))
                                    }
                                }
                            }
                        }
                    }
                    else{
                        print("no tracks in items")
                        return
                    }
                group.leave()
            })
            group.wait()
        }
        trackOp.addDependency(playlistOp)
        
        //Pulls tempo for each track provided by trackOp
        let analOp = BlockOperation{
            guard playlistTrackData.count > 0 else{
                print("no data")
                return
            }
            
            let group = DispatchGroup()
            
            for i in 0..<playlistTrackData.count{
                group.enter()
                getAnalysis(token: at, urlId: playlistTrackData[i].id, completionHandler: { (tempo, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    guard let tempo = tempo else {
                        print("no data")
                        return
                    }
                    playlistTrackData[i].bpm = tempo
                    group.leave()
                })
                group.wait()
            }
        }
        analOp.addDependency(trackOp)
        
        //Prints data for each track to console
        let printOp = BlockOperation{
            for i in 0..<playlistTrackData.count{
                print(playlistTrackData[i].name + ", " + String(playlistTrackData[i].bpm))
            }
        }
        printOp.addDependency(analOp)
        
        let playlistQueue = OperationQueue()
        playlistQueue.addOperation(playlistOp)
        playlistQueue.addOperation(trackOp)
        playlistQueue.addOperation(analOp)
        playlistQueue.addOperation(printOp)
        //lol this actually works
    }
}

