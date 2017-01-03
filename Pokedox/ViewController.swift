//
//  ViewController.swift
//  Pokedox
//
//  Created by Nimesh Gurung on 26/12/2016.
//  Copyright © 2016 Nimesh Gurung. All rights reserved.
//

import UIKit
import AVFoundation
import RxCocoa
import RxSwift

class MainViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    let disposeBag = DisposeBag()
    
    var pokemons = [Pokemon]()
    var filteredPokemons = [Pokemon]()
    var musicPlayer: AVAudioPlayer!
    var viewModel: PokemonViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PokemonViewModel(pokeApiService: PokeApiService())
        initAudio()
        addBindstoViewModel()
    }
    
    func addBindstoViewModel() {
        viewModel.shownPokemons
            .asDriver(onErrorJustReturn: [])
            .drive(collectionView.rx.items) {(collectionView, row, element) in
                let indexPath = IndexPath(row: row, section: 0)
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PokeCell", for: indexPath) as? PokeCell {
                    cell.configureCell(element)
                    return cell
                } else {
                    return UICollectionViewCell()
                }
            }
            .addDisposableTo(disposeBag)
        
        viewModel.searchQuery
            .asObservable()
            .asDriver(onErrorJustReturn: "")
            .drive(onNext: {
                guard $0.characters.count == 0 else { return }
                self.view.endEditing(true)
            })
            .addDisposableTo(disposeBag)
        
        collectionView.rx.itemSelected
            .withLatestFrom(viewModel.shownPokemons) { i, pokemons in
                return pokemons[i.row]
            }
            .asDriver(onErrorJustReturn: nil)
            .drive(onNext: { [unowned self] pokemon in
                self.performSegue(withIdentifier: "PokemonDetailVC", sender: pokemon)
            })
            .addDisposableTo(disposeBag)
        
        searchBar
            .rx.text.orEmpty
            .throttle(0.5, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe( onNext: { [unowned self] query in
                self.viewModel.searchQuery.value = query
            })
            .addDisposableTo(disposeBag)
        
        searchBar.rx.searchButtonClicked
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [unowned self] _ in
                self.view.endEditing(true)
            })
            .addDisposableTo(disposeBag)
    }

    func initAudio() {
        let path = Bundle.main.path(forResource: "music", ofType: "mp3")
        
        do {
            musicPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path!))
            musicPlayer.prepareToPlay()
            musicPlayer.numberOfLoops = -1
            musicPlayer.play()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PokemonDetailVC" {
            if let detailVC = segue.destination as? PokemonDetailVC {
                if let poke = sender as? Pokemon {
                    detailVC.pokemon = poke
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 105, height: 105)
    }

    @IBAction func musicBtnPressed(_ sender: UIButton) {
        if musicPlayer.isPlaying {
            musicPlayer.pause()
            sender.alpha = 0.2
        } else {
            musicPlayer.play()
            sender.alpha = 1.0
        }
    }
}

