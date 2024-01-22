
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.title)]) var books: FetchedResults<Book>
    
    @State private var addViewIsShown = false
    var body: some View {
        NavigationStack{
            List{
                ForEach(books){ bookIndex in
                    NavigationLink{
                        DetailView(book: bookIndex)
                    }label: {
                        HStack{
                            EmojiRatingView(rating: bookIndex.rating)
                            VStack(alignment: .leading){
                                Text(bookIndex.title ?? "Unknown title")
                                    .font(.title)
                                    .foregroundStyle(bookIndex.rating == 1 ? Color.red : Color.black)
                                    
                                Text(bookIndex.author ?? "Unknown author")
                            }
                        }
                    }
                }
                .onDelete(perform: deleteBooks)
            }
                .navigationTitle("Bookworm")
                .toolbar{
                    ToolbarItem(placement: .topBarLeading){
                        EditButton()
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Button{
                            addViewIsShown.toggle()
                        }label: {
                            Label("Add book", systemImage: "plus")
                        }
                    }
                }
        }
        .sheet(isPresented: $addViewIsShown){
            AddBook()
        }
    }
    func deleteBooks(at offsets: IndexSet){
        
        for offset in offsets{
            let book = books[offset]
            moc.delete(book)
        }
        
        try? moc.save()
    }
}

#Preview {
    ContentView()
}
