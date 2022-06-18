//
//  SearchPlaceViewController.swift
//  Bappy
//
//  Created by 정동천 on 2022/05/30.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

private let reuseIdentifier = "SearchPlaceCell"
final class SearchPlaceViewController: UIViewController {
    
    // MARK: Properties
    private let viewModel: SearchPlaceViewModel
    private let disposBag = DisposeBag()
    
    private let maxDimmedAlpha: CGFloat = 0.3
    private let defaultHeight: CGFloat = UIScreen.main.bounds.height - 90.0
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 27.0
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var dimmedView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBappyTitle(
            title: "Close",
            font: .roboto(size: 18.0, family: .Medium),
            color: .bappyYellow
        )
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .roboto(size: 22.0, family: .Bold)
        label.textColor = .bappyBrown
        label.text = "Select place"
        return label
    }()
    
    private let searchTextField: UITextField = {
        let textField = UITextField()
        let imageView = UIImageView(image: UIImage(named: "search"))
        let containerView = UIView()
        textField.font = .roboto(size: 16.0)
        textField.textColor = .bappyBrown
        textField.attributedPlaceholder = NSAttributedString(
            string: "Search for a place",
            attributes: [.foregroundColor: UIColor.bappyGray])
        containerView.frame = CGRect(x: 0, y: 0, width: 20.0, height: 14.0)
        containerView.addSubview(imageView)
        textField.leftView = containerView
        textField.leftViewMode = .unlessEditing
        textField.returnKeyType = .search
        return textField
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(SearchPlaceCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 0, right: 20.0)
        tableView.keyboardDismissMode = .interactive
        return tableView
    }()
    
    private let searchBackgroundView = UIView()
    private let noResultView = NoResultView()
    
    // MARK: Lifecycle
    init(viewModel: SearchPlaceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        configure()
        layout()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShowDimmedView()
        animatePresentContainer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [weak self] in
            self?.searchTextField.becomeFirstResponder()
        }
    }
    
    // MARK: Events
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        searchTextField.resignFirstResponder()
    }
    
    // MARK: Animations
    private func animateShowDimmedView() {
        dimmedView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = self.maxDimmedAlpha
        }
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview()
            }
            self.view.layoutIfNeeded()
        }
    }
    
    private func animateDismissView() {
        UIView.animate(withDuration: 0.3) {
            self.containerView.snp.updateConstraints {
                $0.bottom.equalToSuperview().inset(-self.defaultHeight)
            }
            self.view.layoutIfNeeded()
        }
        
        dimmedView.alpha = maxDimmedAlpha
        UIView.animate(withDuration: 0.4) {
            self.dimmedView.alpha = 0
        } completion: { _ in
            self.dismiss(animated: false)
        }
    }
    
    // MARK: Helpers
    private func configure() {
        view.backgroundColor = .clear
        tableView.backgroundView = noResultView
        noResultView.isHidden = true
    }
    
    private func layout() {
        searchBackgroundView.backgroundColor = .bappyLightgray
        searchBackgroundView.layer.cornerRadius = 17.5
        
        view.addSubview(dimmedView)
        dimmedView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(defaultHeight)
            $0.bottom.equalToSuperview().inset(-defaultHeight)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(15.0)
            $0.centerX.equalToSuperview()
        }
        
        containerView.addSubview(closeButton)
        closeButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.leading.equalToSuperview().inset(35.0)
            $0.height.equalTo(44.0)
        }
        
        containerView.addSubview(searchBackgroundView)
        searchBackgroundView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18.0)
            $0.leading.equalToSuperview().inset(30.0)
            $0.trailing.equalToSuperview().inset(31.0)
            $0.height.equalTo(37.0)
        }
        
        searchBackgroundView.addSubview(searchTextField)
        searchTextField.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(16.0)
        }
        
        containerView.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBackgroundView.snp.bottom).offset(15.0)
            $0.leading.equalToSuperview().inset(42.0)
            $0.trailing.equalToSuperview().inset(21.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }
    }
}

// MARK: - Bind
extension SearchPlaceViewController {
    private func bind() {
        searchTextField.rx.text.orEmpty
            .bind(to: viewModel.input.text)
            .disposed(by: disposBag)
        
        // textFieldShouldReturn Delegate와 중복사용시 오류 발생 가능
        searchTextField.rx.controlEvent(.editingDidEndOnExit)
            .bind(to: viewModel.input.searchButtonClicked)
            .disposed(by: disposBag)
        
        tableView.rx.prefetchRows
            .bind(to: viewModel.input.prefetchRows)
            .disposed(by: disposBag)
        
        tableView.rx.itemSelected
            .bind(to: viewModel.input.itemSelected)
            .disposed(by: disposBag)
        
        closeButton.rx.tap
            .bind(to: viewModel.input.closeButtonTapped)
            .disposed(by: disposBag)
        
        viewModel.output.maps
            .drive(tableView.rx.items) { tableView, row, map in
                let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: IndexPath(row: row, section: 0)) as! SearchPlaceCell
                cell.setupCell(with: map)
                return cell
            }
            .disposed(by: disposBag)
        
        viewModel.output.shouldHideNoResultView
            .skip(1)
            .emit(to: noResultView.rx.isHidden)
            .disposed(by: disposBag)
        
        viewModel.output.dismissKeyboard
            .emit(to: view.rx.endEditing)
            .disposed(by: disposBag)
        
        viewModel.output.dismissView
            .emit(onNext: { [weak self] _ in
                self?.animateDismissView()
            })
            .disposed(by: disposBag)
        
        viewModel.output.showLoader
            .emit(to: ProgressHUD.rx.show)
            .disposed(by: disposBag)
        
        viewModel.output.dismissLoader
            .emit(to: ProgressHUD.rx.dismiss)
            .disposed(by: disposBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] height in
                self?.tableView.contentInset.bottom = height
                self?.tableView.verticalScrollIndicatorInsets.bottom = height
            }).disposed(by: disposBag)
        
    }
}