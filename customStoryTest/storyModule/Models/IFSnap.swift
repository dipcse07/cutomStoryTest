
import Foundation

public enum MimeType: String {
    case image
    case video
    case unknown
}
public class IFSnap: Codable {
    public let storySnapIdentifier: String
    public let mimeType: String
    public let lastUpdated: String
    public let storySnapUrl: String
	var isSeen = false
    public var kind: MimeType {
        switch mimeType {
        case MimeType.image.rawValue:
            return MimeType.image
        case MimeType.video.rawValue:
            return MimeType.video
        default:
            return MimeType.unknown
        }
    }
    enum CodingKeys: String, CodingKey {
        case storySnapIdentifier = "id"
        case mimeType = "mime_type"
        case lastUpdated = "last_updated"
        case storySnapUrl = "url"
		case isSeen = "is_seen"
    }
}
