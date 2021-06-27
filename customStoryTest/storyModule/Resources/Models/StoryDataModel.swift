//
//  StoryDataModel.swift
//  CustomStory
//
//  Created by MD SAZID HASAN DIP on 21/6/21.
//

import Foundation

struct Stories: Codable {
    let stories: [StoryProperty]
}

struct StoryProperty: Codable {
    var last_updated: String
    var title: String
    var avatar: String
    var story: [Story]
}

struct Story: Codable {
    var image: String
}
