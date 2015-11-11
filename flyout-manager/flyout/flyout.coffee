Template.Flyout.helpers
  isHidden: -> @visible is false

  isFlowComponent: -> @isFlowComponent

  componentConfig: ->
    componentProps = _.clone @data
    _.extend componentProps,
      component: @name

Template.Flyout.events
  'click .close-flyout-button': (event, tmpl) ->
#    find out flyout id we are in
    currentFlyoutElement = tmpl.$(event.target).closest('.flyout')
    flyoutData = Blaze.getData(currentFlyoutElement[0])

    #get instance and close
    flyout = FlyoutManager._getInstanceById flyoutData._id
    flyout.close()