import Foundation
import CoreRender

// MARK: - CoreRender.Node

func counterNode(ctx: Context) -> ConcreteNode<UIView> {
  let provider = ControllerProvider(ctx, type: CounterController.self, key: "counter_root")

  let node = Node(type: UIView.self, controller: provider.controller) { spec in
    set(spec, keyPath: \UIView.yoga.width, value: spec.size.width)
  }
  let wrapper = Node(type: UIView.self) { spec in
    set(spec, keyPath: \UIView.backgroundColor, value: .lightGray)
    set(spec, keyPath: \UIView.cornerRadius, value: 5)
    set(spec, keyPath: \UIView.yoga.margin, value: 20)
    set(spec, keyPath: \UIView.yoga.padding, value: 20)
  }
  let label = Node(type: UIButton.self) { spec in
    let controller = provider.controller
    spec.resetAllTargets()
    spec.view?.setTitle("Count: \(controller.state.count)", for: .normal)
    spec.view?.addTarget(
      controller,
      action: #selector(CounterController.incrementCounter),
      for: .touchUpInside)
  }
//  let manualLayoutDot = Node(type: UIView.self) { spec in
//    spec.onLayoutSubviews = { _, view, size in
//      view.yoga.isIncludedInLayout = false
//      view.backgroundColor = .red
//      view.frame = CGRect(x: 10, y: 10, width: 16, height: 16)
//      view.cornerRadius = 8
//    }
//  }

  node.append(children: [wrapper])
  wrapper.append(children: [label])

  return node
}
