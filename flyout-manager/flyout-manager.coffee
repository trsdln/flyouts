class Flyout
  constructor: (@_flyoutDoc, @_manager) ->

  close: ->
    @_manager._closeById(@_flyoutDoc._id)

  updateData: (newDataContext) ->
    @_flyoutDoc.data = newDataContext
    @_manager._updateFlyout @_flyoutDoc

  isTopBack: () ->
    @_manager._getFirstFlyout()._id is @_flyoutDoc._id


class _FlyoutManager
  constructor: () ->
    @_flyoutTemplates = new Mongo.Collection(null)

  _getAnimationDuration: ->
    1000 * parseFloat($('.show-flyout').css('animation-duration'))

  _getInstanceById: (id) ->
    doc = @_flyoutTemplates.findOne({_id: id})
    return new Flyout(doc, @)

  _updateFlyout: (updatedFlyout) ->
    @_flyoutTemplates.update {_id: updatedFlyout._id}, {
      $set: _.omit(updatedFlyout, '_id')
    }

  _closeById: (id) ->
    updateQuery = if id then {_id: id} else {}

    @_flyoutTemplates.update(updateQuery, {
      $set: {visible: false}
    }, {multi: true})

    Meteor.setTimeout =>
      @_flyoutTemplates.remove(updateQuery)
    , @_getAnimationDuration()

  _getFirstFlyout: () -> @_flyoutTemplates.findOne {}

  _getLastFlyout: () ->
    totalFlyoutCount = @_flyoutTemplates.find({}).count()
    @_flyoutTemplates.findOne {}, {skip: totalFlyoutCount - 1}

  closeAll: -> @_closeById()

  closeLast: -> @_closeById(@_getLastFlyout()._id)

  open: (templateName, data) ->
    flyoutDoc =
      name: templateName
      data: data

    flyoutDoc._id = @_flyoutTemplates.insert flyoutDoc

    return new Flyout(flyoutDoc, @)

  getInstanceByElement: (domElement) ->
#find out flyout id we are in
    currentFlyoutElement = $(domElement).closest('.flyout')
    flyoutData = Blaze.getData(currentFlyoutElement[0])

    #get instance and close
    @_getInstanceById flyoutData._id


flyoutManager = new _FlyoutManager()
flyoutManager.open = _.throttle(flyoutManager.open, 1000, {trailing: false})

@FlyoutManager = flyoutManager


Template.FlyoutManager.helpers
  templates: -> flyoutManager._flyoutTemplates.find({})
  hasOpenedFlyouts: -> flyoutManager._flyoutTemplates.find({}).count() > 0

Template.FlyoutManager.events
  'click .flyout-backdrop': ->
    FlyoutManager.closeLast()