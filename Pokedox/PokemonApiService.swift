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
    static let URL_BASE:String = "http://pokeapi.co"
    static let PATH_POKEMON = "/api/v1/pokemon/"
    
    func getPokemonDetails(_ pokemonURL: String) -> Observable<JSON> {
        return json(.get, URL(string: pokemonURL)!)
            .map { JSON($0) }
    }
    
    func getPokemonDescription(_ descriptionURL: String) -> Observable<String> {
        return json(.get, URL(string: PokeApiService.URL_BASE + descriptionURL)!)
            .map {
                guard let dict = $0 as? [String: Any],
                    let description = dict["description"] as? String  else { return "" }
                return description
            }
    }
    
    func getPokemons() -> Observable<[Pokemon]> {
        return Observable.create { observer in
            let path = Bundle.main.path(forResource: "pokemon", ofType: "csv")
            do {
                let csv = try CSV(contentsOfURL: path!)
                let rows = csv.rows
                observer.on(.next(rows.map {
                    let pokeId = Int($0["id"]!)!
                    let name = $0["identifier"]!
                    return Pokemon(name: name, pokedexId: pokeId)
                }))
                observer.on(.completed)
            } catch let err as NSError {
                observer.on(.error(err))
            }
            return Disposables.create()
        }
    }
}
