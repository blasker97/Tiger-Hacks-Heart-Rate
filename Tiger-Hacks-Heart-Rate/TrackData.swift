//
//  TrackData.swift
//  Tiger-Hacks-Heart-Rate
//
//  Created by Lasker, Brian (MU-Student) on 10/13/18.
//  Copyright © 2018 Lasker, Brian (MU-Student). All rights reserved.
//

import Foundation

func trackBPM1(_ playlist : PlaylistObject, dispatchQueueForHandler:DispatchQueue, completionHandler: @escaping ([TrackDataBPM]?, String?) -> Void){
        guard let tracks = playlist.tracks else{
            dispatchQueueForHandler.async {
                completionHandler(nil, "Couldn't get tracks")
            }
            return
        }
        guard let href = tracks.href else{
            dispatchQueueForHandler.async {
                completionHandler(nil, "Couldn't get track href")
            }
            return
        }
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.getTracks(urlString: href, dispatchQueueForHandler: DispatchQueue.main, completionHandler:
            { (trackData, error) in
                if let error = error {
                    print(error)
                    dispatchQueueForHandler.async {
                        completionHandler(nil, "Error calling API")
                    }
                    return
                }
                guard let trackData = trackData else{
                    dispatchQueueForHandler.async {
                        completionHandler(nil, "no track data")
                    }
                    return
                }
                guard let items = trackData.items else{
                    dispatchQueueForHandler.async {
                        completionHandler(nil, "no tracks")
                    }
                    return
                }
                if items.count > 0 {
                    var playlistTrackData: [TrackDataBPM] = []
                    for i in 0..<items.count{
                        if let t = items[i].track {
                            if let name = t.name{
                                if let id = t.id{
                                    playlistTrackData.append(TrackDataBPM(name: name, bpm: 0, id: id))
                                }
                            }
                        }
                    }
                    dispatchQueueForHandler.async {
                        completionHandler(playlistTrackData, nil)
                    }
                }
                else{
                    dispatchQueueForHandler.async {
                        completionHandler(nil, "no tracks in items")
                    }
                    return
                }
        })
        return
}

