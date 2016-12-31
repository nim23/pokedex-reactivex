//
//  PokemonDetailVCViewController.swift
//  Pokedox
//
//  Created by Nimesh Gurung on 27/12/2016.
//  Copyright © 2016 Nimesh Gurung. All rights reserved.
//

import UIKit
import RxAlamofire
import RxSwift
import SwiftyJSON

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var mainImg: UIImageView!
    @IBOutlet weak var pokeNameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var pokedexLbl: UILabel!
    @IBOutlet weak var attackLbl: UILabel!
    @IBOutlet weak var evoLbl: UILabel!
    @IBOutlet weak var nextEvoImg: UIImageView!
    @IBOutlet weak var currentEvoImg: UIImageView!
    @IBOutlet weak var defenseLbl: UILabel!
    @IBOutlet weak var weightLbl: UILabel!
    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var heightLbl: UILabel!

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        pokeNameLbl.text = pokemon.name.capitalized
        let img = UIImage(named: "\(pokemon.pokedexId)")
        mainImg.image = img
        currentEvoImg.image = img
        pokedexLbl.text = "\(pokemon.pokedexId)"
        heightLbl.text = ""
        weightLbl.text = ""
        typeLbl.text = ""
        descriptionLbl.text = ""
        defenseLbl.text = ""
        downloadPokemonDetails()
    }
    
    func downloadPokemonDetails() {
        RxAlamofire.requestJSON(.get, URL(string: pokemon.pokemonUrl)!)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (r, pokeJSON) in
                self?.updatePokemonModel(responseJSON: JSON(pokeJSON))
            },
            onError: { error in
                let e = error as NSError
                print(e.debugDescription)
            })
            .addDisposableTo(disposeBag)

    }
    
    func updatePokemonModel(responseJSON: JSON) {
        
        print(responseJSON)
        
        
        if let weight = responseJSON["weight"].string {
            pokemon.weight = weight
        }
        
        if let attack = responseJSON["attack"].int {
            pokemon.attack = "\(attack)"
        }
        
        if let height = responseJSON["height"].string {
            pokemon.height = height
        }
        
        if let defense = responseJSON["defense"].int {
            pokemon.defense = "\(defense)"
        }
        
        if let types = responseJSON["types"].array , types.count > 0 {
            pokemon.type = types.map {
                $0["name"].string?.capitalized ?? ""
            }.joined(separator: "/")
        }
        
        if let descriptionUrl = responseJSON["descriptions"].array?[0]["resource_uri"].string {
            json(.get, URL(string: URL_BASE + descriptionUrl)!)
                .observeOn(MainScheduler.instance)
                .map { JSON($0) }
                .subscribe{ [weak self] in
                    if let description = $0.element?["description"].string {
                        self?.pokemon.description = description
                        self?.descriptionLbl.text = self?.pokemon.description
                    }
                }.addDisposableTo(disposeBag)
        }
        
        if let evolutions = responseJSON["evolutions"].array, evolutions.count > 0, evolutions[0]["to"].string?.range(of: "mega") == nil {
            let nextEvo = evolutions[0]["to"].string!
            self.pokemon.nextEvolutionName = nextEvo
            
            if let uri = evolutions[0]["resource_uri"].string {
                let newStr = uri.replacingOccurrences(of: "/api/v1/pokemon", with: "")
                let nextEvoId = newStr.replacingOccurrences(of: "/", with: "")
                self.pokemon.nextEvolutionId = nextEvoId
            }
            
            if let level = evolutions[0]["level"].int {
                self.pokemon.nextEvoltionLevel = "\(level)"
            }
        }

        updateUI()
    }
    
    func updateUI() {
        attackLbl.text = pokemon.attack
        heightLbl.text = pokemon.height
        defenseLbl.text = pokemon.defense
        weightLbl.text = pokemon.weight
        typeLbl.text = pokemon.type
        
        if (pokemon.nextEvolutionId == "") {
            evoLbl.text = "No Evolutions"
            nextEvoImg.isHidden = true
        } else {
            nextEvoImg.isHidden = false
            nextEvoImg.image = UIImage(named: pokemon.nextEvolutionId)
            let nextEvolutionLevelTxt = pokemon.nextEvoltionLevel != "" ? " - LVL \(pokemon.nextEvoltionLevel)" : ""
            let str = "Next Evolution: \(pokemon.nextEvolutionName + nextEvolutionLevelTxt)"
            evoLbl.text = str
        }
    }
}
