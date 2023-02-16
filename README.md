# weblate_sdk

Unofficial SDK to use [Weblate](https://weblate.org/) service for a Web-based continuous
localization;

Check [Weblate documentation](https://docs.weblate.org/en/latest/) for more details.

## Getting Started

**Add package and localization support to your `pubspec.yaml`:**

```
weblate_sdk: latest
flutter_localizations:
    sdk: flutter
```

**Add initialization to your `main` function:**

```
 await WebLateSdk.initialize(
    accessKey: 'your_weblate_key',
    host: 'weblate_host',
    projectName: 'name of project',
    componentName: 'name of component',
    defaultLanguage: 'en',
    disableCache: false, //optional
    cacheLive: const Duration(days: 1), //optional
    fallbackJson: 'assets/default.json', //optional
  );
```

**Parameters description:**

`accessKey` - your access key. You can find
in [WebLate account](https://docs.weblate.org/en/latest/);
`host` - your WebLate host url;

> Note: host should be with https:// (for example: `https://weblate.company.link`

`projectName` - your WebLate project name;

`componentName` - your project component name;

`defaultLanguage` - default language to use if key for current language not found.

> If translation not found for current language
> then translation for `defaultLanguage` will be used instead

`disableCache` - disable or enable caching. By default cache
disabled on debug and enabled on release;

`cacheLive` - cache live time. By default 2 hours;

`fallbackTranslations` - fallback translations file.
This used in case when SDK not initialized properly
or when user runs app without internet connection and cached translations;

**Add localization to `MaterialApp`:**

```
supportedLocales: WebLateSdk.supportedLocales,
localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        WebLateSdk.delegate,
      ]
```     

**Use localized strings in your code:**

`context.localizedValueOf('key');`


> Note: Do not forgot to add internet permissions for you platforms


Have a suggestion or found a bug? Please let us
know [HERE](https://github.com/cozvtieg9/weblatesdk/issues).



