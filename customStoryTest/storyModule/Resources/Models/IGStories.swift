//
//  IGStories.swift
//  InstagramStories
//
//  Created by Ranjith Kumar on 9/8/17.
//  Copyright © 2017 DrawRect. All rights reserved.
//

import Foundation

public class IGStories: Codable {
	public let flag: Bool
    public let count: Int
    public var stories: [IGStory]
    
    enum CodingKeys: String, CodingKey {
		case flag = "flag"
        case count = "total"
        case stories = "content"
    }
    func copy() throws -> IGStories {
        let data = try JSONEncoder().encode(self)
        let copy = try JSONDecoder().decode(IGStories.self, from: data)
        return copy
    }
}
