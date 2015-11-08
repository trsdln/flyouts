### flyouts

Easy customizable and reactive sidebar flyouts

### Example

Step 1: Include `FlyoutManager` in your app layout or in body (in case you don't have layouts)

```
{{> FlyoutManager}}
```

Step 2: Create template that will be showed as flyout

```
<template name="myCustomTemplate">
 <div class="flyout-header">
    <button class="close-flyout-button"> x </button>
  </div>
  <div class="flyout-content">
    {{yourMessage}}
  </div>
</template>
```
* Note: `close-flyout-button` is predefined class for close flyout button.
You don't need to add any event handlers for it.

Style it whatever you want (in example is used LESS):

```
@padding: 10px;
.flyout { // root node for each opened flyout
  background: #EEE;
  box-shadow: 0 0 7px rgba(0, 0, 0, 0.5);

  //some custom elements:
  .flyout-header {
    background: #CCC;
    padding: @padding;
    box-shadow: 1px 1px 4px rgba(0, 0, 0, 0.5)
  }

  .flyout-content {
    padding: @padding;
  }
}
```

Step 3: Open your template in flayout window when you need it

```
//open flyout
var yourFlyout = FlyoutManager.open('myCustomTemplate', {yourMessage: 'Hello, Flyouts!'});

//close flyout
yourFlyout.close()
```

Step 4: Have fun!

### Future work:

* Add some configuration abilities