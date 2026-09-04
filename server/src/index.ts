import express from "express";
import cors from "cors"
import errorMiddleware from "./middlewares/error.middleware.js";
import { platformRouter } from "./module/platfrom/index.js";
import  {userRouter}  from "./module/user/index.js";
import { ENV } from "./config/env.js";

const app = express();

// Global Middlewares
app.use(cors())
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Health check route
app.get("/", (_req, res) => {
  res.send("Hello World");
});

// API Routes
app.use("/api/v1/platform", platformRouter);
app.use("/api/v1/user", userRouter);

// Centralized Error Handling Middleware
app.use(errorMiddleware);

app.listen(ENV.PORT, () => {
  console.log("Server is running on port " + ENV.PORT);
});

