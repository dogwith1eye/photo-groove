// src/App.js
import React from "react";
import Counter from "./Counter2";

function App() {
  return (
    <div>
      <Counter label="Count" />
      <br />
      <Counter label="Clicks" />
      <br />
      <Counter label="Interactions" />
      <br />
      <Counter />
    </div>
  );
}

export default App;
