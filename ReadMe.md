## App Version Checker
  App version checker has been written as a reusable and easy to integrate component, which checks for the app version and shows alert in the app if newer version is available in the store.
We plan on making a reusable component in backend as well, so the same component can be added in all app easily and will be same across all app to bring some standarization.
</br>
App version checking should be done real time, which we will include via web socket, but this module is used when app is first launched and when app moves from background to foreground.

It is an api call which takes in 2 params: </br>

    {
      "device_type" : "1",
      "app_version" : "1.0"
    }

  Developer would not have to give `app_version`, as it is taken automatically from info.plist file, and `device_type` will always be `1` form ios and `2` for android.
</br>

Response from server: </br>

    {
        "code" : 0 || 1 || 4 || 5 ,
        "message" : "",
        "app_link" : "app store link here"
    }

We would not have to worrry about anything above.. </br>
0 -> api call failure </br>
1 -> api call success.. current version is valid Version </br>
4 -> mandatory update.. new version available in app store. </br>
5 -> optional update.. new versiona avialble, but update is not mandatory. </br>

### Enough explaination.. How to use this?
In your app delegate.. application did launched.. add </br>

        func application(_ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

          AppVersionChecker.shared.initiate(url: "your_backend_app_version_checker_url")
          return true

        }

That is all, needed to be done.### 1. App Version Checker
  App version checker has been written as a reusable and easy to integrate component, which checks for the app version and shows alert in the app if newer version is available in the store.
We plan on making a reusable component in backend as well, so the same component can be added in all app easily and will be same across all app to bring some standarization.
</br>
App version checking should be done real time, which we will include via web socket, but this module is used when app is first launched and when app moves from background to foreground.

It is an api call which takes in 2 params: </br>

    {
      "device_type" : "1",
      "app_version" : "1.0"
    }

  Developer would not have to give `app_version`, as it is taken automatically from info.plist file, and `device_type` will always be `1` form ios and `2` for android.
</br>

Response from server: </br>

    {
        "code" : 0 || 1 || 4 || 5 ,
        "message" : "",
        "app_link" : "app store link here"
    }

We would not have to worrry about anything above.. </br>
0 -> api call failure </br>
1 -> api call success.. current version is valid Version </br>
4 -> mandatory update.. new version available in app store. </br>
5 -> optional update.. new versiona avialble, but update is not mandatory. </br>

### Enough explaination.. How to use this?
In your app delegate.. application did launched.. add </br>

        func application(_ application: UIApplication,
           didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

          AppVersionChecker.shared.initiate(url: "your_backend_app_version_checker_url")
          return true

        }

That is all, needed to be done.
