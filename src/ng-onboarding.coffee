#
# ngOnboarding
# by Adam Albrecht
# http://adamalbrecht.com
#
# Source Code: https://github.com/adamalbrecht/ngOnboarding
#
# Compatible with Angular 1.2.x
#

app = angular.module("ngOnboarding", [])

app.provider "ngOnboardingDefaults", ->
  options: {
    overlay: true,
    overlayOpacity: 0.6,
    overlayClass: 'onboarding-overlay',
    popoverClass: 'onboarding-popover',
    titleClass: 'onboarding-popover-title',
    contentClass: 'onboarding-popover-content',
    arrowClass: 'onboarding-arrow',
    buttonContainerClass: 'onboarding-button-container',
    buttonClass: "onboarding-button",
    showButtons: true,
    nextButtonText: 'Next &rarr;',
    previousButtonText: '&larr; Previous',
    showDoneButton: true,
    doneButtonText: 'Done',
    closeButtonClass: 'onboarding-close-button',
    closeButtonText: 'X',
    stepClass: 'onboarding-step-info',
    showStepInfo: true
  }
  $get: ->
    @options

  set: (keyOrHash, value) ->
    if typeof(keyOrHash) == 'object'
      for k, v of keyOrHash
        @options[k] = v
    else
      @options[keyOrHash] = value

app.directive 'onboardingPopover', ['ngOnboardingDefaults', '$sce', '$timeout', (ngOnboardingDefaults, $sce, $timeout) ->
  restrict: 'E'
  scope:
    enabled: '='
    steps: '='
    onFinishCallback: '='
    index: '=stepIndex'
  replace: true
  link: (scope, element, attrs) ->
    # Important Variables
    curStep = null
    attributesToClear = ['title', 'top', 'right', 'bottom', 'left', 'width', 'height', 'position']
    scope.stepCount = scope.steps.length

    # Button Actions
    scope.next = -> scope.index = scope.index + 1
    scope.previous = -> scope.index = scope.index - 1
    scope.close = ->
      scope.enabled = false
      setupOverlay(false)
      if scope.onFinishCallback
        scope.onFinishCallback()

    # Watch for changes in the current step index
    scope.$watch 'index', (newVal, oldVal) ->
      if newVal == null
        scope.enabled = false
        setupOverlay(false)
        return

      console.log "WATCH"
      curStep = scope.steps[scope.index]
      scope.lastStep = (scope.index + 1 == scope.steps.length)
      scope.showNextButton = (scope.index + 1 < scope.steps.length)
      scope.showPreviousButton = (scope.index > 0)
      for attr in attributesToClear
        scope[attr] = null
      for k, v of ngOnboardingDefaults
        if curStep[k] == undefined
          scope[k] = v
      for k, v of curStep
        scope[k] = v

      # Allow some variables to include html
      scope.description = $sce.trustAsHtml(scope.description)
      scope.nextButtonText = $sce.trustAsHtml(scope.nextButtonText)
      scope.previousButtonText = $sce.trustAsHtml(scope.previousButtonText)
      scope.doneButtonText = $sce.trustAsHtml(scope.doneButtonText)
      scope.closeButtonText = $sce.trustAsHtml(scope.closeButtonText)
      setupOverlay()
      setupPositioning()

    setupOverlay = (showOverlay=true) ->
      $('.onboarding-focus').removeClass('onboarding-focus')
      if showOverlay
        if curStep['attachTo'] && scope.overlay
          $(curStep['attachTo']).addClass('onboarding-focus')

    setupPositioning = ->
      attachTo = curStep['attachTo']
      scope.position = curStep['position']
      xMargin = 15
      yMargin = 15
      if attachTo
        # SET X POSITION
        unless scope.left || scope.right
          left = null
          right = null
          if scope.position == 'right'
            left = $(attachTo).offset().left + $(attachTo).outerWidth() + xMargin
          else if scope.position == 'left'
            right = $(window).width() - $(attachTo).offset().left + xMargin
          else if scope.position == 'top' || scope.position == 'bottom'
            left = $(attachTo).offset().left
          if curStep['xOffset']
            left = left + curStep['xOffset'] if left != null
            right = right - curStep['xOffset'] if right != null
          scope.left = left
          scope.right = right

        # SET Y POSITION
        unless scope.top || scope.bottom
          top = null
          bottom = null
          if scope.position == 'left' || scope.position == 'right'
            top = $(attachTo).offset().top
          else if scope.position == 'bottom'
            top = $(attachTo).offset().top + $(attachTo).outerHeight() + yMargin
          else if scope.position == 'top'
            bottom = $(window).height() - $(attachTo).offset().top + yMargin
            

          if curStep['yOffset']
            top = top + curStep['yOffset'] if top != null
            bottom = bottom - curStep['yOffset'] if bottom != null
          scope.top = top
          scope.bottom = bottom

      if scope.position && scope.position.length
        scope.positionClass = "onboarding-#{scope.position}"
      else
        scope.positionClass = null

    if scope.steps.length && !scope.index
      scope.index = 0

  template: """
              <div class='onboarding-container' ng-show='enabled'>
                <div class='{{overlayClass}}' ng-style='{opacity: overlayOpacity}', ng-show='overlay'></div>
                <div class='{{popoverClass}} {{positionClass}}' ng-style="{width: width, height: height, left: left, top: top, right: right, bottom: bottom}">
                  <div class='{{arrowClass}}'></div>
                  <h3 class='{{titleClass}}' ng-show='title' ng-bind='title'></h3>
                  <a href='' ng-click='close()' class='{{closeButtonClass}}' ng-bind-html='closeButtonText'></a>
                  <div class='{{contentClass}}'>
                    <p ng-bind-html='description'></p>
                  </div>
                  <div class='{{buttonContainerClass}}' ng-show='showButtons'>
                    <span ng-show='showStepInfo' class='{{stepClass}}'>Step {{index + 1}} of {{stepCount}}</span>
                    <a href='' ng-click='previous()' ng-show='showPreviousButton' class='{{buttonClass}}' ng-bind-html='previousButtonText'></a>
                    <a href='' ng-click='next()' ng-show='showNextButton' class='{{buttonClass}}' ng-bind-html='nextButtonText'></a>
                    <a href='' ng-click='close()' ng-show='showDoneButton && lastStep' class='{{buttonClass}}' ng-bind-html='doneButtonText'></a>
                  </div>
                </div>
              </div>
            """
]
