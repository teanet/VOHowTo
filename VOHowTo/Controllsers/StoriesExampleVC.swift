import UIKit

final class Cell: UITableViewCell {

	struct ViewModel {
		var label = "label"
	}

	var viewModel = ViewModel()

	override var accessibilityLabel: String? {
		get { viewModel.label }
		set {}
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.isAccessibilityElement = !ProcessInfo.isUITests
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

final class StoriesExampleVC: BaseVC<StoriesExampleVM> {

	private let label = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
	private let label2 = UILabel(frame: CGRect(x: 155, y: 200, width: 100, height: 100))

	private let collection = UICollectionView(
		frame: CGRect(x: 0, y: 100, width: 300, height: 50),
		collectionViewLayout: {
			let layout = UICollectionViewFlowLayout()
			layout.scrollDirection = .horizontal
			layout.itemSize = CGSize(width: 50, height: 50)
			return layout
		}()
	)

	private lazy var carousel = AccessibilityCarousel(
		collectionViewProvider: self.collection,
		title: "Какой то бесконечный список",
		countTemplate: "%@ из %@"
	)

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white

		self.collection.register(BaseCell.self, forCellWithReuseIdentifier: "BaseCell")
		self.collection.delegate = self
		self.collection.dataSource = self
		self.collection.accessibilityIdentifier = "collection"
		self.view.addSubview(self.collection)

		// пример изначально недоступного label, который можно сделать кнопкой
		self.label.accessibilityIdentifier = "label_button"
		self.label.accessibilityLabel = "Some text"
		self.label.isUserInteractionEnabled = true
		self.label.backgroundColor = .red
		self.label.center = self.view.center
		self.view.addSubview(self.label)
		let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.tap))
		self.label.addGestureRecognizer(tapGR)

		if !ProcessInfo.isUITests {
			self.label.isAccessibilityElement = true
			self.label.accessibilityTraits = .button
		}

		self.label2.accessibilityIdentifier = "label2"
		self.label2.text = "Some other label"
		self.view.addSubview(self.label2)

		self.customAccessibilityElementsBlock = { [weak self] in
			guard let self else { return nil }
			/// если мы хотим вручную задать порядок элементов доступности, с учетом их видимости
			/// по дефолту читаем сверху-вниз слева-направо
			/// но если по какой -то причине хотим чтобы верхний элемент был в конце, можем перемешать дефолтный порядок
			return [
				self.carousel,
				self.label2,
				self.label,
			]
		}
	}

	override func accessibilityPerformEscape() -> Bool {
		self.navigationController?.popViewController(animated: true)
		return true
	}

	@objc private func tap() {
		print("On label tapped")
		self.label2.isHidden.toggle()
		UIAccessibility.post(notification: .layoutChanged, argument: nil)
	}

}

class BaseCell: UICollectionViewCell {
	let label = UILabel()

	override var accessibilityLabel: String? {
		get { "ячейка" }
		set {}
	}

	override var accessibilityValue: String? {
		get { self.label.text }
		set {}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		self.isAccessibilityElement = true
		self.accessibilityTraits = .button
		self.contentView.backgroundColor = .red
		self.label.frame = self.contentView.bounds
		self.label.textAlignment = .center
		self.contentView.addSubview(self.label)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

final class StoriesExampleVM: BaseVM {}

extension StoriesExampleVC: UICollectionViewDataSource, UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		5000
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseCell", for: indexPath)
		if let cell = cell as? BaseCell {
			cell.label.text = "\(indexPath.item + 1)"
			cell.accessibilityIdentifier = "cell_\(indexPath.item)"
		}
		return cell
	}

}
