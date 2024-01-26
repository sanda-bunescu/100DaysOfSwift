import SwiftUI

class Order : ObservableObject , Codable{
    
    enum CodingKeys: CodingKey{
        case type, quantity , extraFrosting , extraSprinkles , name , adress , city , zip
    }
    static let types = ["Vanilla" , "Strawberry" , "Chocolate" , "Rainbow"]
    @Published var type = 0
    @Published var quantity = 3
    
    @Published var specialRequest = false{
        didSet{
            if specialRequest == false{
                extraFrosting = false
                extraSprinkles = false
            }
        }
    }
    @Published var extraFrosting = false
    @Published var extraSprinkles = false
    
    @Published var name = ""
    @Published var adress = ""
    @Published var city = ""
    @Published var zip = ""
    
    var isValisAdress : Bool{
        if name.trimmingCharacters(in: .whitespaces).isEmpty || adress.trimmingCharacters(in: .whitespaces).isEmpty || city.trimmingCharacters(in: .whitespaces).isEmpty || zip.trimmingCharacters(in: .whitespaces).isEmpty{
            return false
        }
        return true
    }
    
    var finalCost: Double{
        var cost = Double(quantity) * 2
        cost += Double(type)/2
        if extraFrosting{
            cost += Double(quantity)
        }
        if extraSprinkles{
            cost += Double(quantity) / 2
        }
        
        return cost
    }
    init(){ }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(type, forKey: .type)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(extraFrosting, forKey: .extraFrosting)
        try container.encode(extraSprinkles, forKey: .extraSprinkles)
        try container.encode(name, forKey: .name)
        try container.encode(adress, forKey: .adress)
        try container.encode(city, forKey: .city)
        try container.encode(zip, forKey: .zip)
        
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        type = try container.decode(Int.self, forKey: .type)
        quantity = try container.decode(Int.self, forKey: .quantity)
        extraFrosting = try container.decode(Bool.self, forKey: .extraFrosting)
        extraSprinkles = try container.decode(Bool.self, forKey: .extraSprinkles)
        name = try container.decode(String.self, forKey: .name)
        adress = try container.decode(String.self, forKey: .adress)
        city = try container.decode(String.self, forKey: .city)
        zip = try container.decode(String.self, forKey: .zip)
    }
}
