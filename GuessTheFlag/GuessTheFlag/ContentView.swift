
import SwiftUI
struct FlagImage: ViewModifier{
    func body(content: Content) -> some View {
        content
            .clipShape(Capsule())
            .shadow(radius: 10)
    }
}

struct textModifier : ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.bold().monospaced())
            .foregroundColor(.indigo)
    }
}

struct AnimationModifier: ViewModifier{
    let angle: Double
    let tapped: Bool
    let scaleAmount: Double
    func body(content: Content) -> some View {
        content
            .opacity(tapped == false ? 0.25 : 1.0)
            .rotation3DEffect(Angle(degrees: angle), axis: (x: 0 , y: 1 , z: 0))
            .scaleEffect(tapped == true ? scaleAmount : 1.0)
            .animation(.easeOut(duration: 1).repeatCount(1 , autoreverses: true), value: scaleAmount)
    }
}
struct ContentView: View {
    @State private var score = 0
    @State private var showingScore = false
    @State private var gameEnd = false
    @State private var nrOfGuesses = 0
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
    @State private var randomCountryName = Int.random(in: 0...2)
    @State private var pressedFlag = 0
    
    @State private var angles = [0.0 , 0.0 , 0.0]
    @State private var tapped = [true , true , true]
    @State private var scaleEffectAmount = 1.0
    var body: some View {
        ZStack{
            LinearGradient(colors: [.blue , .cyan], startPoint: .bottom, endPoint: .top)
                .ignoresSafeArea()
            VStack{
                Spacer()
                Text("Guess The Flag")
                    .modifier(textModifier())
                VStack(spacing: 1){
                    VStack{
                        Text("Flag of")
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.heavy))
                        Text(countries[randomCountryName]).foregroundColor(.white)
                            .font(.title2.weight(.heavy))
                    }
                    ForEach (0..<3){ flag in
                        Button{
                            withAnimation{
                                angles[flag] += 360
                                tapped = Array(repeating: false, count: 3)
                                tapped[flag] = true
                                scaleEffectAmount += 0.1
                            }
                            nrOfGuesses += 1
                            flagPressed(flag)
                        }label:{
                            Image(countries[flag])
                                .renderingMode(.original)
                                .modifier(FlagImage())
                        }
                        .modifier(AnimationModifier(angle: angles[flag], tapped: tapped[flag] , scaleAmount: scaleEffectAmount))
                        
                        
                    }
                    .padding()
                    
                }
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 50))
                .padding()
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .modifier(textModifier())
                Spacer()
            }
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue"){
                continueGame()
                tapped = Array(repeating: true, count: 3)
                scaleEffectAmount = 1.0
            }
        } message: {
            Text(scoreTitle.elementsEqual("Right") ? "Your score is \(score)" : "Your score is \(score) \nThat is the flag of \(countries[pressedFlag])")
            
        }
        .alert("End of the game" , isPresented: $gameEnd){
            Button("Restart"){
                restartGame()
                continueGame()
                tapped = Array(repeating: true, count: 3)
                scaleEffectAmount = 1.0
            }
        }message: {
            Text("Your final score is \(score)")
        }
    }
    
    func flagPressed(_ flag : Int)
    {
        if nrOfGuesses == 8{
            score = flag == randomCountryName ? score + 1 : score - 1
            gameEnd = true
            return
        }
        if flag == randomCountryName {
            scoreTitle = "Right"
            score += 1
        }
        else
        {
            scoreTitle = "Wrong"
            score -= 1
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5 ){
            showingScore = true
        }
    }
    func continueGame(){
        countries.shuffle()
        randomCountryName = Int.random(in: 0...2)
    }
    func restartGame(){
        score = 0;
        nrOfGuesses = 0;
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

