

import UIKit

class CustomLabel: UILabel {

    var fontSize: CGFloat?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(fontSize: CGFloat, fontColor: UIColor) {
        self.init()
        self.textColor = fontColor
        self.fontSize = fontSize
        setupLabel()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLabel() {
        self.textAlignment = .left
        self.font = UIFont(name: "SFPro-Regular", size: fontSize ?? 24)
        self.adjustsFontSizeToFitWidth = true
        self.numberOfLines = 0
        self.sizeToFit()
        self.lineBreakMode = .byWordWrapping
        self.backgroundColor = .clear
    }
    
    
    
}
