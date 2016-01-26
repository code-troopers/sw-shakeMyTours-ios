//
//  SelectTownPageViewController.swift
//  shakemytours
//
//  Created by Cedric Gatay on 26/01/16.
//  Copyright © 2016 ShakeMyTours. All rights reserved.
//

import Foundation
import UIKit

class SelectTownPageViewController: UIPageViewController, UIPageViewControllerDataSource{
    override func viewDidLoad() {
        dataSource = self
        view.backgroundColor = AppDelegate.appColor
//        UIPageControl.appearance().backgroundColor = UIColor.clearColor()
        setViewControllers([viewControllerAtIndex(0)], direction: .Forward, animated: true, completion: nil)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        var currentIndex: Int = (viewController as! DataViewController).pageIndex
        
        currentIndex++;
        if currentIndex >= self.presentationCountForPageViewController(pageViewController){
            return nil
        }

        return viewControllerAtIndex(currentIndex)
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        var currentIndex: Int = (viewController as! DataViewController).pageIndex
        
        currentIndex--;
        if currentIndex < 0 {
            return nil
        }
        
        return viewControllerAtIndex(currentIndex)

    }
    
    func viewControllerAtIndex(index: Int) -> UIViewController{
        let dataViewController = self.storyboard?.instantiateViewControllerWithIdentifier("DataViewController") as! DataViewController
        if index == 0 {
            dataViewController.city = JsonCity.Tours
        }else{
            dataViewController.city = JsonCity.Orleans
        }
        dataViewController.pageIndex = index
        return dataViewController;
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 2
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    override func motionEnded(motion: UIEventSubtype,
        withEvent event: UIEvent?) {
            
            if let shakenCity = (viewControllers?[0] as! DataViewController).city
                where motion == .MotionShake{
                AppDelegate.get().city = shakenCity
                let vc = UIStoryboard(name: "Main", bundle: nil)
                    .instantiateViewControllerWithIdentifier("LoadingController")
                    as! LoadingController
                
                self.presentViewController(vc, animated: false, completion: nil)
                
            }
            super.motionEnded(motion, withEvent: event)
    }
}