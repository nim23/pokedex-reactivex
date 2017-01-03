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
import RxCocoa
import SwiftyJSON

class PokemonDetailVC: UIViewController {

    var pokemon: Pokemon!
    private var pokeDetailViewModel: PokeDetailViewModel!
    
    private let disposeBag = DisposeBag()
    
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
        
        pokeDetailViewModel = PokeDetailViewModel(pokemon: pokemon, pokeApiService: PokeApiService())
        addBindsToViewModel(viewModel: pokeDetailViewModel)
    }
    
    private func addBindsToViewModel(viewModel: PokeDetailViewModel) {
        viewModel.pokemonName
            .asDriver(onErrorJustReturn: "")
            .drive(pokeNameLbl.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.pokemonImage
            .asDriver(onErrorJustReturn: nil)
            .drive(mainImg.rx.image)
            .addDisposableTo(disposeBag)
        
        viewModel.pokemonImage
            .asDriver(onErrorJustReturn: nil)
            .drive(currentEvoImg.rx.image)
            .addDisposableTo(disposeBag)
        
        viewModel.pokedexId
            .map { "\($0)" }
            .asDriver(onErrorJustReturn: "")
            .drive(pokedexLbl.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.attack
            .asDriver(onErrorJustReturn: "")
            .drive(attackLbl.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.weight
            .asDriver(onErrorJustReturn: "")
            .drive(weightLbl.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.defense
            .asDriver(onErrorJustReturn: "")
            .drive(defenseLbl.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.height
            .asDriver(onErrorJustReturn: "")
            .drive(heightLbl.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.types
            .asDriver(onErrorJustReturn: "")
            .drive(typeLbl.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.nextEvolutionText
            .asDriver(onErrorJustReturn: "")
            .drive(evoLbl.rx.text)
            .addDisposableTo(disposeBag)
        
        viewModel.nextEvolutionId
            .asDriver(onErrorJustReturn: "")
            .map {
                $0 == "" ? true : false
            }
            .drive(nextEvoImg.rx.isHidden)
            .addDisposableTo(disposeBag)
        
        viewModel.nextEvolutionId
            .map {
                UIImage(named: $0) ?? nil
            }
            .asDriver(onErrorJustReturn: nil)
            .drive(nextEvoImg.rx.image)
            .addDisposableTo(disposeBag)
        
        viewModel.description
            .asDriver(onErrorJustReturn: "")
            .drive(descriptionLbl.rx.text)
            .addDisposableTo(disposeBag)
    }
}
