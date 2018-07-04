//
//  ViewController.swift
//  test
//
//  Created by singerDream on 2018/6/22.
//  Copyright © 2018年 singerDream. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let container = UIView()
    let shape = ShapeView()
    
    let start = UIView()
    let end = UIView()
    
    var points = [UIView]()
    
    var current:UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scale:CGFloat = 1.4
        let imgView = UIImageView(image: UIImage(named: "lALPAYbMbNYyFQjNAabNAjc_567_422.png_620x10000q90g"))
        imgView.frame = CGRect(x: 0, y: 40, width: 100*scale, height: 100*scale)
        imgView.contentMode = .scaleAspectFill
        view.addSubview(imgView)
        
        container.backgroundColor = UIColor.lightGray
        view.addSubview(container)
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: container, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: container, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: container, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 40).isActive = true
        NSLayoutConstraint(item: container, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 500).isActive = true
        container.alpha = 0.5
        
        shape.config(width: 1, color: UIColor.red)
        view.addSubview(shape)
        shape.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: shape, attribute: .left, relatedBy: .equal, toItem: container, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: shape, attribute: .right, relatedBy: .equal, toItem: container, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: shape, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: shape, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        
        start.backgroundColor = UIColor.red
        start.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        start.layer.cornerRadius = 5
        
        end.backgroundColor = UIColor.black
        end.frame = CGRect(x: 100, y: 100, width: 10, height: 10)
        end.layer.cornerRadius = 5
        
        container.addSubview(start)
        container.addSubview(end)
    }
    
    @IBAction func addPoint(_ sender: UIButton) {
        let num = points.count
        let btn = UIButton(type: .custom)
        btn.setTitle("\(num)", for: .normal)
        btn.setTitleColor(UIColor.purple, for: .normal)
        btn.setTitleColor(UIColor.red, for: .highlighted)
        btn.setTitleColor(UIColor.red, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.backgroundColor = UIColor.gray
        btn.layer.cornerRadius = 10
        btn.frame = CGRect(x: 50, y: 50, width: 20, height: 20)

        container.addSubview(btn)
        points.append(btn)
    }
    
    @IBAction func clear(_ sender: UIButton) {
        let _ = points.map { (obj) -> Bool in
            obj.removeFromSuperview()
            return true
        }
        points.removeAll()
        shape.path = nil
        current = nil
    }
    
    
    @IBAction func drawLine(_ sender: UIButton) {
        let path = UIBezierPath()
        path.move(to: start.center)
        path.addCurve(to: end.center, controlPoint1: points[0].center, controlPoint2: points[1].center)
        shape.path = path
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: container){
            let obj = container.hitTest(point, with: event)
            if obj == container{
                current = nil
            }else{
                current = obj
                if let btn = current as? UIButton{
                    btn.isHighlighted = true
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let point = touches.first?.location(in: container){
            current?.center = point
            let path = UIBezierPath()
            path.move(to: start.center)
            path.addCurve(to: end.center, controlPoint1: points[0].center, controlPoint2: points[1].center)
//            path.addCurve(to: points[2].center, controlPoint1: points[0].center, controlPoint2: points[1].center)
//            path.addCurve(to: end.center, controlPoint1: points[3].center, controlPoint2: points[4].center)
            shape.path = path
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let btn = current as? UIButton{
            btn.isHighlighted = false
        }
        current = nil
    }

    @IBAction func showCenters(_ sender: UIButton) {
        print("start:\(start.center)")
        print("end:\(end.center)")
        for obj in points.enumerated(){
            print("\(obj.offset):\(obj.element.center)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class ShapeView: UIView{
    
    var shape:CAShapeLayer{
        return self.layer as! CAShapeLayer
    }
    
    override class var layerClass:AnyClass{
        return CAShapeLayer.self
    }
    
    func config(width:CGFloat,color:UIColor?){
        shape.lineWidth = width
        shape.strokeColor = color?.cgColor
        shape.fillColor = nil
        shape.lineJoin = kCALineJoinRound
        shape.lineCap = kCALineCapRound
    }
    
    var path:UIBezierPath?{
        set{
            shape.path = newValue?.cgPath
        }
        get{
            let obj = shape.path
            return obj == nil ? nil : UIBezierPath(cgPath: obj!)
        }
    }
}
