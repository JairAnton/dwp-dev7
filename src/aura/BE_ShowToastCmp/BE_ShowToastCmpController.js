({
  invoke: function (component, event, helper) {
    var title = component.get("v.title");
    var message = component.get("v.message");
    var type = component.get("v.type").toLowerCase();
    var mode = component.get("v.mode").toLowerCase(); //force user entered attribute to all lowercase

    helper.showToast(title, message, type, mode);
  }
});