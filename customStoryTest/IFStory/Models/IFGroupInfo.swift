

import Foundation

public class IFGroupInfo: Codable {
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
