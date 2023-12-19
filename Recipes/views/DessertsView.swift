import SwiftUI

struct DessertListView: View {
    @State private var desserts = [Meal]()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(desserts, id: \.idMeal) { dessert in
                        NavigationLink(destination: DessertDetailView(mealId: dessert.idMeal ?? "")) {
                            DessertCardView(dessert: dessert)
                        }
                    }
                }
                .padding()
            }
            .onAppear {
                loadDesserts()
            }
            .navigationTitle("Desserts")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(UIColor.systemGroupedBackground))
        }
    }
    
    private func loadDesserts() {
        Task {
            do {
                self.desserts = try await TheMealDbManagerImpl().fetchDesserts()
            } catch {
                print("Error loading desserts: \(error)")
            }
        }
    }
}

struct DessertCardView: View {
    var dessert: Meal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let thumbnailURL = dessert.strMealThumb, let url = URL(string: thumbnailURL) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                }
                .scaledToFill()
                .frame(height: 150) // Reduced image height
                .clipped()
                .cornerRadius(15)
            }
            
            Text(dessert.strMeal ?? "Unknown Dessert")
                .font(.title3) // Increased font size
                .fontWeight(.bold)
                .foregroundColor(.primary) // Ensures text color adapts to dark/light mode
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground)) // Adaptive background color
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
}


struct DessertListView_Previews: PreviewProvider {
    static var previews: some View {
        DessertListView()
    }
}
