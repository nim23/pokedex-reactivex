//
//  ViewModel.swift
//  Pokedox
//
//  Created by Nimesh Gurung on 31/12/2016.
//  Copyright © 2016 Nimesh Gurung. All rights reserved.
//

import Foundation
import RxSwift

class PokeDetailViewModel {
    let pokedexId: Observable<Int>
    let pokemonName: Observable<String>
    var pokemonImage: Observable<UIImage>
//    let attack: Observable<String>
//    let evolution: Observable<String>
//    let defense: Observable<String>
//    let pokeName: Observable<String>
//    let type: Observable<String>
    
    init(_ pokemon: Pokemon) {
        pokedexId = .just(pokemon.pokedexId)
        pokemonName = .just(pokemon.name.capitalized)
        pokemonImage = {
            guard let image = UIImage(named: "\(pokemon.pokedexId)") else {
                return .just(UIImage(named: "1")!)
            }
            return .just(image)
        }()
    }
}
