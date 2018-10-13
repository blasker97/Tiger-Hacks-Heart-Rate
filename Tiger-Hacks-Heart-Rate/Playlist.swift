//
//  Playlist.swift
//  Tiger-Hacks-Heart-Rate
//
//  Created by Rohlman, Jeffrey C. (MU-Student) on 10/13/18.
//  Copyright © 2018 Lasker, Brian (MU-Student). All rights reserved.
//

import Foundation

struct Paging: Codable{
    var href: String?
    var items: [PlaylistObject]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
}

struct PlaylistObject: Codable{
    var collaborative: Bool?
    var external_urls: ExternalURL?
    var href: String?
    var id: String?
    var images: [Image]?
    var name: String?
    var owner: User?
    var publi: Bool?
    var snapshot_id: String?
    var tracks: Tracks?
    var type: String?
    var uri: String?
}

struct ExternalURL: Codable{
    var key: String?
    var value: String?
}

struct Image: Codable{
    var height: Int?
    var url: String?
    var width: Int?
}

struct User: Codable{
    var display_name: String?
    var external_urls: ExternalURL?
    var followers: Followers?
    var href: String?
    var id: String?
    var images: [Image]?
    var type: String?
    var uri: String?
}

struct Followers: Codable{
    var href: String?
    var total: Int?
}

struct Tracks: Codable{
    var href: String?
    var total: Int?
}
