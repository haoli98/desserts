import SwiftUI

/**
View that displays detailed information of each dessert. Contains the image, instructions of making the recipe, and the required ingriedients and associated measurements.
*/
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
                    AsyncImage(url: URL(string: meal.strMealThumb!)) { image in
                        image.resizable()
                            .accessibilityIdentifier("MealThumbnail");
                        
                    } placeholder: {
                        ProgressView()
                    }
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)

                    Text(meal.strMeal!)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.vertical)
                    Divider()
                    
                    Text("Instructions")
                        .font(.title2)
                        .padding(.bottom, 2)
                    Text(meal.strInstructions!)
                        .accessibilityIdentifier("InstructionsTitle");
                    Divider()
                    
                    Text("Required Ingredients")
                        .font(.title2)
                        .padding(.bottom, 2)
                        .accessibilityIdentifier("RequiredIngredientsText");

                    ForEach(Array(meal.ingredients.enumerated()), id: \.offset) { index, ingredient in
                        HStack {
                            Text(ingredient)
                                .accessibilityIdentifier("Ingredient");
                            Spacer()
                            Text(meal.measurements.count > index ? meal.measurements[index] : "Quantity not specified")
                                .accessibilityIdentifier("Measurement");
                        }
                        .padding(.vertical, 1)
                        .accessibilityIdentifier("DessertDetailsView")
                    }
                } else if let error = error {
                    Text("Sorry, failed to load meal details. Error: \(error.localizedDescription)")
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
                let details = try await TheMealDbManagerImpl().fetchMealById(id: mealId);
                mealDetails = details;
            } catch let fetchError {
                self.error = fetchError;
            }
            isLoading = false;
        }
    }
}

struct DessertDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DessertDetailView(mealId: "52977");
    }
}
