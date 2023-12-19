protocol MealManager {
    func fetchDesserts() async throws -> [Meal];
    
    func fetchMealById(id: String) async throws -> Meal?
}
