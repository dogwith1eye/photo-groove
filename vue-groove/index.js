//var Main = require("./output/Main");
import { h, createApp } from "@vue/runtime-dom";
import { mkAppChild as App } from "./output/App";

function main() {
  /*
    Here we could add variables such as

    var baseUrl = process.env.BASE_URL;

    Parcel will replace `process.env.BASE_URL`
    with the string contents of the BASE_URL environment
    variable at bundle/build time.
    A .env file can also be used to override shell variables
    for more information, see https://en.parceljs.org/env.html

    These variables can be supplied to the Main.main function.
    However, you will need to change the type to accept variables, by default it is an Effect.
    You will probably want to make it a function from String -> Effect ()
  */

  //Main.main();
  const ContainerComponent = {
    render() {
      return h("div", { class: "container" }, [h("div", "hello world")]);
    }
  };

  const AppComponent = {
    render() {
      return h(ContainerComponent, () => []);
    }
  };

  const ContainerComponentSlot = {
    render() {
      return h("div", { class: "container" }, [this.$slots.default()]);
    }
  };

  const AppComponentSlot = {
    render() {
      return h(ContainerComponentSlot, [h("div", "hello slot")]);
    }
  };

  const ContainerComponentSlotText = {
    render() {
      return h("div", { class: "container" }, [
        this.$slots.default({ text: "hello slot text" })
      ]);
    }
  };

  const AppComponentSlotText = {
    render() {
      return h(ContainerComponentSlotText, props => [h("div", props.text)]);
    }
  };

  const ContainerComponentSlotTextFoo = {
    render() {
      return h("div", { class: "container" }, [
        this.$slots.foo({ text: "hello slot text foo" })
      ]);
    }
  };

  const AppComponentSlotTextFoo = {
    render() {
      return h(ContainerComponentSlotTextFoo, null, {
        foo: props => [h("div", props.text)]
      });
    }
  };

  createApp(AppComponentSlotTextFoo).mount("#app");
}

// HMR setup. For more info see: https://parceljs.org/hmr.html
if (module.hot) {
  module.hot.accept(function() {
    console.log("Reloaded, running main again");
    main();
  });
}

console.log("Starting app");

main();
