//
//  GetPlaylistBPM.swift
//  Tiger-Hacks-Heart-Rate
//
//  Created by Jeffrey Rohlman on 10/30/18.
//  Copyright © 2018 Lasker, Brian (MU-Student). All rights reserved.
//

import Foundation

func getPlaylist(token: String, completionHandler: @escaping (PagingPlaylist?, String?) -> Void ) {
        let urlPath: String = "https://api.spotify.com/v1/me/playlists"
        guard let up = URL(string: urlPath) else {
            completionHandler(nil, "Couldn't get URL Object")
            return
        }
        var req = URLRequest(url: up)
        req.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let config = URLSessionConfiguration.default
        let ftc = URLSession(configuration: config)
        let _ = ftc.dataTask(with: req) { data, response, error in
            guard error == nil else{
                completionHandler(nil, "Error Calling API")
                return
            }
            guard let responseData = data else{
                completionHandler(nil, "No data")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let parse = try decoder.decode(PagingPlaylist.self, from: responseData)
                completionHandler(parse, nil)
            }
            catch{
                completionHandler(nil, "No data")
            }
        }.resume()
    return
}


func getTracks(token: String, urlString: String, completionHandler: @escaping (PagingTracks?, String?) -> Void ) {
        let urlPath = urlString
        guard let up = URL(string: urlPath) else {
            completionHandler(nil, "Couldn't get URL Object")
            return
        }
        var req = URLRequest(url: up)
        req.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let config = URLSessionConfiguration.default
        let ftc = URLSession(configuration: config)
        let _ = ftc.dataTask(with: req) { data, response, error in
            guard error == nil else{
                completionHandler(nil, "Error Calling API")
                return
            }
            guard let responseData = data else{
                completionHandler(nil, "No data")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let parse = try decoder.decode(PagingTracks.self, from: responseData)
                completionHandler(parse, nil)
            }
            catch{
                completionHandler(nil, "No data")
            }
        }.resume()
    return
}

func getAnalysis(token: String, urlId: String, completionHandler: @escaping (Float?, String?) -> Void ) {
        let urlPath = "https://api.spotify.com/v1/audio-features/" + urlId
        guard let up = URL(string: urlPath) else {
            completionHandler(nil, "Couldn't get URL Object")
            return
        }
        var req = URLRequest(url: up)
        req.addValue("Bearer " + token, forHTTPHeaderField: "Authorization")
        let config = URLSessionConfiguration.default
        let ftc = URLSession(configuration: config)
        let _ = ftc.dataTask(with: req) { data, response, error in
            guard error == nil else{
                completionHandler(nil, "Error Calling API")
                return
            }
            guard let responseData = data else{
                completionHandler(nil, "No data")
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let parse = try decoder.decode(AudioFeatures.self, from: responseData)
                let tempo = parse.tempo
                completionHandler(tempo, nil)
            }
            catch{
                completionHandler(nil, "No data")
            }
        }.resume()
    return
}
