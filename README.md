# ngOnboarding

ngOnboarding is a tooltip tutorial / onboarding framework for [Angular.js](http://angularjs.org/) that can help give your user a better onboarding experience. *The API is still in flux and it is not well-tested, so be aware before using it in production.*

![ngOnboarding Screenshot](https://raw.github.com/adamalbrecht/ngOnboarding/master/screenshot.png)

## The Basics
To use the library, add the JS and CSS file, then include the module in your app

```javascript
app = angular.module("myApp", ["ngOnboarding"])
```

Next, you'll need to configure the steps for the onboarding experience. The configuration is an array of objects, each representing a single popover. Here is an example configuration containing 2 popovers:

```javascript
$scope.onboardingSteps = [
  {
    title: 'Welcome!',
    position: 'centered'
    description: "Welcome to my app!',
    width: 300
  },
  {
    title: 'Account Setup'
    position: 'right',
    description: "This is the form for configuring your account.",
    attachTo: '#account_form',
    position: 'bottom'
  }
];
```

The directive itself is called *onboarding-popover*. It requires 2 attributes:
  * `enabled` should be set to a boolean scope variable that controls whether the onboarding UX is displayed.
  * `steps` should point to the steps configuration.

```html
<onboarding-popover enabled='onboardingEnabled' steps='onboardingSteps' />
```

## Step Configuration Options

Coming Soon

## Overriding Directive Defaults

Coming Soon

## Credit

Much of the CSS consists of tweaked versions of several [Bootstrap](https://github.com/twbs/bootstrap) components. And the API was inspired by a jQuery plugin called [Guiders.js](https://github.com/jeff-optimizely/Guiders-JS), though none of its code was used.
