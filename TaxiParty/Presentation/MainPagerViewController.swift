//
//  MainPagerViewController.swift
//  TaxiParty
//
//  Created by Greed on 4/18/24.
//

import UIKit
import SwiftUI
import AnimatedTabBar

final class MainPagerViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openAnimatedTabView()
    }
    
    private func openAnimatedTabView() {
        let hostingController = UIHostingController(rootView: tabSwiftUIView())
        hostingController.sizingOptions = .preferredContentSize
        hostingController.modalPresentationStyle = .fullScreen
        self.present(hostingController, animated: false)
    }
    
}

struct tabSwiftUIView: View {
    
    @State private var selectedIndex = 0
    @State private var prevSelectedIndex = 0
    
    enum TabViews: Int, CaseIterable {
        case searchPostView
        case nearMapView
        case postPartyView
        case chatListView
        case settingView
        
        var asViewController: AnyView {
            switch self {
            case .searchPostView:
                return AnyView(SearchPostRepresentableView())
            case .nearMapView:
                return AnyView(NearMapRepresentableView())
            case .postPartyView:
                return AnyView(SettingRepresentableView())
            case .chatListView:
                return AnyView(ChatListRepresentableView())
            case .settingView:
                return AnyView(SettingRepresentableView())
            }
        }
        
        var tabImage: String {
            switch self {
            case .searchPostView:
                return "house"
            case .nearMapView:
                return "map"
            case .postPartyView:
                return "plus.app"
            case .chatListView:
                return "bubble"
            case .settingView:
                return "person"
            }
        }
    }
    
    @State var time = 0.0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
#if swift(>=5.9)
        if #available(iOS 17.0, *) {
            tabbars()
                .onReceive(timer) { input in
                    time = Date().timeIntervalSince1970
                }
        } else {
            tabbars()
        }
#else
        tabbars()
#endif
    }
    
    func tabbars() -> some View {
        ZStack(alignment: .bottom) {
            TabViews.allCases[selectedIndex].asViewController
            VStack() {
                AnimatedTabBar(selectedIndex: $selectedIndex,
                               views: TabViews.allCases.map { wiggleButtonAt($0.rawValue, name: $0.tabImage)})
                .cornerRadius(16)
                .selectedColor(.pointPurple)
                .unselectedColor(.gray.opacity(0.7))
                .ballColor(.pointPurple)
                .verticalPadding(20)
                .barColor(.pointPurple.opacity(0.1))
                Spacer().frame(height: 10)
            }
            .frame(maxWidth: .infinity)
            .padding(8)
        }
        .ignoresSafeArea(.all)
    }
    
    func wiggleButtonAt(_ index: Int, name: String) -> some View {
        WiggleButton(image: Image(systemName: name), maskImage: Image(systemName: "\(name).fill"), isSelected: index == selectedIndex)
            .scaleEffect(1.3)
    }
}

//import Tabman
//import Pageboy
//
//final class MainPagerViewController: TabmanViewController {
//
//    private var viewControllers: Array<UIViewController> = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .white
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        setTabman()
//    }
//
//    private func setTabman() {
//        hideBackButton()
//        [SearchPostViewController(), NearMapViewController(), SettingViewController()].forEach { tabView in
//            viewControllers.append(tabView)
//        }
//
//        self.dataSource = self
//        self.isScrollEnabled = true
//
//        let bar = TMBar.ButtonBar()
//        bar.layout.transitionStyle = .snap
//        bar.indicator.weight = .custom(value: 1)
//        bar.indicator.tintColor = .pointPurple
//        bar.layout.alignment = .centerDistributed
//        bar.layout.interButtonSpacing = 60
//
//        addBar(bar, dataSource: self, at: .navigationItem(item: self.navigationItem))
//    }
//
//}
//
//extension MainPagerViewController: PageboyViewControllerDataSource, TMBarDataSource {
//    func numberOfViewControllers(in pageboyViewController: Pageboy.PageboyViewController) -> Int {
//        return viewControllers.count
//    }
//
//    func viewController(for pageboyViewController: Pageboy.PageboyViewController, at index: Pageboy.PageboyViewController.PageIndex) -> UIViewController? {
//        return viewControllers[index]
//    }
//
//    func defaultPage(for pageboyViewController: Pageboy.PageboyViewController) -> Pageboy.PageboyViewController.Page? {
//        return nil
//    }
//
//    func barItem(for bar: any Tabman.TMBar, at index: Int) -> any Tabman.TMBarItemable {
//        let item = TMBarItem(title: "")
//        let title = ["검색", "근처팟찾기", "마이페이지"]
//        item.title = title[index]
//        return item
//    }
//}
