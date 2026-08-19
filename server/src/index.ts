import express from "express";
import errorMiddleware from "./middlewares/error.middleware.js";

const app = express();

app.get("/", (req, res) => {
    res.send("Hello World");
});


app.use(errorMiddleware)

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
