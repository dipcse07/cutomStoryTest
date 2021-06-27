//
//  IGGroupInfo.swift
//  TAPSocial
//
//  Created by Rezwan Islam on 26/12/20.
//  Copyright © 2020 Rezwan Islam. All rights reserved.
//

import Foundation

public class IGGroupInfo: Codable {
	var groupId:String?
	var groupName:String?
	var groupType:String?
	var normalizedGroupName:String?
	var privacyType:String?
	
	enum CodingKeys: String, CodingKey {
		case groupId = "groupId"
		case groupName = "groupName"
		case groupType = "groupType"
		case normalizedGroupName = "normalizedGroupName"
		case privacyType = "privacyType"
	}
}
