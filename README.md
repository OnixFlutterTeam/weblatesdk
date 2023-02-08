# weblate_sdk

Unofficial SDK to use [Weblate](https://weblate.org/) service for a Web-based continuous localization;

Check [Weblate documentation](https://docs.weblate.org/en/latest/) for more details.



## Getting Started

1. Add package and localization support to your `pubspec.yaml`:

```
weblate_sdk: latest
flutter_localizations:
    sdk: flutter
```
2. Add initialization to your `main` function:

```
 await WebLateSdk.initialize(
    accessKey: 'your_weblate_key',
    host: 'weblate_host',
    projectName: 'name of project',
    componentName: 'name of component',
    defaultLanguage: 'en', //optional
  );
```
> Note: host should be without https:// (for example: `weblate.company.link`;

> If `defaultLanguage` is set then if translation not found for current language 
> then translation for `defaultLanguage` will be used instead;

3. Add localization to `MaterialApp`:

```
supportedLocales: WebLateSdk.supportedLocales,
localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        WebLateSdk.delegate,
      ]
```     

4. Use localized strings in your code: 

`context.localizedValueOf('key')`


> Note: Do not forgot to add internet permissions for you platforms



