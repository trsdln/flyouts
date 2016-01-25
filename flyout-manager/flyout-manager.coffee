class Flyout
  constructor: (@_flyoutDoc, @_manager) ->

  _notifyAboutFlyoutChange: -> @_manager._updateFlyout @_flyoutDoc

  close: () ->
    #trigger hide animation first
    @_flyoutDoc.visible = false
    @_notifyAboutFlyoutChange()

    #then remove template from dom
    removeTemplateCb = => @_manager._removeFlyout @_flyoutDoc

    #todo: make this delay configurable (in case of custom animation)
    Meteor.setTimeout removeTemplateCb, 500

  updateData: (newDataContext) ->
    @_flyoutDoc.data = newDataContext
    @_notifyAboutFlyoutChange()


class _FlyoutManager
  constructor: () ->
    @_flyoutTemplates = new Mongo.Collection(null)

  _getInstanceById: (id) ->
    doc = @_flyoutTemplates.findOne({_id: id})
    return new Flyout(doc, @)

  _updateFlyout: (updatedFlyout) ->
    updateQuery = _.clone updatedFlyout
    delete updateQuery._id
    @_flyoutTemplates.update {_id: updatedFlyout._id}, {$set: updateQuery}

  _removeFlyout: (flyoutToRemove) ->
    @_flyoutTemplates.remove {_id: flyoutToRemove._id}

  removeAllFlyoutes: ->
    @_flyoutTemplates.update({}, {$set: {visible: false}}, {multi: true})
    Meteor.setTimeout =>
      @_flyoutTemplates.remove({})
    , 500

  closeLastFlyout: ->
    lastFlyoutDoc = @_flyoutTemplates.findOne({}, {
      skip: @_flyoutTemplates.find({}).count() - 1
    })
    @_flyoutTemplates.update({_id: lastFlyoutDoc._id}, {
      $set: {visible: false}
    }, {multi: true})
    Meteor.setTimeout =>
      @_flyoutTemplates.remove({_id: lastFlyoutDoc._id})
    , 500

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
    FlyoutManager.closeLastFlyout()