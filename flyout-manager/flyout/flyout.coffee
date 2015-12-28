Template.Flyout.helpers
  isHidden: -> @visible is false


Template.Flyout.events
  'click .close-flyout-button': (event) ->
    flyout = FlyoutManager.getInstanceByElement event.target
    flyout.close()