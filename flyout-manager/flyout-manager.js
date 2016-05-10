class Flyout {
  constructor(flyoutDoc, manager) {
    this._flyoutDoc = flyoutDoc;
    this._manager = manager;
  }

  close() {
    return this._manager._closeById(this._flyoutDoc._id);
  }

  updateData(newDataContext) {
    this._flyoutDoc.data = newDataContext;
    return this._manager._updateFlyout(this._flyoutDoc);
  }

  isTopBack() {
    return this._manager._getFirstFlyout()._id === this._flyoutDoc._id;
  }
}

class _FlyoutManager {
  constructor() {
    this._flyoutTemplates = new Mongo.Collection(null);
  }

  _getAnimationDuration() {
    return 1000 * parseFloat($('.show-flyout').css('animation-duration'));
  }

  _getInstanceById(id) {
    let doc = this._flyoutTemplates.findOne({ _id: id });
    return new Flyout(doc, this);
  }

  _updateFlyout(updatedFlyout) {
    return this._flyoutTemplates.update({ _id: updatedFlyout._id }, { $set: _.omit(updatedFlyout, '_id') });
  }

  _closeById(id) {
    let updateQuery = id ? { _id: id } : {};
    this._flyoutTemplates.update(updateQuery, { $set: { visible: false } }, { multi: true });

    return Meteor.setTimeout(() => {
      this._flyoutTemplates.remove(updateQuery);
    }, this._getAnimationDuration());
  }

  _getFirstFlyout() {
    return this._flyoutTemplates.findOne({});
  }

  _getLastFlyout() {
    let totalFlyoutCount = this._flyoutTemplates.find({}).count();
    return this._flyoutTemplates.findOne({}, {
      skip: totalFlyoutCount - 1
    });
  }

  closeAll() {
    return this._closeById();
  }

  closeLast() {
    let lastFlyout = this._getLastFlyout();
    if (lastFlyout) {
      return this._closeById(lastFlyout._id);
    }
  }

  open(templateName, data) {
   let flyoutDoc = {
      name: templateName,
      data: data
    };
    flyoutDoc._id = this._flyoutTemplates.insert(flyoutDoc);
    return new Flyout(flyoutDoc, this);
  }

  getInstanceByElement(domElement) {
    let  currentFlyoutElement = $(domElement).closest('.flyout');
    let flyoutData = Blaze.getData(currentFlyoutElement[0]);
    return this._getInstanceById(flyoutData._id);
  }
}

let flyoutManager = new _FlyoutManager();
flyoutManager.open = _.throttle(flyoutManager.open, 1000, {
  trailing: false
});

this.FlyoutManager = flyoutManager;

Template.FlyoutManager.helpers({
  templates() {
    return flyoutManager._flyoutTemplates.find({});
  },
  hasOpenedFlyouts() {
    return flyoutManager._flyoutTemplates.find({}).count() > 0;
  }
});

Template.FlyoutManager.events({
  'click .flyout-backdrop'() {
    return FlyoutManager.closeLast();
  }
});
