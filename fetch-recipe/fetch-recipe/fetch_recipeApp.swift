//
//  fetch_recipeApp.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import SwiftUI

@main
struct fetchTakeHomeApp: App {
    var body: some Scene {
        WindowGroup {
            let recipeService = RecipeService()
            let viewModel = RecipeListViewModel(recipeService)
            RecipeListView(viewModel)
        }
    }
}
