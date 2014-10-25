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

class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet var window: NSWindow!
    @IBOutlet var konachanView : KonachanView!
    var konachanController: KonachanController!
    var preferencesController: PreferencesController!

    func applicationDidFinishLaunching(aNotification: NSNotification?) {
        // Insert code here to initialize your application
        konachanController = KonachanController()
        konachanController.startTimer()
    }

    func applicationWillTerminate(aNotification: NSNotification?) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(theApplication: NSApplication!) -> Bool {
        return true
    }

    /**
     * Show Preferences Window
     */
    @IBAction func showPreferences(sender : AnyObject) {
        if preferencesController == nil {
            preferencesController = PreferencesController(windowNibName: "Preferences")
        }
        preferencesController.showWindow(self)
    }

    /**
     * Copy a url of source file
     */
    @IBAction func copy(sender : AnyObject) {
        if let jpegUrl = konachanController.konachan.jpegUrl {
            let pasteboard = NSPasteboard.generalPasteboard()
            pasteboard.clearContents()
            pasteboard.writeObjects([jpegUrl] as [AnyObject])
        }
    }

    /**
     * Save a image
     */
    @IBAction func save(sender : AnyObject) {
        let panel = NSSavePanel()
        // default file name is original file name
        panel.nameFieldStringValue = NSURL(string: konachanController.konachan.jpegUrl!)!.lastPathComponent
        panel.beginWithCompletionHandler({result in
            if NSFileHandlingPanelOKButton == result {
                var fileName = panel.URL!
                if fileName.pathExtension != "jpg" {
                   fileName = fileName.URLByDeletingPathExtension!.URLByAppendingPathExtension("jpg")
                }

                var imageData = self.konachanView.imageView.image!.TIFFRepresentation!
                if let imageRep = NSBitmapImageRep.imageRepsWithData(imageData)[0] as? NSBitmapImageRep {
                    let imageProps = NSDictionary(objects: [1.0] as [AnyObject], forKeys: [NSImageCompressionFactor] as [AnyObject])
                    imageData = imageRep.representationUsingType(NSBitmapImageFileType.NSJPEGFileType, properties: imageProps)!
                    if !imageData.writeToFile(fileName.path!, atomically: true) {
                        // TODO: error handling
                        println("save error")
                    }
                }
            }
        })
    }

    /**
     * Show a next image
     */
    @IBAction func skip(sender : AnyObject) {
        konachanController.stopTimer()
        konachanController.updateKonachanViewWithAnotherThread()
        konachanController.startTimer()
    }
}
