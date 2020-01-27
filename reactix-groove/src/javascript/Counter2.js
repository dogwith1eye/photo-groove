// src/Counter.js
import React, { useState } from "react";

const Counter = props => {
  const [count, setCount] = useState(0);
  return (
    <button onClick={() => setCount(count + 1)}>
      {props.label}: {count}
    </button>
  );
};

export default Counter;
