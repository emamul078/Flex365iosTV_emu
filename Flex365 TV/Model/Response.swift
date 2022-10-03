
struct Response: Codable{
    let categoriesArray: [Categories]

    
private enum CodingKeys: String, CodingKey {
    
        case categoriesArray = "categories"

    
    }
}
