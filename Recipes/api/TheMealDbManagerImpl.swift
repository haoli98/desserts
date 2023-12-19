import Foundation

// Implementation of MealManger using themealdb.com APIs to fetch dessert meal information.
class TheMealDbManagerImpl : MealManager {
    
    private var mealDbDessertEndpoint =  "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert";
    private var mealDbMealDetailsEndpoint = "https://themealdb.com/api/json/v1/1/lookup.php";
    
    func fetchDesserts() async throws -> [Meal] {
        let (data, _) = try await URLSession.shared.data(from: URL(string: mealDbDessertEndpoint)!);
        let mealsResponse = try JSONDecoder().decode(MealsResponse.self, from: data)
        return mealsResponse.meals.filter { meal in
            !(meal.strMeal?.isEmpty ?? true) &&
            !(meal.strMealThumb?.isEmpty ?? true) &&
            !(meal.idMeal?.isEmpty ?? true);
        }
    }
    
    func fetchMealById(id: String) async throws -> Meal? {
        var components = URLComponents(string: mealDbMealDetailsEndpoint);
        components?.queryItems = [URLQueryItem(name: "i", value: id)];
        
        guard let url = components?.url else {
            throw URLError(.badURL);
        }
        
        let (data, _) = try await URLSession.shared.data(from: url);
        let mealsResponse = try JSONDecoder().decode(MealsResponse.self, from: data);
        return mealsResponse.meals.first;
    }
}

