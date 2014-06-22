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

class PreferencesController: NSWindowController {

    @IBOutlet var textField : NSTextField
    @IBOutlet var slider : NSSlider
    var timeInterval: Double!

    init(window: NSWindow?) {
        super.init(window: window)
        // Initialization code here.
    }

    /**
     * work around
     * http://stackoverflow.com/questions/24220638/subclassing-nswindowcontroller-in-swift-and-initwindownibname
     */
    init() { super.init() }
    init(coder: NSCoder!) { super.init(coder: coder) }

    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        timeInterval = (NSApp.delegate as AppDelegate).konachanController.timeInterval
        textField.doubleValue = timeInterval / 60
        slider.doubleValue = timeInterval / 60
    }

    func windowWillClose(notification: NSNotification!) {
        let konachanController = (NSApp.delegate as AppDelegate).konachanController
        if self.timeInterval != konachanController.timeInterval {
            // Update timeInterval
            konachanController.stopTimer()
            konachanController.timeInterval = self.timeInterval
            konachanController.startTimer()
        }
    }

    @IBAction func takeTimeInterval(sender : AnyObject) {
        let newValue = (sender.doubleValue < 3) ? 3 : sender.doubleValue
        timeInterval = newValue * 60
        textField.doubleValue = newValue
        slider.doubleValue = newValue
    }

}
