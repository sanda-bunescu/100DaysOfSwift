
import SwiftUI

struct Friend: Codable{
    let id: UUID
    let name: String
}
struct User: Codable {
    let id: String
    let isActive: Bool
    let name: String
    let age: Int
    let company: String
    let email: String
    let address: String
    let about: String
    let registered: Date?
    let tags: [String]
    
    let friends : [Friend]

    var formatterDate: String{
        registered?.formatted(date: .abbreviated, time: .shortened) ?? "N/A"
    }
}

struct ContentView: View {
    @State private var users = [User]()
    
    @State private var searchText = ""
    var searchUsers: [User]{
        if searchText == ""{
            return users
        }
        return users.filter{$0.name.contains(searchText)}
        
    }
    @State private var onlyActiveUsers = false
    var filterredUsers: [User]{
        onlyActiveUsers ? searchUsers.filter{$0.isActive == true} : searchUsers
    }
    var body: some View {
            NavigationStack{
                List(filterredUsers , id: \.id){ user in
                    NavigationLink{
                        UserInformation(user: user)
                    }label: {
                        Text(user.name)
                    }
                }
                .task {
                    if users.isEmpty{
                        await loadData()
                    }
                }
                .navigationTitle("Users Profile List")
                .toolbar{
                    ToolbarItemGroup{
                        Button("All"){
                            onlyActiveUsers = false
                        }
                        Button("Active"){
                            onlyActiveUsers = true
                        }
                    }
                }
            }
            .searchable(text: $searchText)
            
    }
    //load JSON data from the URL and decode JSON
    func loadData()async{
        guard let URL = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid ULR")
            return
        }
        do{
            let (data,_) = try await URLSession.shared.data(from: URL)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let decodedData = try? decoder.decode([User].self, from: data){
                users = decodedData
            }
            
        }catch{
            print("Error fetching data")
        }
    }
}

#Preview {
    ContentView()
}
