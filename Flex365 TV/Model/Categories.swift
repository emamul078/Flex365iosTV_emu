struct Categories: Codable{
    let category_name: String?
    var channels: [Channels]?
    var isExpanded: Bool?

    init(category_name: String, channels: [Channels], isExpanded: Bool) {
        self.category_name = category_name
        self.channels = channels
        self.isExpanded = isExpanded
    }
}
