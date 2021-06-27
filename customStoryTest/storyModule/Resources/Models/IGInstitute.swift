//
//  IGInstitute.swift
//  TAPSocial
//
//  Created by Rezwan Islam on 26/12/20.
//  Copyright © 2020 Rezwan Islam. All rights reserved.
//

import Foundation

public class IGInstitute: Codable {
	public let imageURL: String?
	public let instituteId: String
	public let instituteName: String?
	public let instituteAccronym: String?
	
	enum CodingKeys: String, CodingKey {
		case imageURL = "imageURL"
		case instituteId = "instituteId"
		case instituteName = "instituteName"
		case instituteAccronym = "abbreviation"
	}
}
