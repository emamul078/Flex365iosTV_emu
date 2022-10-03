
struct Channels: Codable{

    let channel_name: String
    let id: Int
    let channel_image_app: String

    private enum CodingKeys: String, CodingKey {
        case channel_name = "channel_name"
        case id = "id"
        case channel_image_app = "channel_image_app"
        
    }

}
