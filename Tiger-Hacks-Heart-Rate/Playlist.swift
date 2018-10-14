//
//  Playlist.swift
//  Tiger-Hacks-Heart-Rate
//
//  Created by Rohlman, Jeffrey C. (MU-Student) on 10/13/18.
//  Copyright © 2018 Lasker, Brian (MU-Student). All rights reserved.
//

import Foundation

struct PagingPlaylist: Codable{
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
    var tracks: PlaylistTracks?
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

struct PlaylistTracks: Codable{
    var href: String?
    var total: Int?
}

struct PagingTracks: Codable {
    var href: String?
    var items: [PlaylistTrack]?
    var limit: Int?
    var next: String?
    var offset: Int?
    var previous: String?
    var total: Int?
}

struct PlaylistTrack: Codable {
    var added_at: String?
    var added_by: User?
    var is_local: Bool?
    var track: Track?
}

struct Track: Codable{
    var album: Album?
    var artists: [Artist]?
    var available_markets: [String]?
    var disc_number: Int?
    var duration_ms: Int?
    var explicit: Bool?
    var external_ids: ExternalIDs?
    var external_urls: ExternalURL?
    var href: String?
    var id: String?
    var is_playable: Bool?
    var linked_from: TrackLink?
    var restrictions: Restrictions?
    var name: String?
    var popularity: Int?
    var preview_url: String?
    var track_number: Int?
    var type: String?
    var uri: String?
    var is_local: Bool?
}

struct Album: Codable{
    var album_group: String?
    var album_type: String?
    var artists: [Artist]?
    var available_markets: [String]?
    var external_urls: ExternalURL?
    var href: String?
    var id: String?
    var images: [Image]?
    var name: String?
    var release_date: String?
    var release_date_precision: String?
    var restrictions: Restrictions?
    var type: String?
    var uri: String?
}

struct Artist: Codable{
    var external_urls: ExternalURL?
    var href: String?
    var id: String?
    var name: String?
    var type: String?
    var uri: String?
}

struct Restrictions: Codable {
    var reason: String?
    var market: String?
}

struct ExternalIDs: Codable {
    var key: String?
    var value: String?
}

struct TrackLink: Codable {
    var external_urls: ExternalURL?
    var href: String?
    var id: String?
    var type: String?
    var uri: String?
}

struct TrackDataBPM {
    var name: String
    var bpm: Float
}

struct AudioFeatures: Codable{
    var acousticness: Float?
    var analysis_url: String?
    var danceability: Float?
    var duration_ms: Int?
    var energy: Float?
    var id: String?
    var instrumentalness: Float?
    var key: Int?
    var liveness: Float?
    var loudness: Float?
    var mode: Int?
    var speechiness: Float?
    var tempo: Float?
    var time_signature: Int?
    var track_href: String?
    var type: String?
    var uri: String?
    var valence: Float?
}
