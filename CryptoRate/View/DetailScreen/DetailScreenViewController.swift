

import UIKit
import SnapKit

class DetailScreenViewController: UIViewController {
    
    var viewModelDetail = CryptoViewModel()
    
    // MARK: - UI Properties
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .white
        return label
    }()
    
    lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .clear
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor
        button.setImage(UIImage(named: "􀆉"), for: .normal)
        button.addTarget(self, action: #selector(backButtonTap), for: .touchUpInside)
        return button
    }()
    
    let backgroundview: UIView = {
        let view = UIView()
        view.layer.zPosition = 1
        view.backgroundColor = .clear
        return view
    }()
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.zPosition = 0
        imageView.image = UIImage(named: "bg")
        imageView.alpha = 1
        return imageView
    }()
    
    // MARK: - Private Properties
    
    private var priceLabel = CustomLabel(fontSize: 28, fontColor: .white)
    var percentLabel = CustomLabel(fontSize: 14, fontColor: .green)
    private var marketSupLabel = CustomLabel(fontSize: 12, fontColor: .white)
    private var marketSupTitle = CustomLabel(fontSize: 10, fontColor: .gray)
    private var supplyTitle = CustomLabel(fontSize: 12, fontColor: .gray)
    private var supplyLabel = CustomLabel(fontSize: 10, fontColor: .white)
    private var volume24HrTitle = CustomLabel(fontSize: 10, fontColor: .gray)
    private var volume24HrLabel = CustomLabel(fontSize: 12, fontColor: .white)
    
    lazy var stackViewMarketSup = UIStackView(arrangedSubvies: [marketSupTitle,
                                                                marketSupLabel],
                                              axis: .vertical,
                                              spacing: 15)
    
    lazy var stackViewSupply = UIStackView(arrangedSubvies: [supplyTitle,
                                                             supplyLabel],
                                           axis: .vertical,
                                           spacing: 15)
    
    lazy var stackViewvolume24Hr = UIStackView(arrangedSubvies: [volume24HrTitle,
                                                                 volume24HrLabel],
                                               axis: .vertical,
                                               spacing: 15)
    
    lazy var stackViewAsset = UIStackView(arrangedSubvies: [stackViewMarketSup,
                                                            stackViewSupply,
                                                            stackViewvolume24Hr],
                                          axis: .horizontal, spacing: 20)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

    }
    // MARK: - Setup UI
    
    private func setupUI() {
        setupBlur()
        marketSupTitle.text = NSLocalizedString("Market Cap", comment: "") 
        marketSupTitle.textAlignment = .center
        supplyTitle.text =  NSLocalizedString("Supply", comment: "") 
        supplyTitle.textAlignment = .center
        volume24HrTitle.text = NSLocalizedString("Volume 24Hr", comment: "")
        volume24HrTitle.textAlignment = .center
        self.navigationController?.navigationBar.tintColor = UIColor.clear
        self.navigationController?.isNavigationBarHidden = true
        view.addSubview(backgroundImage)
        stackViewMarketSup.alignment = .center
        stackViewvolume24Hr.alignment = .center
        stackViewSupply.alignment = .center
        stackViewAsset.alignment = .center
        stackViewSupply.isLayoutMarginsRelativeArrangement = true
        stackViewSupply.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        
        backgroundImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.view.addSubview(backgroundview)
        backgroundview.snp.makeConstraints { make in
            make.top.equalTo(view).offset(0)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.backgroundview.addSubview(stackViewAsset)
        self.stackViewAsset.snp.makeConstraints { make in
            make.top.equalTo(backgroundview).offset(193)
            make.left.equalTo(backgroundview).offset(15)
            make.size.equalTo(CGSize(width: 375, height: 69))
        }
        
        self.backgroundview.addSubview(priceLabel)
        self.priceLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundview).offset(130)
            make.left.equalTo(backgroundview).offset(20)
            make.size.equalTo(CGSize(width: 100, height: 39))
        }
        
        self.backgroundview.addSubview(percentLabel)
        self.percentLabel.snp.makeConstraints { make in
            make.centerY.equalTo(priceLabel)
            make.right.equalTo(backgroundview).offset(-99)
            make.size.equalTo(CGSize(width: 80, height: 17))
        }
        
        self.backgroundview.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints { make in
            make.top.equalTo(backgroundview).offset(63.5)
            make.left.equalTo(backgroundview).offset(76)
            make.size.equalTo(CGSize(width: 129, height: 29))
        }
        
        self.backgroundview.addSubview(backButton)
        self.backButton.snp.makeConstraints { make in
            make.top.equalTo(backgroundview).offset(58)
            make.left.equalTo(backgroundview).offset(20)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }
    }
    
    private func setupBlur() {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImage.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImage.addSubview(blurEffectView)
    }
    
    func setModelDetail(with model: CryptoAsset) {
        guard let price = model.priceUsd else {return}
        self.priceLabel.text = "$\(price)"
        guard let percent = model.changePercent24Hr else {return}
        self.percentLabel.text = "\(percent)%"
        self.titleLabel.text = model.name
        guard let market = model.marketCapUsd else {return}
        self.marketSupLabel.text = "$\(viewModelDetail.percentSum(sum: Double(market)?.rounded() ?? 0))b"
        guard let supply = model.supply else {return}
        self.supplyLabel.text = "$\(viewModelDetail.percentSum(sum: ((Double(supply)?.rounded()) ?? 0) * 100 ))m"
        guard let volume = model.volumeUsd24Hr else {return}
        self.volume24HrLabel.text = "$\(viewModelDetail.percentSum(sum: Double(volume)?.rounded() ?? 0))b"
    }
    
    @objc func backButtonTap() {
        self.navigationController?.popViewController(animated: false)
    }
    
}
