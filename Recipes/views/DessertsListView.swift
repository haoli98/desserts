import SwiftUI

/**
View that displays a list of dessert meals. Each dessert is represented with a card containing the thumbnail and name. Each  card is also a navigable link, leading to a detailed view of the dessert.
*/
struct DessertListView: View {
    @State private var desserts = [Meal]()
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(desserts, id: \.idMeal) { dessert in
                        NavigationLink(destination: DessertDetailView(mealId: dessert.idMeal!)) {
                            DessertCardView(dessert: dessert)
                        }
                    }
                }
                .padding()
                .accessibilityIdentifier("DessertsListView")
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
                self.desserts = try await TheMealDbManagerImpl().fetchDesserts();
            } catch {
                print("Error loading desserts list: \(error)")
            }
        }
    }
}

struct DessertCardView: View {
    var dessert: Meal

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: dessert.strMealThumb!)) { image in
                    image.resizable()
                } placeholder: {
                    Image(systemName: "Dessert thumbnail image")
                        .resizable()
                }
                .scaledToFill()
                .frame(height: 150)
                .clipped()
                .cornerRadius(15)
            
            Text(dessert.strMeal!)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 0)
    }
}

struct DessertListView_Previews: PreviewProvider {
    static var previews: some View {
        DessertListView()
    }
}
