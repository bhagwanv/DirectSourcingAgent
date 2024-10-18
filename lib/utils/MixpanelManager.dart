import 'package:mixpanel_flutter/mixpanel_flutter.dart';

class MixpanelManager {
  static final MixpanelManager _instance = MixpanelManager._internal();
  Mixpanel? mixpanel;

  factory MixpanelManager() {
    return _instance;
  }

  MixpanelManager._internal();

  Future<void> init() async {
    if(mixpanel == null){
      mixpanel = await Mixpanel.init("b56d1c2f900cfc2c33f55a11fc86e345",
          optOutTrackingDefault: false, trackAutomaticEvents: true);
      mixpanel!.setLoggingEnabled(true);
    }
  }

  // Method to identify the user by a unique ID
  void identifyUser(String userId) {
    if (mixpanel != null) {
      mixpanel!.identify(userId);
    }
  }

  // Method to set user profile properties
  void setUserProfile(Map<String, dynamic> profileProperties) {
    if (mixpanel != null) {
      identifyUser(profileProperties["user_id"]);
      mixpanel!.getPeople().set("User Id", profileProperties["user_id"]);
      mixpanel!.getPeople().set("\$name", profileProperties["name"]);
      mixpanel!.getPeople().set("Product Code", profileProperties["Product Code"]);
      mixpanel!.getPeople().set("Company Code", profileProperties["Company Code"]);
      mixpanel!.getPeople().set("Role", profileProperties["role"]);
      mixpanel!.getPeople().set("Type", profileProperties["type"]);
      setSuperProperties(profileProperties);
    }
  }

  // Method to register super properties
  void setSuperProperties(Map<String, dynamic> properties) {
    if (mixpanel != null) {
      mixpanel!.registerSuperProperties(properties);
    }
  }

  // Centralized method to track events, ensuring super properties are set first
  void trackEvent(String eventName, [Map<String, dynamic>? properties]) {
    if (mixpanel != null) {
      mixpanel!.track(eventName, properties: properties);
    }
  }

  Mixpanel getMixpanel() {
    return mixpanel!;
  }
}