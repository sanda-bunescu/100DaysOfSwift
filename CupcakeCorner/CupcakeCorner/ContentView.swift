
import SwiftUI

struct ContentView: View {
    @StateObject var order = Order()
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    Picker("Select type" , selection: $order.type){
                        ForEach(Order.types.indices , id: \.self){
                            Text(Order.types[$0])
                        }
                    }
                    Stepper("Number of cupcakes: \(order.quantity)", value: $order.quantity , in: 3...20)
                    
                }
                
                Section{
                    Toggle("Special requests", isOn: $order.specialRequest.animation())
                    if order.specialRequest{
                        Toggle("Extra frosting", isOn: $order.extraFrosting)
                        Toggle("Extra sprinkles", isOn: $order.extraSprinkles)
                    }
                }
                Section{
                    NavigationLink{
                        AddressView(order: order)
                    }label: {
                        Text("Delivery details")
                    }
                }
            }
            .navigationTitle("Cupcake Corner")
        }
    }
    
}

#Preview {
    ContentView()
}
