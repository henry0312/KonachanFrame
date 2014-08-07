/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014 Tsukasa ŌMOTO <henry0312@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

/* This file is available under an MIT license. */

import Cocoa

class KonachanController: NSObject {

    var konachan: Konachan!
    var timer: NSTimer!
    var timeInterval: Double = 300  // seconds

    override init() {
        super.init()
#if DEBUG
        println("KonachanController")
#endif
        konachan = Konachan()
        updateKonachanViewWithAnotherThread()
    }

    func updateKonachanView() {
#if DEBUG
        println( NSDate.stringNow() )
#endif
        konachan.fetch()
        if let jpegUrl = konachan.jpegUrl {
            let image = NSImage(contentsOfURL: NSURL.URLWithString(jpegUrl))
            let konachanView = (NSApplication.sharedApplication().delegate as AppDelegate).konachanView
            //let konachanView = (NSApp.delegate as AppDelegate).konachanView
            konachanView.update(image)
        }
    }

    func updateKonachanViewWithAnotherThread() {
        let thread = NSThread(target: self, selector: "updateKonachanView", object: nil)
        thread.start()
    }

    func startTimer() {
        timer = NSTimer(timeInterval: timeInterval, target: self, selector: "updateKonachanView", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }

    func stopTimer() {
        timer.invalidate()
    }
}
