
import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    @State private var showingDeleteAlert = false
    let book: Book
    
    var body: some View {
        ScrollView{
            ZStack(alignment: .bottomTrailing){
                Image(book.genre ?? "Fantesy")
                    .resizable()
                    .scaledToFit()
                Text(book.genre?.uppercased() ?? "Fantasy")
                    .padding(10)
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                
                    .background(.black.opacity(0.75))
                    .clipShape(Capsule())
                    .offset(CGSize(width: -5, height: -5))
            }
            VStack(alignment: .center){
                Text(book.author ?? "Author")
                    .font(.title)
                    .foregroundStyle(.black.secondary)
                Text((book.date?.formatted(date: .abbreviated, time: .shortened) ?? "no date"))
                    .font(.caption)
                Text(book.review ?? "No review")
                    .padding()
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
            }
            .navigationTitle(book.title ?? "Unknown book")
            .navigationBarTitleDisplayMode(.inline)
            .alert("Delete this book?", isPresented: $showingDeleteAlert){
                Button("Delete", role: .destructive, action: deleteBook)
                Button("Cancel", role: .cancel){}
            }
            .toolbar{
                Button(){
                    showingDeleteAlert = true
                }label: {
                    Label("Delete this book", systemImage: "trash")
                }
            }
        }
    }
    func deleteBook(){
        moc.delete(book)
        try? moc.save()
        
        dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    static var previews: some View {
        let book = Book(context: moc)
        book.id = UUID()
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = Int16(4)
        book.review = "This was a great book; I really enjoyed it."
        book.date = Date.now
        return NavigationView {
            DetailView(book: book)
        }
    }
}
