
import CoreML
import SwiftUI

struct ContentView: View {
    @State private var wakeUpTime = Date.now
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var message = ""
    var body: some View {
        NavigationView(){
            Form{
                Section{
                    DatePicker("Enter a time", selection: $wakeUpTime , displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }header: {
                    Text("When do you want to wake up?")
                }
                
                Section{
                    Stepper("\(sleepAmount.formatted())", value: $sleepAmount, in: 4...12 , step: 0.25)
                }header: {
                    Text("Desired amount of sleep")
                }
                Section{
                    Picker("Number of cups: " , selection: $coffeeAmount){
                        ForEach(0..<20){
                            Text("\($0 + 1)")
                        }
                    }
                }header: {
                    Text("Daily coffee intake")
                }
                Section{
                    Button("Calculate"){
                        calculateBedTime()
                    }
                    Text(message)
                }header: {
                    Text("Bed time")
                }
            }
            .navigationTitle("Better Rest")

        }
       
    }
    func calculateBedTime() {
        do{
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            //extracting the components of wakeUpTime with Calendar.current.dateComponents
            let wakeUp = Calendar.current.dateComponents([.hour , .minute], from: wakeUpTime)
            let hour = (wakeUp.hour ?? 0) * 60 * 60
            let minute = (wakeUp.minute ?? 0) * 60
            //obtain the time at which the user should go to sleep, from our trained model
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount , coffee: Double(coffeeAmount))
            let sleepTime = wakeUpTime - prediction.actualSleep
            message = sleepTime.formatted(date: .omitted, time: .shortened)
            
        }catch{
            message = "Something went wrong"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
