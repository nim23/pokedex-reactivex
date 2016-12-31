//
//  PokeCellCollectionViewCell.swift
//  Pokedox
//
//  Created by Nimesh Gurung on 26/12/2016.
//  Copyright © 2016 Nimesh Gurung. All rights reserved.
//

import UIKit

class PokeCell: UICollectionViewCell {
    @IBOutlet weak var thumbImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
    var pokemon: Pokemon!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.cornerRadius = 5.0
    }
    
    func configureCell(_ pokemon: Pokemon) {
        self.pokemon = pokemon
        nameLbl.text = self.pokemon.name.capitalized
        let pokedexId = self.pokemon.pokedexId
        thumbImage.image = UIImage(named: "\(pokedexId)")
    }
}
