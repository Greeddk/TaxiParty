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
    
    private var tabView: tabSwiftUIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openAnimatedTabView()
    }
    
    private func openAnimatedTabView() {
        tabView = tabSwiftUIView()
        let hostingController = UIHostingController(rootView: tabView)
        hostingController.sizingOptions = .preferredContentSize
        hostingController.modalPresentationStyle = .fullScreen
        self.present(hostingController, animated: false)
    }
    
    func didCompletePost() {
        tabView.updateIndex(index: 0)
        print("실행됨2222")
    }
    
}

struct tabSwiftUIView: View {
    
    @State private var selectedIndex = 0
    
    enum TabViews: Int, CaseIterable {
        case searchPostView
        case nearMapView
        case addPostView
        case chatListView
        case settingView
        
        var asViewController: AnyView {
            switch self {
            case .searchPostView:
                return AnyView(SearchPostRepresentableView())
            case .nearMapView:
                return AnyView(NearMapRepresentableView())
            case .addPostView:
                return AnyView(AddPostRepresentableView())
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
            case .addPostView:
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
        if #available(iOS 17.0, *) {
            tabbars()
                .onReceive(timer) { input in
                    time = Date().timeIntervalSince1970
                }
        } else {
            tabbars()
        }
    }
    
    func tabbars() -> some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                TabViews.allCases[selectedIndex].asViewController
                VStack() {
                    AnimatedTabBar(selectedIndex: $selectedIndex,
                                   views: TabViews.allCases.map { wiggleButtonAt($0.rawValue, name: $0.tabImage)})
                    .cornerRadius(24)
                    .selectedColor(.pointPurple)
                    .unselectedColor(.gray.opacity(0.3))
                    .ballColor(.pointPurple)
                    .verticalPadding(30)
                    .barColor(.tabbar)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 2)
            }
            .ignoresSafeArea(.all)
        }
    }
    
    func wiggleButtonAt(_ index: Int, name: String) -> some View {
        WiggleButton(image: Image(systemName: name), maskImage: Image(systemName: "\(name).fill"), isSelected: index == selectedIndex)
            .scaleEffect(1.3)
    }
    
    func updateIndex(index: Int) {
        self.selectedIndex = index
        print(selectedIndex)
    }
}
