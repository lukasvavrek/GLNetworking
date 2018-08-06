//
//  GLValueLabel.swift
//  ReachabilityExample
//
//  Created by Lukas Vavrek on 13.2.18.
//  Copyright © 2018 Lukas Vavrek. All rights reserved.
//

import UIKit

internal class GLValueLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.textColor = UIColor.gray
        self.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        self.textAlignment = .right
    }
}
