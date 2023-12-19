import SwiftUI

struct DessertDetailView: View {
    let mealId: String
    @State private var mealDetails: Meal?
    @State private var isLoading = false
    @State private var error: Error?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                if isLoading {
                    ProgressView()
                } else if let meal = mealDetails {
                    // Thumbnail Image
                    if let thumbnailURL = meal.strMealThumb, let url = URL(string: thumbnailURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                        } placeholder: {
                            ProgressView()
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                    }

                    Text(meal.strMeal ?? "Unknown Dessert")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.vertical)

                    Divider()

                    Text("Instructions")
                        .font(.title2)
                        .padding(.bottom, 2)

                    Text(meal.strInstructions ?? "No instructions")
                    
                    Divider()

                    Text("Required Ingredients")
                        .font(.title2)
                        .padding(.bottom, 2)

                    ForEach(1...20, id: \.self) { index in
                        if let ingredient = meal.valueForKey("strIngredient\(index)"),
                           let measure = meal.valueForKey("strMeasure\(index)"),
                           !ingredient.isEmpty {
                            HStack {
                                Text(ingredient)
                                Spacer()
                                Text(measure)
                            }
                            .padding(.vertical, 1)
                        }
                    }
                } else if error != nil {
                    Text("Failed to load details")
                        .foregroundColor(.red)
                }
            }
            .padding()
        }
        .onAppear {
            loadMealDetails()
        }
        .navigationTitle("Dessert Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func loadMealDetails() {
        isLoading = true
        Task {
            do {
                let details = try await TheMealDbManagerImpl().fetchMealById(id: mealId)
                mealDetails = details
            } catch {
                self.error = error
            }
            isLoading = false
        }
    }
}

extension Meal {
    func valueForKey(_ key: String) -> String? {
        let mirror = Mirror(reflecting: self)
        return mirror.children.first { $0.label == key }?.value as? String
    }
}

struct DessertDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DessertDetailView(mealId: "52977") // Use an actual meal ID for real previews
    }
}
