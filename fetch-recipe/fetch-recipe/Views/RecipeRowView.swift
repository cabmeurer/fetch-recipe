//
//  RecipeRowView.swift
//  fetch-recipe
//
//  Created by Caleb Meurer on 12/6/24.
//

import SwiftUI

struct RecipeRowView: View {
    @ObservedObject var viewModel: RecipeRowViewModel

    var body: some View {
        HStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .scaledToFit()
            } else {
                ProgressView()
                    .frame(width: 100, height: 100)
            }
            VStack(alignment: .leading) {
                Text(viewModel.recipe.name)
                    .font(.headline)
                Text(viewModel.recipe.cuisine)
                    .font(.subheadline)
            }
            .scaledToFill()
            .frame(alignment: .center)
        }
        .task {
            await viewModel.loadImage()
        }
    }
    
    init(_ viewModel: RecipeRowViewModel) {
        self.viewModel = viewModel
    }
}

#Preview {
    RecipeListView(RecipeListViewModel(RecipeService(NetworkService(), ImageService())))
}
