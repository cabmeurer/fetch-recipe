//
//  RecipeListView.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import SwiftUI

struct RecipeListView: View {
    
    @ObservedObject private var viewModel: RecipeListViewModel
    @State var endpoint: Endpoint = .valid
    var endpoints: [Endpoint] = [.valid, .empty, .malformed]
    
    var body: some View {
        VStack {
            VStack {
                Text("Select Endpoint response type")
                    .scaledToFill()
                Picker("Select Endpoint", selection: $endpoint) {
                    ForEach(endpoints, id: \.self) {
                        Text($0.name)
                    }
                }
                .onChange(of: endpoint) {
                    Task {
                        await loadRecipes(endpoint)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 300, height: 50)
            }
            
            if viewModel.isLoading {
                ProgressView("Loading...")
            } else if let error = viewModel.errorMessage?.localizedDescription {
                Text("Error: \(error)")
                    .padding(.top)
                    .padding(.bottom)
                Button {
                    Task {
                        await loadRecipes(self.endpoint)
                    }
                } label: {
                    Text("Refresh")
                }
            } else {
                List(viewModel.recipes) { recipe in
                    let viewModel = RecipeRowViewModel(recipe, viewModel.recipeService)
                    RecipeRowView(viewModel)
                }
                .refreshable {
                    await loadRecipes(self.endpoint)
                }
            }
        }
        .task {
            await loadRecipes()
        }
    }
    
    func loadRecipes(_ endpoint: Endpoint = .valid) async {
        await viewModel.loadRecipes(endpoint)
    }
    
    init(_ viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    RecipeListView(RecipeListViewModel(RecipeService()))
}
