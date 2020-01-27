// src/App.js
import React from "react";

const App = () => {
  const urlPrefix = "http://elm-in-action.com/";
  const thumbnails = [{ url: "1.jpeg" }, { url: "2.jpeg" }, { url: "3.jpeg" }];

  const viewThumbnailCol = thumb => (
    <div class="columns">{viewThumbnail(thumb)}</div>
  );

  const viewThumbnail = thumb => (
    <figure class="image is-200by267 is-marginless">
      <img key={thumb.url} src={urlPrefix + thumb.url} />
    </figure>
  );

  return (
    <section class="section">
      <div class="content">
        <h1>Photo Groove</h1>
        <div>{thumbnails.map(viewThumbnailCol)}</div>
      </div>
    </section>
  );
};

export default App;
