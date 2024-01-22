
import SwiftUI

struct AddBook: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismissAction
    @State private var title = ""
    @State private var author = ""
    @State private var genre = "Fantasy"
    @State private var rating = 0
    @State private var review = ""
    let genres = ["Poetry" , "Thriller" , "Fantasy" , "Kids" , "Horror" , "Mystery" , "Romance"]
    
    @State private var showingAlert = false
    var body: some View {
        NavigationStack{
            Form{
                Section{
                    TextField("Book name" , text: $title)
                    TextField("Book's author" , text: $author)
                    
                    Picker("Book's genre" , selection: $genre){
                        ForEach(genres , id: \.self){
                            Text($0)
                        }
                    }
                }
                Section{
                    TextEditor(text: $review)
                    RatingView(rating: $rating)
                }header: {
                    Text("Review")
                }
                Section{
                    Button("Save"){
                        if title.replacingOccurrences(of: " ", with: "").isEmpty == false && author.replacingOccurrences(of: " ", with: "").isEmpty == false && rating != 0 {
                            let book = Book(context: moc)
                            book.id = UUID()
                            book.title = title
                            book.author = author
                            book.genre = genre
                            book.review = review
                            book.rating = Int16(rating)
                            book.date = Date.now
                            if moc.hasChanges{
                                try? moc.save()
                            }
                            dismissAction()
                        }else{
                            showingAlert = true
                        }
                    }
                }
                
                
            }
        }
        .alert("Empty fields", isPresented: $showingAlert){
            
        }message: {
            Text("Books title, author and rating fields are required")
        }
    }
}

#Preview {
    AddBook()
}
