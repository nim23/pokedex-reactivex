//
//  ViewModel.swift
//  Pokedox
//
//  Created by Nimesh Gurung on 31/12/2016.
//  Copyright © 2016 Nimesh Gurung. All rights reserved.
//

import Foundation
import RxSwift
import SwiftyJSON

class PokeDetailViewModel {
    var pokedexId: Observable<Int>
    var pokemonName: Observable<String>
    var pokemonImage: Observable<UIImage>

    var attack: Observable<String>
    var height: Observable<String>
    var weight: Observable<String>
    var defense: Observable<String>
    var types: Observable<String>
    var nextEvolutionName: Observable<String>
    var nextEvolutionText: Observable<String>
    var nextEvolutionId: Observable<String>
    var nextEvolutionLevel: Observable<String>
    var description: Observable<String>
    
    init(pokemon: Pokemon, pokeApiService: PokeApiService) {
        pokedexId = .just(pokemon.pokedexId)
        pokemonName = .just(pokemon.name.capitalized)
        pokemonImage = {
            guard let image = UIImage(named: "\(pokemon.pokedexId)") else {
                return .just(UIImage(named: "1")!)
            }
            return .just(image)
        }()
        
        let pokemonDetails = pokeApiService.getPokemonDetails(pokemon.pokemonUrl)
                                .shareReplay(1)
        
        //Map converts the Observable<JSON> to Observable<String>
        attack = pokemonDetails
            .map {
                let attack = $0["attack"].int
                return attack != nil ? "\(attack!)" : ""
            }
        
        height = pokemonDetails
            .map { $0["height"].string ?? "" }
        
        weight = pokemonDetails
            .map { $0["weight"].string ?? "" }
        
        defense = pokemonDetails
            .map {
                let defense = $0["defense"].int
                return defense != nil ? "\(defense!)" : ""
            }
        
        let getTypes = { (json:JSON) -> String in
            guard let types = json["types"].array,
                types.count > 0 else { return "" }
            
            return types.map {
                $0["name"].string?.capitalized ?? ""
            }.joined(separator: "/")
        }
        
        types = pokemonDetails
            .map(getTypes)
        
        let getEvolutions = {(json:JSON) -> [JSON]? in
            guard let evolutions = json["evolutions"].array,
                evolutions.count > 0,
                evolutions[0]["to"].string?.range(of: "mega") == nil else { return nil }
            return evolutions
        }
        
        nextEvolutionName = pokemonDetails
            .map {
                guard let evolutions = getEvolutions($0) else { return "" }
                return evolutions[0]["to"].string ?? ""
            }
        
        nextEvolutionId = pokemonDetails
            .map {
                guard let evolutions = getEvolutions($0),
                    let uri = evolutions[0]["resource_uri"].string else { return "" }
                
                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon", with: "")
                let id = newStr.replacingOccurrences(of: "/", with: "")

                return id
            }
        
        nextEvolutionLevel = pokemonDetails
            .map {
                guard let evolutions = getEvolutions($0),
                    let level = evolutions[0]["level"].int else { return "" }
                
                return "\(level)"
            }
        
        nextEvolutionText = Observable.combineLatest(nextEvolutionId, nextEvolutionLevel, nextEvolutionName, resultSelector: { (id: String, level: String, name: String) -> String in
            guard id != "" else { return "No Evolutions" }
            let nextEvolutionLevelTxt = level != "" ? " - LVL \(level)" : ""
            return "Next Evolution: \(name + nextEvolutionLevelTxt)"
        })
        
        description = pokemonDetails
            .flatMapLatest {(json: JSON) -> Observable<String> in
                guard let descriptionUrl = json["descriptions"].array?[0]["resource_uri"].string else { return .just("") }
                return pokeApiService.getPokemonDescription(descriptionUrl)
        }
    }
}
