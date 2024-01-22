
import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var offImage = Image(systemName: "star.slash.fill")
    var onImage = Image(systemName: "star")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    var body: some View {
        HStack{
            
            ForEach(1..<6 , id: \.self){number in
                image(for: number)
                    .foregroundStyle(number > rating ? .gray : .yellow)
                    .onTapGesture {
                        rating = number
                    }
            }
        }
    }
    func image(for number: Int) -> Image {
        if number > rating {
            return offImage
        } else {
            return onImage
        }
    }
}

#Preview {
    RatingView(rating: .constant(4))
}
