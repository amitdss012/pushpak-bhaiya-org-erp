import express from "express";
import cors from "cors"
import morgan from "morgan"
import errorMiddleware from "./middlewares/error.middleware.js";
import { platformRouter } from "./module/platfrom/index.js";
import  {userRouter}  from "./module/user/index.js";
import { sessionRouter } from "./module/session/index.js";
import { branchRouter } from "./module/branch/index.js";
import { ENV } from "./config/env.js";

const app = express();

// Global Middlewares
app.use(cors())
app.use(express.json());
app.use(morgan('dev'))
app.use(express.urlencoded({ extended: true }));

// Health check route
app.get("/", (_req, res) => {
  res.send("Hello World");
});

// API Routes
app.use("/api/v1/platform", platformRouter);
app.use("/api/v1/user", userRouter);
app.use("/api/v1/session", sessionRouter);
app.use("/api/v1/branch", branchRouter);

// Centralized Error Handling Middleware
app.use(errorMiddleware);

app.listen(ENV.PORT, () => {
  console.log("Server is running on port " + ENV.PORT);
});

