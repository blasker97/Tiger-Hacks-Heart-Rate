//
//  AppDelegate.swift
//  Tiger-Hacks-Heart-Rate
//
//  Created by Lasker, Brian (MU-Student) on 10/13/18.
//  Copyright © 2018 Lasker, Brian (MU-Student). All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, SPTSessionManagerDelegate, SPTAppRemoteDelegate, SPTAppRemotePlayerStateDelegate {
    
    var window: UIWindow?
    
    let SpotifyClientID = "45498c6f848a4c12ae3281851abf67af"
    let SpotifyRedirectURL = URL(string: "spotify-Tiger-Hacks-Heart-Rate://spotify-login-callback")!
    
    var pagingobject: Paging?
    
    
    lazy var configuration = SPTConfiguration(
        clientID: SpotifyClientID,
        redirectURL: SpotifyRedirectURL
    )
    
    lazy var sessionManager: SPTSessionManager = {
        if let tokenSwapURL = URL(string: "https://tiger-hacks-heart-rate.herokuapp.com/api/token"),
            let tokenRefreshURL = URL(string: "https://tiger-hacks-heart-rate.herokuapp.com/api/refresh_token") {
            self.configuration.tokenSwapURL = tokenSwapURL
            self.configuration.tokenRefreshURL = tokenRefreshURL
            self.configuration.playURI = ""
        }
        let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
        return manager
    }()
    
    lazy var appRemote: SPTAppRemote = {
        let appRemote = SPTAppRemote(configuration: configuration, logLevel: .debug)
        appRemote.delegate = self
        return appRemote
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let requestedScopes: SPTScope = [.appRemoteControl, .playlistReadCollaborative]
        self.sessionManager.initiateSession(with: requestedScopes, options: .default)
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        self.sessionManager.application(app, open: url, options: options)
        
        return true
    }
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
        self.appRemote.connectionParameters.accessToken = session.accessToken
        self.appRemote.connect()
    }
    
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
        print(error)
    }
    
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
        print(session)
    }
    
    func appRemoteDidEstablishConnection(_ appRemote: SPTAppRemote) {
        self.appRemote.playerAPI?.delegate = self
        self.appRemote.playerAPI?.subscribe(toPlayerState: { (result, error) in
            if let error = error {
                debugPrint(error.localizedDescription)
            }
        })
    }
        
    func skipToNext(_ appRemote: SPTAppRemote) {
        print("skip")
        
         self.appRemote.playerAPI?.skip(toNext: { (result, error) in
             if let error = error {
                 print(error.localizedDescription)
             }
         })
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didDisconnectWithError error: Error?) {
        print("disconnected")
    }
    
    func appRemote(_ appRemote: SPTAppRemote, didFailConnectionAttemptWithError error: Error?) {
        print("failed")
    }
    
    func playerStateDidChange(_ playerState: SPTAppRemotePlayerState) {
//        print("player state changed")
//        print("isPaused", playerState.isPaused)
//        print("track.uri", playerState.track.uri)
//        print("track.name", playerState.track.name)
//        print("track.imageIdentifier", playerState.track.imageIdentifier)
//        print("track.artist.name", playerState.track.artist.name)
//        print("track.album.name", playerState.track.album.name)
//        print("track.isSaved", playerState.track.isSaved)
//        print("playbackSpeed", playerState.playbackSpeed)
//        print("playbackOptions.isShuffling", playerState.playbackOptions.isShuffling)
//        print("playbackOptions.repeatMode", playerState.playbackOptions.repeatMode.hashValue)
//        print("playbackPosition", playerState.playbackPosition)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        if self.appRemote.isConnected {
            self.appRemote.disconnect()
        }
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        if let _ = self.appRemote.connectionParameters.accessToken {
            self.appRemote.connect()
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func getPlaylist(dispatchQueueForHandler:DispatchQueue, completionHandler: @escaping (Paging?, String?) -> Void ) {
        if self.sessionManager.session != nil{
            let at = self.sessionManager.session!.accessToken
            let urlPath: String = "https://api.spotify.com/v1/me/playlists"
            guard let up = URL(string: urlPath) else {
                dispatchQueueForHandler.async {
                    completionHandler(nil, "Couldn't get URL Object")
                }
                return
            }
            var req = URLRequest(url: up)
            req.addValue("Bearer " + at, forHTTPHeaderField: "Authorization")
            let config = URLSessionConfiguration.default
            let ftc = URLSession(configuration: config)
            let task = ftc.dataTask(with: req) { data, response, error in
                guard error == nil else{
                    print("error=\(error!)")
                    dispatchQueueForHandler.async {
                        completionHandler(nil, "Error Calling API")
                    }
                    return
                }
                guard let responseData = data else{
                    dispatchQueueForHandler.async {
                        completionHandler(nil, "No data")
                        print("no data")
                    }
                    return
                }
                
                let decoder = JSONDecoder()
                do {
                    let parse = try decoder.decode(Paging.self, from: responseData)
                    dispatchQueueForHandler.async {
                        completionHandler(parse, nil)
                    }
                }
                catch{
                    
                    dispatchQueueForHandler.async {
                        completionHandler(nil, "No data")
                        print("error decoding")
                        print(error)
                    }
                }
            }
            task.resume()
        }
        return
    }
}

