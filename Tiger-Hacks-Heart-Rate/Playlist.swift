//
//  Playlist.swift
//  Tiger-Hacks-Heart-Rate
//
//  Created by Rohlman, Jeffrey C. (MU-Student) on 10/13/18.
//  Copyright © 2018 Lasker, Brian (MU-Student). All rights reserved.
//

import Foundation

struct paging: Codable{
    var href: String?
    var items: [playlistObject]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
}

struct playlistObject: Codable{
    var collaborative: Bool?
    var external_urls: externalURL?
    var href: String?
    var id: String?
    var images: [image]?
    var name: String?
    var owner: user?
    var publi: Bool?
    var snapshot_id: String?
    var tracks: tracks?
    var type: String?
    var uri: String?
}

struct externalURL: Codable{
    var key: String?
    var value: String?
}

struct image: Codable{
    var height: Int?
    var url: String?
    var width: Int?
}

struct user: Codable{
    var display_name: String?
    var external_urls: externalURL?
    var followers: followers?
    var href: String?
    var id: String?
    var images: [image]?
    var type: String?
    var uri: String?
}

struct followers: Codable{
    var href: String?
    var total: Int?
}

struct tracks: Codable{
    var href: String?
    var total: Int?
}
