import Cocoa
import FlutterMacOS

public class UniLinksMacosPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    static let kMessagesChannel: String = "uni_links/messages"
    static let kEventsChannel: String = "uni_links/events"
    
    private static var instance: UniLinksMacosPlugin? = nil;
    
    open class func shared() -> UniLinksMacosPlugin {
        return instance!;
    }
    
    private var _eventSink: FlutterEventSink?
    
    private var _initialLink: String? = ""
    private var _latestLink: String? = ""
    
    var initialLink: String? {
        set { _latestLink = newValue; }
        get { return _latestLink; }
    }
    
    var latestLink: String? {
        set {
            _latestLink = newValue;
            if (_eventSink != nil) {
                _eventSink!(_latestLink);
            }
        }
        get { return _latestLink; }
    }
    
    override init(){
        super.init();
        NSAppleEventManager.shared().setEventHandler(self, andSelector: #selector(handleURLEvent(_:with:)), forEventClass: AEEventClass(kInternetEventClass), andEventID: AEEventID(kAEGetURL))
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        instance = UniLinksMacosPlugin()
        
        let channel = FlutterMethodChannel(name: kMessagesChannel, binaryMessenger: registrar.messenger)
        registrar.addMethodCallDelegate(instance!, channel: channel)
        
        let chargingChannel = FlutterEventChannel(name: kEventsChannel, binaryMessenger: registrar.messenger)
        chargingChannel.setStreamHandler(instance!)
    }
    
    @objc
    private func handleURLEvent(_ event: NSAppleEventDescriptor, with replyEvent: NSAppleEventDescriptor) {
        guard let urlString = event.paramDescriptor(forKeyword: AEKeyword(keyDirectObject))?.stringValue else { return }
        self.latestLink = urlString;
        if(self.initialLink == nil){
            self.initialLink = self.latestLink;
        }
        guard let sink = self._eventSink else{
            return;
        }
        sink(self.latestLink);
    }
    
    public func application(_ application: NSApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([NSUserActivityRestoring]) -> Void) -> Bool {
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            self.latestLink = userActivity.webpageURL?.absoluteString
            if (_eventSink != nil) {
                self.initialLink = self.latestLink;
            }
        }
        return false
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getInitialLink":
            result(self.initialLink);
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self._eventSink = events;
        return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self._eventSink = nil
        return nil
    }
}
