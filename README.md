# ClassifiedAds iOS App
By Jeffrey Tabios

https://user-images.githubusercontent.com/52874288/146828442-9a60d7ef-2030-4583-b5f0-a99f2e72dbc2.mov

Details:
- Implemented programatically
- Created in VIPER
- Created image caching framework to download and cache images. Found in "CachedImage" folder (included in project, please see targets)
- Created network and service layer
- Has unit tests and integration tests in "ClassifiedAdsTests" folder
- Has UI test in "ClassifiedAdsUITests" folder
- Created mocking system (found under "Network" folder) that overrides "URLProtocol" and uses mock JSON files and a test image file during tests. This way, the APIService protocol gets included in the test coverage 
- Applied "Solid" principles and created with scalability in mind
