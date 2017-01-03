//
//  PokemonViewModel.swift
//  Pokedox
//
//  Created by Nimesh Gurung on 03/01/2017.
//  Copyright © 2017 Nimesh Gurung. All rights reserved.
//

import Foundation
import RxSwift

class PokemonViewModel {
    private var pokemons:Observable<[Pokemon]> = .just([Pokemon]())
    var shownPokemons: Observable<[Pokemon]> = .just([Pokemon]())
    var searchQuery = Variable("")
    
    init (pokeApiService: PokeApiService) {
        pokemons = pokeApiService.getPokemons()
        
        shownPokemons = Observable.combineLatest(pokemons, searchQuery.asObservable()) {
            pokemons, query in
            let filteredPokemons =  pokemons.filter{ $0.name.range(of: query.lowercased()) != nil}
            
            if query.characters.count > 0 && filteredPokemons.count == 0 {
                return [Pokemon]()
            } else if query.characters.count == 0 {
                return pokemons
            }
            
            return filteredPokemons
        }
    }
}
