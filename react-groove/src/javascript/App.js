// src/App.js
import React from "react";
import { counterCpt as Counter } from "../output/Counter";
import { bicounterCpt as Bicounter } from "../output/Bicounter";

function App() {
  return (
    <div>
      <h1>My App</h1>
      <Counter count="0" />
      <br />
      <Bicounter count="0" />
    </div>
  );
}

export default App;
