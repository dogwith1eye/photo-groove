// src/App.js
import React from "react";
import { jsCounter as Counter } from "../output/Counter.Interop";
import { jsEffcounter as Effcounter } from "../output/Effcounter.Interop";

function App() {
  return (
    <div>
      <h1>My App</h1>
      <Counter />
      <br />
      <Counter label="Huh" count="10" />
      <br />
      <Effcounter />
      <br />
      <Effcounter counterType="decrement" onClick={x => console.log("clicked: ", x)} />
    </div>
  );
}

export default App;
