//
//  Pokemon.swift
//  Pokedox
//
//  Created by Nimesh Gurung on 26/12/2016.
//  Copyright © 2016 Nimesh Gurung. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire

class Pokemon {
    var _name: String!
    var _pokedexId: Int!
    var _description: String!
    var _defense: String!
    var _type: String!
    var _height: String!
    var _weight: String!
    var _attack: String!
    var _pokemonURL: String!
    var _nextEvolutionId: String!
    var _nextEvolutionLvl: String!
    var _nextEvolutionTxt: String!
    var _nextEvolutionName: String!
    
    var name: String {
        return _name
    }
    
    var pokedexId: Int {
        return _pokedexId
    }
    
    var description: String {
        get {
            return _description ?? ""
        }
        
        set {
            _description = newValue
        }
    }
    
    var defense: String {
        get {
            return _defense ?? ""
        }
        
        set {
            _defense = newValue
        }
    }
    
    var type: String {
        get {
            return _type ?? ""
        }
        
        set {
            _type = newValue
        }
    }
    
    var height: String {
        get {
            return _height ?? ""
        }
        
        set {
            _height = newValue
        }
    }
    
    var weight: String {
        get {
            return _weight ?? ""
        }
        
        set {
            _weight = newValue
        }
    }
    
    var attack: String {
        get {
            return _attack ?? ""
        }
        
        set {
            _attack = newValue
        }
    }
    
    var nextEvolutionTxt: String {
        get {
            return _nextEvolutionTxt ?? ""
        }
        
        set {
            _nextEvolutionTxt = newValue
        }
    }
    
    var nextEvolutionName: String {
        get {
            return _nextEvolutionName ?? ""
        }
        
        set {
            _nextEvolutionName = newValue
        }
    }
    
    var nextEvolutionId: String {
        get {
            return _nextEvolutionId ?? ""
        }
        
        set {
            _nextEvolutionId = newValue
        }
    }
    
    var nextEvoltionLevel: String {
        get {
            return _nextEvolutionLvl ?? ""
        }
        
        set {
            _nextEvolutionLvl = newValue
        }
    }

    var pokemonUrl: String {
        return _pokemonURL
    }
    
    init(name: String, pokedexId: Int) {
        self._name = name
        self._pokedexId = pokedexId
        self._pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self.pokedexId)"
    }
    
    func getPokemonDetails() -> Observable<Any> {
        return json(.get, URL(string: self.pokemonUrl)!)
    }
}
