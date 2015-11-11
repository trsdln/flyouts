Template.Flyout.helpers
  isHidden: -> @visible is false

  isFlowComponent: -> @isFlowComponent

  componentConfig: ->
    componentProps = _.clone @data
    _.extend componentProps,
      component: @name

Template.Flyout.events
  'click .close-flyout-button': (event) ->
    FlyoutManager.close event.target