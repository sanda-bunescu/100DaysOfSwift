
import SwiftUI

struct UserInformation: View {
    let user: User
    var body: some View {
        ScrollView{
            VStack(alignment: .listRowSeparatorLeading){
                VStack(alignment: .leading){
                    Text(user.name)
                        .font(.title.bold())
                    Text("Age: \(user.age)")
                        .font(.title2)
                    Text("Company: \(user.company)")
                        .font(.title3.weight(.thin))
                        .opacity(0.7)
                }
                ScrollView(.horizontal, showsIndicators: false) {
                   HStack(spacing: 10) {
                       ForEach(user.tags, id: \.self) { tag in
                           Text(tag)
                               .padding(10)
                               .font(.system(size: 16))
                               .foregroundColor(.white)
                               .background(Color.black)
                               .cornerRadius(10)
                       }
                   }
                }
                .padding(.top)
                //.shadow(color: .black ,radius: 30)
                
                VStack(alignment: .leading){
                    Text("About me:")
                        .font(.title3)
                        .opacity(0.5)
                    Text(user.about)
                       .lineSpacing(8)
                       .padding([.top,.bottom])
                       .fixedSize(horizontal: false, vertical: true)
                }
                .padding()
                VStack(alignment: .leading){
                    Text("Contacts Ionformation:")
                        .padding(.bottom , 10)
                        .font(.title3)
                        .opacity(0.5)
                    
                    Text("Email: \(user.email)")
                    Text("Address: \(user.address)")
                }
                
                
                
                
                Text(user.formatterDate)
                    .font(.subheadline)
                    .opacity(0.5)
                    .padding(20)
            }
        }
    }
}
