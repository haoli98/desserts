struct Meal: Codable {
    let idMeal: String?
    let strMeal: String?
    let strInstructions: String?
    let strMealThumb: String?
    let dateModified: String?
    let ingredients: [String]
    let measurements: [String]
}

/**
 Transforms the raw JSON data of a meal into a more manageable format by extracting and cleaning ingredients and measurements into two separate lists. This function iterates through the expected keys for ingredients ('strIngredientX') and measurements ('strMeasureX') and returns these values as arrays under the 'ingredients' and 'measurements' keys within the original JSON dictionary.
*/
func preprocessMealJSON(json: [String: Any]) -> [String: Any] {
    var processedJSON = json;
    var ingredients = [String]();
    var measurements = [String]();

    for i in 1...20 {
        let ingredientKey = "strIngredient\(i)";
        if let ingredient = json[ingredientKey] as? String {
            let trimmed = ingredient.trimmingCharacters(in: .whitespacesAndNewlines);
            if !trimmed.isEmpty {
                ingredients.append(trimmed);
            }
        }
    }

    for i in 1...20 {
        let measureKey = "strMeasure\(i)";
        if let measurement = json[measureKey] as? String {
            let trimmed = measurement.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmed.isEmpty {
                measurements.append(trimmed);
            }
        }
    }

    if !ingredients.isEmpty {
        processedJSON["ingredients"] = ingredients;
    } else {
        processedJSON["ingredients"] = [];
    }

    if !measurements.isEmpty {
        processedJSON["measurements"] = measurements;
    } else {
        processedJSON["measurements"] = [];
    }
    return processedJSON;
}

struct MealsResponse : Codable {
    let meals: [Meal];
}
