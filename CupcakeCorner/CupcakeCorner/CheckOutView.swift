//
//  CheckOutView.swift
//  CupcakeCorner
//
//  Created by Sanda Bunescu on 14.10.2023.
//

import SwiftUI

struct CheckOutView: View {
    @ObservedObject var order : Order
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationStack{
            VStack{
                AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg") , scale: 3){image in
                    image
                        .resizable()
                        .scaledToFit()
                }placeholder: {
                    ProgressView()
                }
                .frame(height: 233)
                Text("Your total is \(order.finalCost , format: .currency(code: "USD"))")
                    .font(.title)
                Button("Place order"){
                    Task{
                        await placeOrder()
                    }
                }
            }
            .navigationTitle("Check out")
            .navigationBarTitleDisplayMode(.inline)
            .alert(alertTitle , isPresented: $showingAlert){
                Button("Ok"){
                    //showingAlert.toggle()
                }
            }message: {
                Text(alertMessage)
            }
        }
    }
    
    func placeOrder() async{
        guard let encodedOrder = try? JSONEncoder().encode(order) else{
            print("Failed to encode")
            return
        }
        //create URL and a request for it
        let URL = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: URL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        do{
            let (data , _) = try await URLSession.shared.upload(for: request, from: encodedOrder)
            let decodedOrder = try JSONDecoder().decode(Order.self, from: data)
            alertTitle = "Thank you"
            alertMessage = "Your order for \(decodedOrder.quantity)x\(Order.types[decodedOrder.type].lowercased()) cupcakes is on its way!"
            showingAlert = true
        }catch{
            print("Checkout failed")
            alertTitle = "Sorry"
            alertMessage = "Error connecting to the server"
            showingAlert = true
        }
        
    }
}

#Preview {
    CheckOutView(order: Order())
}
