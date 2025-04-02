import UIKit

final class CollectionVC: BaseVC<VM3> {

	private let label = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 100.0, height: 100.0))
	private let label2 = UILabel(frame: CGRect(x: 155, y: 200, width: 100, height: 100))

	private let collection = UICollectionView(
		frame: CGRect(x: 0, y: 100, width: 300, height: 50),
		collectionViewLayout: {
			let layout = UICollectionViewFlowLayout()
			layout.scrollDirection = .horizontal
			layout.itemSize = CGSize(width: 500, height: 100)
			return layout
		}()
	)

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white

		self.collection.register(BaseCell.self, forCellWithReuseIdentifier: "BaseCell")
		self.collection.delegate = self
		self.collection.dataSource = self
		self.collection.accessibilityIdentifier = "collection"
		self.view.addSubview(self.collection)
		self.collection.frame = CGRect(x: 0, y: 200, width: self.view.bounds.width, height: 150)

		self.customAccessibilityElementsBlock = { [weak self] in
			guard let self else { return nil }
			/// если мы хотим вручную задать порядок элементов доступности, с учетом их видимости
			/// по дефолту читаем сверху-вниз слева-направо
			/// но если по какой -то причине хотим чтобы верхний элемент был в конце, можем перемешать дефолтный порядок
			return [
				self.collection,
			]
		}
	}

	override func accessibilityPerformEscape() -> Bool {
		self.navigationController?.popViewController(animated: true)
		return true
	}

}

extension CollectionVC: UICollectionViewDataSource, UICollectionViewDelegate {

	func numberOfSections(in collectionView: UICollectionView) -> Int {
		10
	}

	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		100
	}

	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BaseCell", for: indexPath)
		if let cell = cell as? BaseCell {
			cell.label.text = "\(indexPath.section + 1)_\(indexPath.item + 1)"
			cell.accessibilityIdentifier = "cell_\(indexPath.section)_\(indexPath.item)"
		}
		return cell
	}

}
