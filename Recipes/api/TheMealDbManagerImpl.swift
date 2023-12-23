import Foundation


// The implementation of MealManager that uses the themealdb.com endpoints to fetch information regarding dessert meals.
class TheMealDbManagerImpl : MealManager {
    private var mealDbDessertEndpoint =  "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert";
    private var mealDbMealDetailsEndpoint = "https://themealdb.com/api/json/v1/1/lookup.php";

   /** Retrieves dessert data from the `mealDbDessertEndpoint`, parses the JSON response, and converts it into an array of `Meal` objects. Entries with empty identifiers, images, and meal names are filtered out.
    */
    func fetchDesserts() async throws -> [Meal] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: mealDbDessertEndpoint)!);
        let mealsResponse = try await processJsonToMealsResponse(data: data);
        return mealsResponse.meals.filter { meal in
            !(meal.strMeal?.isEmpty ?? true) &&
            !(meal.strMealThumb?.isEmpty ?? true) &&
            !(meal.idMeal?.isEmpty ?? true);
        }
    }
    
    /** Retrieves detailed information for a specific meal identified by `id` from the `mealDbMealDetailsEndpoint`. Requests data, decodes the resulting JSON, and returns the corresponding `Meal` object if found.
    */
    func fetchMealById(id: String) async throws -> Meal? {
        var components = URLComponents(string: mealDbMealDetailsEndpoint);
        components?.queryItems = [URLQueryItem(name: "i", value: id)];
        guard let url = components?.url else {
            throw URLError(.badURL);
        }
        let (data, _) = try await URLSession.shared.data(from: url);
        return try await processJsonToMealsResponse(data: data).meals.first;
    }
    
    private func processJsonToMealsResponse(data: Data) async throws -> MealsResponse {
        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
              let mealsArray = json["meals"] as? [[String: Any]] else {
            throw URLError(.cannotParseResponse)
        }
        let preprocessedMealsArray = mealsArray.map(preprocessMealJSON);
        let preprocessedData = try JSONSerialization.data(withJSONObject: ["meals": preprocessedMealsArray], options: []);
        let mealsResponse = try JSONDecoder().decode(MealsResponse.self, from: preprocessedData);
        return mealsResponse;
    }
}

