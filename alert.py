from gradio.events import Dependency


def submit_success_alert(submit: Dependency):
    js_code = """
function () {
if (!("Notification" in window)) {
  console.log("This browser does not support desktop notification");
} else {
  Notification.requestPermission().then(function (permission) {
  });
}
}()
"""
    # if (permission === "granted") {
    #   const notification = new Notification("Title", {body: "Exec Success",});
    #
    #
    # }
    # return
    def alert():
        print("success")
        return "Success"
    submit.then(None,_js=js_code)
    # submit.success(alert)
