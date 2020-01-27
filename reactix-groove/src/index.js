// src/index.js
import React from "react";
import ReactDOM from "react-dom";
//import App from "./javascript/App";
import { mkApp as App } from "./output/App";
import "./style/bulma.css";

ReactDOM.render(<App />, document.getElementById("root"));
