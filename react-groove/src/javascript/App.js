// src/App.js
import React from "react";
import { jsCounter as Counter } from "../output/Counter.Interop";
import { bicounterCpt as Bicounter } from "../output/Bicounter";

function App() {
  return (
    <div>
      <h1>My App</h1>
      <Counter />
      <br />
      <Counter label="Huh" count="10" />
      <br />
      <Bicounter count="0" />
    </div>
  );
}

export default App;
