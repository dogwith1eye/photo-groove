// src/App.js
import React from "react";
import Counter from "./Counter1";

function App() {
  return (
    <div>
      <Counter label="Count" />
      <br />
      <Counter label="Clicks" />
      <br />
      <Counter label="Interactions" />
    </div>
  );
}

export default App;
