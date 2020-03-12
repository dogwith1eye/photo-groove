//var Main = require("./output/Main");
import { h, createApp } from "@vue/runtime-dom";
import { mkApp5 as AppF } from "./output/AppF";

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

  const ContainerComponentF = (props, ctx) => {
    return h("div", { class: "container" }, [h("div", "f hello world")]);
  };

  const AppComponentF = (props, ctx) => {
    console.log(ContainerComponentF);
    return h(ContainerComponentF, () => []);
  };

  const AppComponentFF = (props, ctx) => {
    return h(
      (a, b) => {
        return h("div", { class: "container" }, [h("div", "ff hello world")]);
      },
      () => []
    );
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

  const ContainerComponentSlotF = (props, ctx) => {
    return h("div", { class: "container" }, [ctx.slots.default()]);
  };

  const AppComponentSlotF = (props, ctx) => {
    return h(ContainerComponentSlotF, [h("div", "f hello slot")]);
  };

  const AppComponentSlotFF = (props, ctx) => {
    return h(ContainerComponentSlotF, ["ff hello slot"]);
  };

  const AppComponentSlotFFF = (props, ctx) => {
    return h(ContainerComponentSlotF, sprops => ["ff hello slot"]);
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

  const ContainerComponentSlotTextF = (props, ctx) => {
    return h("div", { class: "container" }, [
      ctx.slots.default({ text: "f hello slot text" })
    ]);
  };

  const AppComponentSlotTextF = (props, ctx) => {
    return h(ContainerComponentSlotTextF, sprops => [h("div", sprops.text)]);
  };

  const AppComponentSlotTextFF = (props, ctx) => {
    return h(ContainerComponentSlotTextF, sprops => [h("div", sprops)]);
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

  const ContainerComponentSlotTextFooF = (props, ctx) => {
    return h("div", { class: "container" }, [
      ctx.slots.foo({ text: "f hello slot text foo" })
    ]);
  };

  const AppComponentSlotTextFooF = (props, ctx) => {
    return h(ContainerComponentSlotTextFooF, null, {
      foo: fooProps => [h("div", fooProps.text)]
    });
  };

  createApp(AppF).mount("#app");
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
