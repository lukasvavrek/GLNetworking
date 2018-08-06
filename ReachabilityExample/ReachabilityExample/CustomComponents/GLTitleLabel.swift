//
//  GLTitleLabel.swift
//  ReachabilityExample
//
//  Created by Lukas Vavrek on 13.2.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import UIKit

internal class GLTitleLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textColor = UIColor.white
        self.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        self.textAlignment = .left
    }
}
