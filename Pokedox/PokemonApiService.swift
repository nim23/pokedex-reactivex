//
//  PokemonApiService.swift
//  Pokedox
//
//  Created by Nimesh Gurung on 31/12/2016.
//  Copyright © 2016 Nimesh Gurung. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import SwiftyJSON

class PokeApiService {
    private let URL_BASE = "http://pokeapi.co"
    private let PATH_POKEMON = "/api/v1/pokemon/"
    
    
    func getPokemonDetails(_ pokemonURL: String) -> Observable<JSON> {
        return json(.get, URL(string: pokemonURL)!)
            .map { JSON($0) }
    }
    
    func getPokemonDescription(_ descriptionURL: String) -> Observable<String> {
        return json(.get, URL(string: URL_BASE + descriptionURL)!)
            .map {
                guard let dict = $0 as? [String: Any],
                    let description = dict["description"] as? String  else { return "" }
                return description
            }
    }
}
