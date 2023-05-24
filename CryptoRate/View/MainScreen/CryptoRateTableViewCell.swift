
import UIKit
import SnapKit
import SDWebImage

class CryptoRateTableViewCell: UITableViewCell {
    static let identifier = "TableViewCell"
    // MARK: - Properties
    
    var iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = UIColor(red: 1,
                                                  green: 1,
                                                  blue: 1,
                                                  alpha: 1)
        return imageView
    }()
    
    var cryptoNameLabel = CustomLabel(fontSize: 16, fontColor: UIColor(red: 1,
                                                                       green: 1,
                                                                       blue: 1,
                                                                       alpha: 1))
    
    var shortNameCryptoLabel = CustomLabel(fontSize: 14, fontColor: UIColor(red: 1,
                                                                            green: 1,
                                                                            blue: 1,
                                                                            alpha: 1))
    
    var priceUsdLabel = CustomLabel(fontSize: 16, fontColor: UIColor(red: 1,
                                                                     green: 1,
                                                                     blue: 1,
                                                                     alpha: 1))
    
    var changePercent24HrLabel = CustomLabel(fontSize: 14, fontColor: UIColor(red: 0.129,
                                                                              green: 0.749,
                                                                              blue: 0.451,
                                                                              alpha: 1))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUICell()
    }
    
    override func prepareForReuse() {
            super.prepareForReuse()
        iconImage.image = nil
        cryptoNameLabel.text = nil
        shortNameCryptoLabel.text = nil
        priceUsdLabel.text = nil
        changePercent24HrLabel.text = nil
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    func setupUICell() {
        contentView.addSubview(iconImage)
        contentView.addSubview(cryptoNameLabel)
        contentView.addSubview(shortNameCryptoLabel)
        contentView.addSubview(priceUsdLabel)
        contentView.addSubview(changePercent24HrLabel)
        contentView.backgroundColor = .clear
        priceUsdLabel.textAlignment = .right
        changePercent24HrLabel.textAlignment = .right
        selectionStyle = .none
        
        iconImage.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(20)
            make.size.equalTo(CGSize(width: 48, height: 48))
        }
        
        cryptoNameLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.left.equalTo(contentView).offset(78)
            make.size.equalTo(CGSize(width: 82, height: 19))
        }
        
        shortNameCryptoLabel.snp.makeConstraints { make in
            make.bottom.equalTo(cryptoNameLabel).offset(25)
            make.left.equalTo(contentView).offset(78)
            make.size.equalTo(CGSize(width: 38, height: 17))
        }
        
        priceUsdLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(10)
            make.right.equalTo(contentView).offset(-20)
            make.size.equalTo(CGSize(width: 92, height: 19))
        }
        
        changePercent24HrLabel.snp.makeConstraints { make in
            make.bottom.equalTo(priceUsdLabel).offset(25)
            make.right.equalTo(contentView).offset(-20)
            make.size.equalTo(CGSize(width: 56, height: 17))
        }
    }
    
    func setModel(with model: CryptoAsset) {
        cryptoNameLabel.text = model.name
        shortNameCryptoLabel.text = model.symbol
        priceUsdLabel.text = model.priceUsd
        changePercent24HrLabel.text = model.changePercent24Hr
    }
    
}
