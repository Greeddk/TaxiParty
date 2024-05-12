

# 프로젝트 소개

# 스크린샷
<img width="19%" src="https://github.com/Greeddk/TaxiParty/assets/116425551/114f2842-d2ed-4d0a-a455-ffd52efaca5c"/>
<img width="19%" src="https://github.com/Greeddk/TaxiParty/assets/116425551/7d210683-364c-4399-b9be-f3f7bd735529"/>
<img width="19%" src="https://github.com/Greeddk/TaxiParty/assets/116425551/b6e31bd4-f33f-4f9e-b8b1-0fadd518f845"/>
<img width="19%" src="https://github.com/Greeddk/TaxiParty/assets/116425551/c7db8d84-7c65-4bf8-86c1-63569cb70c4b"/>
<img width="19%" src="https://github.com/Greeddk/TaxiParty/assets/116425551/20d4d87e-e428-499d-92ff-3e0199f9955e"/>

# 앱 소개 & 기획
## ‎‎택시팟 - 택시 합승 플랫폼

## 개발 기간과 v1.0 버전 기능
### 개발 기간
- 2024.4.10 ~ 2024.5.5 (26일)
<br>

### Configuration
- 최소버전 16.0 / 라이트 모드 / 세로모드 / iOS전용
<br>

### v1.0 기능
1. 택시 합승 파티 만들기
 - 위치 키워드 검색 기능
 - 맵에서 스크롤하여 위치 설정 기능
 - 예상 경로 기능
 - 예상 택시비 / 1인당 예상 택시비 정보
 <br>
 
2. 근처 택시팟 찾기 기능
 - 맵에서 근처 택시팟 표시 기능
 - 줌에 따라 클러스터 처리
 <br>
 
3. 프로필 설정
 - 프로필 닉네임 변경
 - 프로필 사진 변경
 <br>
 
4. 택시팟 포스트 조회 
 - 유저가 올린 포스트들 조회 기능
 <br>
 

### 기술 스택
 - UIKit / SwiftUI / MVVM input - output Pattern
 - RxSwift / RxCoCoa / RxGesture
 - CodeBaseUI / SnapKit / Then
 - Alamofire Router Pattern / Kingfisher
 - Property Wrapper
 - NaverMap / NVActivityIndicatorView / TextFieldEffects / AnimatedTabbar
 - SPM / CocoaPods
<br>
<br>

# ⚒️트러블 슈팅
 처음 RxSwift를 적용한 프로젝트이면서 백앤드 서버를 제대로 써본 프로젝트이다. 아래는 그 문제들 중 어려웠던 문제들과 해결했던 방법을 설명해보려고 한다.

## 1. Custom Bottom Sheet의 크기 조절

 <img width="30%" src="https://github.com/Greeddk/TaxiParty/assets/116425551/c7a76f2b-1d0f-4a3d-b5df-a182c4a8ac05"/>
 <img width="30%" src="https://github.com/Greeddk/TaxiParty/assets/116425551/26fddf5c-4f81-4ac6-98cc-d70392484014"/>

  어느 택시 앱과 같은 바텀시트뷰를 만들기 위해 택스트 필드를 누르면 전체화면으로 뒤로가기 버튼을 누르면 최소 크기로 바뀌게 만들고 싶었다. 기존 라이브러리로는 이와 같은 구현이 힘들어 라이브러리를 쓰지 않고 Custom Bottom Sheet View를 만들었고, 버튼과 택스트필드에 타겟을 추가하여 각 각 클릭되었을 때 크기가 바뀌게 설정하여 해결했다.
 
<details>
<summary>코드 보기</summary>
  

```
final class BottomSheetView: PassThroughView {
    
    enum Mode {
        case tip
        case full
    }
    
    private enum Const {
        static let duration = 0.5
        static let cornerRadius = 20.0
        static let bottomSheetRatio: (Mode) -> Double = { mode in
            switch mode {
            case .tip:
                return 0.7
            case .full:
                return 0
            }
        }
        static let bottomSheetYPosition: (Mode) -> Double = { mode in
            Self.bottomSheetRatio(mode) * UIScreen.main.bounds.height
        }
    }
    
    let bottomSheetView = SearchAddressView()
    let addressLabel = UILabel()
    
    lazy var mode: Mode = .tip {
        didSet {
            switch self.mode {
            case .tip:
                break
            case .full:
                break
            }
            self.updateConstraint(offset: Const.bottomSheetYPosition(self.mode))
            self.bottomSheetView.updateConstraints(isFullmode: self.mode == .full)
        }
    }
    var bottomSheetColor: UIColor? {
        didSet { self.bottomSheetView.backgroundColor = self.bottomSheetColor }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init() has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize.zero
        
        self.backgroundColor = .clear
        
        self.bottomSheetView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.bottomSheetView.layer.cornerRadius = Const.cornerRadius
        self.bottomSheetView.clipsToBounds = true
        
        self.addSubview(self.bottomSheetView)
        
        self.bottomSheetView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(Const.bottomSheetYPosition(.tip))
            $0.bottom.equalTo(keyboardLayoutGuide)
        }

        self.bottomSheetView.startPointTextField.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        self.bottomSheetView.destinationTextField.addTarget(self, action: #selector(textFieldTapped), for: .editingDidBegin)
        self.bottomSheetView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped(sender: UIButton) {
        UIView.animate(
            withDuration: Const.duration,
            delay: 0,
            options: .allowAnimatedContent,
            animations: {
                self.mode = .tip
                self.bottomSheetView.backButton.isHidden = true
                self.defocusTextField()
            },
            completion: nil
        )
    }
    
    @objc private func textFieldTapped(sender: UITextField) {
        UIView.animate(
            withDuration: Const.duration,
            delay: 0,
            options: .allowAnimatedContent,
            animations: {
                self.mode = .full
                self.bottomSheetView.backButton.isHidden = false
            },
            completion: nil
        )
    }
    
    private func updateConstraint(offset: Double) {
        self.bottomSheetView.snp.remakeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalToSuperview().inset(offset)
        }
    }

}

```
</details>
<br>

## 2. Custom Bottom Sheet의 레이아웃이 찌그러지는 이슈

 <img width="30%" src="https://github.com/Greeddk/TaxiParty/assets/116425551/1dc474a4-cec0-4c9b-b526-f0cfc75834df"/>

  바텀 시트 사이즈가 tip 일 때, 다른 뷰 객체에 밀려서 원래 원하던 뷰 레이아웃이 제대로 그려지지 않는 버그가 발생하였다. 이 부분을 해결하기 위해 사이즈가 tip일때는 보이지 않는 뷰객체들의 height을 0으로 바꾸고 사이즈가 full로 바뀔 때 Snapkit의 remake를 통해 의도한 사이즈를 다시 부여하여 제대로 레이아웃이 그려지게 설정하였다.
 
<details>
<summary>코드 보기</summary>
  

```
   // bottomSheetView
    lazy var mode: Mode = .tip {
        didSet {
            switch self.mode {
            case .tip:
                break
            case .full:
                break
            }
            self.updateConstraint(offset: Const.bottomSheetYPosition(self.mode))
            self.bottomSheetView.updateConstraints(isFullmode: self.mode == .full)
        }
    }


// SearchAddressView
func updateConstraints(isFullmode: Bool) {
        if isFullmode {
            dividerView.snp.remakeConstraints { make in
                make.top.equalTo(destinationTextField.snp.bottom).offset(30)
                make.width.equalTo(self)
                make.height.equalTo(8)
            }
            headerLabel.snp.remakeConstraints { make in
                make.top.equalTo(dividerView.snp.bottom).offset(20)
                make.leading.equalTo(15)
            }
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(headerLabel.snp.bottom).offset(10)
                make.horizontalEdges.equalTo(self)
                make.bottom.equalTo(self).offset(-85)
            }
        } else {
            dividerView.snp.remakeConstraints { make in
                make.top.equalTo(destinationTextField.snp.bottom).offset(30)
                make.width.equalTo(self)
                make.height.equalTo(0)
            }
            headerLabel.snp.remakeConstraints { make in
                make.top.equalTo(dividerView.snp.bottom).offset(20)
                make.leading.equalTo(15)
                make.height.equalTo(0)
            }
            tableView.snp.remakeConstraints { make in
                make.top.equalTo(headerLabel.snp.bottom).offset(10)
                make.horizontalEdges.equalTo(self)
                make.height.equalTo(0)
            }
        }
    }

```
</details>
<br>
