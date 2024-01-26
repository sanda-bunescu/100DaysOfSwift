//
//  AddressView.swift
//  CupcakeCorner
//
//  Created by Sanda Bunescu on 14.10.2023.
//

import SwiftUI

struct AddressView: View {
    @ObservedObject var order: Order
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Name", text: $order.name)
                    TextField("Adress", text: $order.adress)
                    TextField("City", text: $order.city)
                    TextField("Zip code", text: $order.zip)
                }
                
                Section{
                    NavigationLink{
                        CheckOutView(order: order)
                    }label: {
                        Text("Check out")
                    }
                }
                .disabled(order.isValisAdress == false)
            }
            .navigationTitle("Address details")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    AddressView(order: Order())
}
