Template.Flyout.helpers
  isHidden: -> @visible is false

Template.Flyout.events
  'click .close-flyout-button': (event, tmpl) ->
#    find out flyout id we are in
    currentFlyoutElement = tmpl.$(event.target).closest('.flyout')
    flyoutData = Blaze.getData(currentFlyoutElement[0])

    #get instance and close
    flyout = FlyoutManager._getInstanceById flyoutData._id
    flyout.close()