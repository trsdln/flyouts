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
    Meteor.setTimeout removeTemplateCb, 1000

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

  open: (templateName, data, isFlowComponent) ->
    flyoutDoc =
      name: templateName
      data: data
      isFlowComponent: isFlowComponent

    flyoutDoc._id = @_flyoutTemplates.insert flyoutDoc

    return new Flyout(flyoutDoc, @)

  getInstanceByElement: (domElement) ->
    #find out flyout id we are in
    currentFlyoutElement = $(domElement).closest('.flyout')
    flyoutData = Blaze.getData(currentFlyoutElement[0])

    #get instance and close
    @_getInstanceById flyoutData._id


flyoutManager = new _FlyoutManager()

@FlyoutManager = flyoutManager


Template.FlyoutManager.helpers
  templates: -> flyoutManager._flyoutTemplates.find({})
  hasOpenedFlyouts: -> flyoutManager._flyoutTemplates.find({}).count() > 0

